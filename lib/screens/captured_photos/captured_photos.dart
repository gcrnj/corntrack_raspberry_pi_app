import 'package:corntrack_raspberry_pi_app/app_router.dart';
import 'package:corntrack_raspberry_pi_app/screens/error/error_widget.dart';
import 'package:corntrack_raspberry_pi_app/services/photos_services.dart';
import 'package:corntrack_utils/utils/colors_utility.dart';
import 'package:corntrack_utils/utils/string_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/api_data.dart';
import '../../data/moisture_reading_data.dart';
import '../../data/photos_data.dart';
import '../../utility/prefsKeys.dart';

class CapturedPhotos extends ConsumerStatefulWidget {
  final PhotosData? photoData;
  final bool hasUrl;

  CapturedPhotos({super.key, this.photoData})
      : hasUrl = photoData != null && photoData.fileUrl.isNotEmpty;

  @override
  ConsumerState<CapturedPhotos> createState() => _CapturedPhotosState();
}

class _CapturedPhotosState extends ConsumerState<CapturedPhotos> {
  final PhotosServices photoService = PhotosServiceFactory.create();
  late final FutureProvider<ApiData<List<PhotosData>>> photosProvider;
  final deviceIdProvider = StateProvider<String>((ref) => '');
  final selectedHealthProvider = StateProvider<String?>((ref) => 'All');
  final selectedStageProvider = StateProvider<String?>((ref) => 'All');

  @override
  void initState() {
    photosProvider = FutureProvider<ApiData<List<PhotosData>>>((ref) async {
      String deviceId = ref.watch(deviceIdProvider);
      String? selectedHealth = ref.watch(selectedHealthProvider);
      String? selectedStage = ref.watch(selectedStageProvider);

      if (deviceId.isEmpty) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        ref.read(deviceIdProvider.notifier).state =
            prefs.getString(PrefKeys.deviceId.name) ?? '';
      }
      print("Getting captured photos with deviceId=$deviceId");
      ApiData<List<PhotosData>> apiData =
          await photoService.getAll(deviceId ?? '');
      final filteredData = apiData.data?.where((element) {
            final status = element.metaData.healthStatus;
            final isSelectedStatus =
                (selectedHealth == 'All' || status == selectedHealth);

            final stage = element.metaData.growthStage;
            final isSelectedStage =
                (selectedStage == 'All' || stage == selectedStage);

            return isSelectedStatus && isSelectedStage;
          }).toList() ??
          List.empty();
      ApiData<List<PhotosData>> filteredApiData =
          apiData.copyWithSuccess(data: filteredData);
      print(
          "Result of captured photos = ${apiData.isSuccess} - ${apiData.error} - ${apiData.data?.length}");
      print(
          "Result of filtered captured photos = ${filteredApiData.isSuccess} - ${filteredApiData.error} - ${filteredApiData.data?.length}");
      return filteredApiData;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final photoUrls = ref.watch(photosProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.hasUrl ? 'Photo Details' : 'Captured Photos'),
        actions: widget.hasUrl
            ? List.empty()
            : [
                // Health Classification
                SizedBox(
                  width: 150,
                  child: DropdownButton<String>(
                    isExpanded: true, // Ensures the arrow aligns right
                    value: ref.watch(selectedHealthProvider),
                    onChanged: (String? newValue) {
                      print('Newww');
                    },
                    items: [
                      'Healthy',
                      'Unhealthy',
                      'All',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                        onTap: () {
                          ref.read(selectedHealthProvider.notifier).state =
                              value;
                        },
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  width: 25,
                ),
                // Stages
                SizedBox(
                  width: 150,
                  child: DropdownButton<String>(
                    value: ref.watch(selectedStageProvider),
                    onChanged: (String? newValue) {
                      ref.read(selectedStageProvider.notifier).state = newValue;
                    },
                    items: [
                      'All',
                      'V6',
                      'V7',
                      'V8',
                      'V9',
                      'R1',
                      'R2',
                      'R3',
                      'R4',
                      'R5',
                      'R6',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [],
            ),
            widget.hasUrl ? photoDetailsView() : photosView(photoUrls)
          ],
        ),
      ),
    );
  }

  Widget photosView(AsyncValue<ApiData<List<PhotosData>>> asyncValue) {
    return asyncValue.when(data: (apiData) {
      final photosDataList = apiData.data ?? List.empty();
      return Expanded(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5, // Five columns
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 1.0, // Maintain square aspect ratio
          ),
          itemCount: photosDataList.length,
          itemBuilder: (context, index) {
            final photoData = photosDataList.elementAt(index);
            String photoDataUrl = photoData.fileUrl ?? '';
            String healthStatus =
                photoData.metaData.healthStatus ?? 'Unlabeled';
            String stage = photoData.metaData.growthStage ?? 'Unlabeled';
            String camera = photoData.metaData.camera == null ? '' : 'Camera ${photoData.metaData.camera.toString()}';
            String upperText = camera.isEmpty ? photoData.parseDateTime() : '${photoData.parseDateTime()}\n$camera';
            return InkWell(
              onTap: () {
                appRouter.go('/dashboard/captured_photos/photo_details',
                    extra: photoData);
              },
              child: Container(
                color: semiBlackColor,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    children: [
                      Image.network(
                        width: double.infinity,
                        photoDataUrl,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Container(
                              color: errorRedBackgroundColor,
                              child: Text('Failed to load image',
                                  style: TextStyle(color: errorRedTextColor)),
                            ),
                          );
                        },
                      ),
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          color: semiBlackColor.withAlpha(80),
                          child: Text(
                            upperText,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: healthStatus == 'Healthy'
                                ? healthyTextColor.withAlpha(50)
                                : healthStatus == 'Unhealthy'
                                    ? unhealthyTextColor.withAlpha(50)
                                    : Colors.black,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            healthStatus,
                            style: TextStyle(
                              color: healthStatus == 'Healthy'
                                  ? healthyTextColor
                                  : healthStatus == 'Unhealthy'
                                      ? unhealthyTextColor
                                      : semiBlackColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: healthyTextColor.withAlpha(50),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            stage,
                            style: TextStyle(
                              color: healthyTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
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
    PhotosData photoData = widget.photoData!; // Use the original URL
    print('path: ${photoData.fileUrl}');
    String healthStatus = photoData.metaData.healthStatus ?? 'Unlabeled';
    String growthStage = photoData.metaData.growthStage ?? 'Unlabeled';

    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          photoData.parseDateOnly(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          photoData.parseTimeOnly(),
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(
                              Icons.favorite,
                              color: healthStatus == 'Healthy'
                                  ? healthyTextColor
                                  : healthStatus == 'Unhealthy'
                                      ? unhealthyTextColor
                                      : semiBlackColor,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Health: $healthStatus',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.grass, color: Colors.orangeAccent),
                            const SizedBox(width: 8),
                            Text(
                              'Stage: $growthStage',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: InteractiveViewer(
                      child: Image.network(
                        photoData.fileUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          print('Error: $error');
                          return Center(
                            child: Text(
                              "Failed to load image",
                              style: TextStyle(color: Colors.red, fontSize: 18),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String imageUrl(String path) {
    String codedPath = path.replaceAll('/', '%2F'); // Ensures proper encoding
    String deviceId = ref.watch(deviceIdProvider);
    print(baseFirebaseStorageUrl);
    print('captured_photos%2F');
    print(deviceId);
    return baseFirebaseStorageUrl +
        'captured_photos%2F$deviceId%2F$codedPath?alt=media';
  }
}
