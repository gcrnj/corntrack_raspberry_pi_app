import 'package:collection/collection.dart';
import 'package:corntrack_raspberry_pi_app/api/flask_api.dart';
import 'package:corntrack_raspberry_pi_app/app_router.dart';
import 'package:corntrack_raspberry_pi_app/data/api_data.dart';
import 'package:corntrack_raspberry_pi_app/data/failed_upload_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../services/failed_upload_service.dart';
import '../dashboard/dashboard_screen.dart';
import '../error/error_widget.dart';

class FailedUploadsWidget extends ConsumerStatefulWidget {
  final String deviceId;

  const FailedUploadsWidget({super.key, required this.deviceId});

  @override
  ConsumerState<FailedUploadsWidget> createState() =>
      _FailedUploadsWidgetState();
}

class _FailedUploadsWidgetState extends ConsumerState<FailedUploadsWidget> {
  late final FutureProvider<ApiData<List<FailedUploadData>>>
  failedUploadsProvider;
  final failedUploadService = FailedUploadServiceFactory.create();
  final isLoadingButtonProvider = StateProvider<bool>((ref) => false);

  @override
  void initState() {
    failedUploadsProvider = FutureProvider((ref) async {
      print("heyyy1");
      final failedUploads = await failedUploadService.getAllFailedUploads(
          widget.deviceId);
      print("A${failedUploads.data?.length ?? '123'}");
      print(failedUploads.error.toString());
      return failedUploads;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final failedUploadsAsync = ref.watch(failedUploadsProvider);

    return failedUploadsAsync.when(
      data: (data) {
        final failedUploads = data.data ?? List.empty();

        if(!data.isSuccess) {
          return Center(
            child: Text(data.error ?? 'Something went wrong'),
          );
        } else if (failedUploads.isEmpty) {
          return Column(
            children: [Text("You're all set!")],
          );
        }
        print('data ${failedUploads.length}');

        for (var value in failedUploads) {
          print('Value - ${value.dataType}');
        }
        final failedImages = failedUploads
            .where((element) => element.dataType == FailedUploadDataType.photo)
            .sorted((a, b) => a.dateTime.compareTo(b.dateTime))
            .toList();

        final failedNonImages = failedUploads
            .where((element) => element.dataType != FailedUploadDataType.photo)
            .sorted((a, b) => a.dateTime.compareTo(b.dateTime))
            .toList();

        // final failedMoisture = getFailedUploadByType(
        //     data: failedUploads, dataType: FailedUploadDataType.moisture);
        // final failedTemperatureImages = getFailedUploadByType(
        //     data: failedUploads, dataType: FailedUploadDataType.temperature);
        // final failedDistributionImages = getFailedUploadByType(
        //     data: failedUploads,
        //     dataType: FailedUploadDataType.waterDistribution);

        return Column(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 12),
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _FailedUploadsList(
                          url: failedUploadService.failedUploadApi.baseUrl,
                          isImage: true,
                          datedFailedData: groupFailedUploadsByDate(
                            failedImages,
                          ),
                        ),

                        _FailedUploadsList(
                          url: failedUploadService.failedUploadApi.baseUrl,
                          header: 'Corn 1',
                          datedFailedData: groupFailedUploadsByDate(
                            failedNonImages,
                          ),
                        ),

                        _FailedUploadsList(
                          url: failedUploadService.failedUploadApi.baseUrl,
                          header: 'Corn 2',
                          datedFailedData: groupFailedUploadsByDate(
                            failedNonImages,
                          ),
                        ),

                        _FailedUploadsList(
                          url: failedUploadService.failedUploadApi.baseUrl,
                          header: 'Corn 3',
                          datedFailedData: groupFailedUploadsByDate(
                            failedNonImages,
                          ),
                        ),

                        // Other
                        //failedNonImages
                      ]),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: retryButtonWidget(failedUploads),
            ),
          ],
        );
      },
      error: (error, stackTrace) {
        print('error in failed uploads $error');
        return Center(
          child: errorWidget(
            error.toString(),
            onPressed: () => ref.refresh(failedUploadsProvider.future),
          ),
        );
      },
      loading: () {
        print('loading');
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget retryButtonWidget(List<FailedUploadData>? failedUploadList) {
    final isLoading = ref.watch(isLoadingButtonProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                'Total: ${failedUploadList?.length ?? 0}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: FilledButton(
                onPressed: isLoading ? null : () async {
                  ref.read(isLoadingButtonProvider.notifier).state = true;
                  final failedUpload = await failedUploadService.manualUpload(widget.deviceId);
                  ref.refresh(failedUploadsProvider.future);
                  ref.read(isLoadingButtonProvider.notifier).state = false;
                  },
                child: isLoading ? CircularProgressIndicator() : Text(
                  'Manual Upload',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<FailedUploadData> getFailedUploadByType(
      {required List<FailedUploadData>? data,
        required FailedUploadDataType dataType}) {
    if (data == null) return List.empty();
    return data.where((element) => element.dataType == dataType).toList();
  }

  Map<DateTime, List<FailedUploadData>> groupFailedUploadsByDate(
      List<FailedUploadData> failedUploads) {
    var filteredFailedData = failedUploads;
    var groupedByDate = groupBy(filteredFailedData, (FailedUploadData data) {
      return DateTime(data.dateTime.year, data.dateTime.month,
          data.dateTime.day, data.dateTime.hour, data.dateTime.minute);
    });


    return groupedByDate;
  }
}

class _FailedUploadsList extends StatelessWidget {
  final Map<DateTime, List<FailedUploadData>> datedFailedData;

  final String? header;
  final bool isImage;
  final String url;

  const _FailedUploadsList(
      {required this.datedFailedData, this.header, this.isImage = false, required this.url});

  @override
  Widget build(BuildContext context) {
    return datedFailedData.isEmpty
        ? SizedBox()
        : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (header != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                header!,
                style:
                TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.arrow_drop_down_rounded),
              ),
            ],
          ),
        ...datedFailedData.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Date
              Text(
                _formatDate(entry.key),
                style:
                TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              // List of failed non-images for this date
              ...entry.value.map((data) {
                // String imageUrl = '$url/${data.image ?? ''}';
                String imageUrl = "$url/failed-uploads/uploads/${data.image ?? ''}";
                print('imageUrl = $imageUrl');
                return isImage
                    ? Image.network(imageUrl, width: MediaQuery.of(context).size.width / 2,)
                    : ListTile(
                  leading: Icon(Icons.arrow_forward_ios_rounded),
                  title: Text(data.dataType
                      .getDisplayName()), // Customize based on data properties
                );
              }),
            ],
          );
        }),
        SizedBox(height: 10), // Space between different dates
      ],
    );
  }

  // Helper function to format DateTime
  String _formatDate(DateTime date) {
    String formattedDate() {
      return DateFormat.yMMMMd().format(date);
    }

    String formattedTime() {
      return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString()
          .padLeft(2, '0')}";
    }

    return "${formattedDate()} @ ${formattedTime()}";
  }
}
