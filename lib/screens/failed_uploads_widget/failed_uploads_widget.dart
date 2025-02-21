import 'package:corntrack_raspberry_pi_app/data/api_data.dart';
import 'package:corntrack_raspberry_pi_app/data/failed_upload_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/failed_upload_service.dart';

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
    final failedUploads = ref.watch(failedUploadsProvider);

    return failedUploads.when(
      data: (data) {
        print('data ${data.data?.length}');
        return Column(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 12),
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: data.data?.map((failedUpload) {
                          return _FailedUploadWidget(
                            failedDUploadsData: failedUpload,
                          ) as Widget;
                        }).toList() ??
                        List.empty(),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: retryButtonWidget(data.data?.length),
            ),
          ],
        );
      },
      error: (error, stackTrace) {
        print('error');
        return Center(child: errorWidget(error.toString()));
      },
      loading: () {
        print('loading');
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget errorWidget(String error) {
    return Column(
      children: [
        Text('Error: $error'),
        ElevatedButton(
          onPressed: () => ref.refresh(failedUploadsProvider.future),
          child: Text('Retry'),
        ),
      ],
    );
  }

  Widget retryButtonWidget(int? length) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                'Total: ${length ?? 0}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: FilledButton(
                onPressed: () => ref.refresh(failedUploadsProvider.future),
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
}

class _FailedUploadWidget extends StatelessWidget {
  final FailedUploadData failedDUploadsData;

  const _FailedUploadWidget({required this.failedDUploadsData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(failedDUploadsData.dateTime.toString()),
        // Todo
        // Image
        // Pot / Corn Number - Date Time - FailedUploadDataType - close button
      ],
    );
  }
}
