import 'package:collection/collection.dart';
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
  const FailedUploadsWidget({super.key});

  @override
  ConsumerState<FailedUploadsWidget> createState() =>
      _FailedUploadsWidgetState();
}

class _FailedUploadsWidgetState extends ConsumerState<FailedUploadsWidget> {
  late final FutureProvider<ApiData<List<FailedUploadData>>>
      failedUploadsProvider;
  final failedUploadService = FailedUploadServiceFactory.create();

  @override
  void initState() {
    failedUploadsProvider = FutureProvider((ref) async {
      final failedUploadService = FailedUploadServiceFactory.create();
      return await failedUploadService.getAllFailedUploads();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final failedUploadsAsync = ref.watch(failedUploadsProvider);

    return failedUploadsAsync.when(
      data: (data) {
        final failedUploads = data.data ?? List.empty();

        if (failedUploads.isEmpty) {
          return Column(
            children: [Text("You're all set!")],
          );
        }
        print('data ${failedUploads.length}');

        for (var value in failedUploads) {
          print('Value - ${value.dataType}');
        }
        final failedImages = failedUploads
            .where((element) => element.dataType == FailedUploadDataType.image)
            .sorted((a, b) => a.dateTime.compareTo(b.dateTime))
            .toList();

        final failedNonImages = failedUploads
            .where((element) => element.dataType != FailedUploadDataType.image)
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
                          isImage: true,
                          datedFailedData: groupFailedUploadsByDate(
                            failedImages,
                          ),
                        ),

                        _FailedUploadsList(
                          header: 'Corn 1',
                          datedFailedData: groupFailedUploadsByDate(
                            failedNonImages,
                            filterPot: Pots.pot1,
                          ),
                        ),

                        _FailedUploadsList(
                          header: 'Corn 2',
                          datedFailedData: groupFailedUploadsByDate(
                            failedNonImages,
                            filterPot: Pots.pot2,
                          ),
                        ),

                        _FailedUploadsList(
                          header: 'Corn 3',
                          datedFailedData: groupFailedUploadsByDate(
                            failedNonImages,
                            filterPot: Pots.pot3,
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
        print('error');
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
                onPressed: () => appRouter.go(
                  '/dashboard/manual_upload',
                  extra: failedUploadList,
                ),
                child: Text(
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
      List<FailedUploadData> failedUploads,
      {Pots? filterPot}) {
    var filteredFailedData = filterPot == null
        ? failedUploads
        : failedUploads.where((element) => element.pot == filterPot).toList();
    var groupedByDate = groupBy(filteredFailedData, (FailedUploadData data) {
      return DateTime(data.dateTime.year, data.dateTime.month,
          data.dateTime.day, data.dateTime.hour, data.dateTime.minute);
    });

    // Print the grouped map
    groupedByDate.forEach((key, value) {
      print("Date: $key");
      for (var item in value) {
        print("  - ${item.image}, Type: ${item.dataType}, Pot: ${item.pot}");
      }
    });

    return groupedByDate;
  }
}

class _FailedUploadsList extends StatelessWidget {
  final Map<DateTime, List<FailedUploadData>> datedFailedData;

  final String? header;
  final bool isImage;

  const _FailedUploadsList(
      {required this.datedFailedData, this.header, this.isImage = false});

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
                    ...entry.value.map((data) => isImage
                        ? Image.network(data.image ?? '')
                        : ListTile(
                            leading: Icon(Icons.arrow_forward_ios_rounded),
                            title: Text(data.dataType
                                .getDisplayName()), // Customize based on data properties
                          )),
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
      return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
    }

    return "${formattedDate()} @ ${formattedTime()}";
  }
}
