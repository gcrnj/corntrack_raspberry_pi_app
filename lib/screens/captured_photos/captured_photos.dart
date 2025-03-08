import 'package:corntrack_raspberry_pi_app/app_router.dart';
import 'package:corntrack_raspberry_pi_app/screens/error/error_widget.dart';
import 'package:corntrack_raspberry_pi_app/services/photos_services.dart';
import 'package:corntrack_utils/utils/string_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/api_data.dart';
import '../../data/moisture_reading_data.dart';
import '../../data/photos_data.dart';
import '../../utility/prefsKeys.dart';

class CapturedPhotos extends ConsumerStatefulWidget {
  final String? url;
  final bool hasUrl;

  CapturedPhotos({super.key, this.url})
      : hasUrl = url != null && url.isNotEmpty;

  @override
  ConsumerState<CapturedPhotos> createState() => _CapturedPhotosState();
}

class _CapturedPhotosState extends ConsumerState<CapturedPhotos> {
  final PhotosServices photoService = PhotosServiceFactory.create();
  late final FutureProvider<ApiData<List<PhotosData>>> photosProvider;
  final deviceIdProvider = StateProvider<String>((ref) => '');

  @override
  void initState() {
    photosProvider = FutureProvider<ApiData<List<PhotosData>>>((ref) async {
      String deviceId = ref.watch(deviceIdProvider);
      if (deviceId.isEmpty) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        ref.read(deviceIdProvider.notifier).state = prefs.getString(PrefKeys.deviceId.name) ?? '';
      }

      print("Getting captured photos with deviceId=$deviceId");
      final apiData = await photoService.getAll(deviceId ?? '');
      print("Result of captured photos = ${apiData.isSuccess} - ${apiData.error} - ${apiData.data?.length}");
      return apiData;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final photoUrls = ref.watch(photosProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.hasUrl ? 'Photo Details' : 'Captured Photos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: widget.hasUrl ? photoDetailsView() : photosView(photoUrls),
      ),
    );
  }

  Widget photosView(AsyncValue<ApiData<List<PhotosData>>> asyncValue) {
    return asyncValue.when(data: (apiData) {
      final urls = apiData.data ?? List.empty();
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5, // Two columns
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 1.0, // Maintain square aspect ratio
        ),
        itemCount: urls.length,
        itemBuilder: (context, index) {
          String currentPath = urls.elementAt(index).path ?? '';
          return InkWell(
            onTap: () {
              appRouter.go('/dashboard/captured_photos/photo_details',
                  extra: currentPath);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                baseFirebaseStorageUrl + currentPath,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      );
    }, error: (error, stackTrace) {
      return errorWidget(
        error.toString(),
        onPressed: () => ref.refresh(photosProvider.future),
      );
    }, loading: () {
      return Center(
        child: CircularProgressIndicator(),
      );
    });
  }

  Widget photoDetailsView() {
    String path = imageUrl(widget.url!);
    print(path);
    return Column(
      children: [
        Text('Url: $path'),
        Image.network(
          path, // Ensure proper URL formatting
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child; // Image fully loaded

            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                    : null, // If total bytes are unknown, show an indeterminate progress
              ),
            );
          },
        )
      ],
    );
  }

  String imageUrl(String path) {
    String codedPath = path.replaceAll('/', '%2F'); // Ensures proper encoding
    String deviceId = ref.watch(deviceIdProvider);
    print(baseFirebaseStorageUrl);
    print('captured_photos%2F');
    print(deviceId);
    return baseFirebaseStorageUrl + 'captured_photos%2F$deviceId%2F$codedPath?alt=media';
  }
}
