import 'package:corntrack_raspberry_pi_app/data/moisture_reading_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_table_view/material_table_view.dart';

import '../../data/api_data.dart';
import '../../services/moisture_reading_services.dart';
import '../dashboard/dashboard_screen.dart';
import '../error/error_widget.dart';
import '../range_date_picker/range_date_picker.dart';

class WaterDistributionReport extends ConsumerStatefulWidget {
  final List<Pots> selectedCornPots;

  const WaterDistributionReport({super.key, required this.selectedCornPots});

  @override
  ConsumerState<WaterDistributionReport> createState() =>
      _WaterDistributionReportState();
}

class _WaterDistributionReportState
    extends ConsumerState<WaterDistributionReport> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  final moistureReadingService = MoistureReadingServiceFactory.create();
  late FutureProvider<ApiData<List<MoistureReadingData>>>
      moistureReadingProvider;

  @override
  void initState() {
    final deviceDetails = ref.read(deviceDetailsProvider);
    moistureReadingProvider =
        FutureProvider<ApiData<List<MoistureReadingData>>>((ref) async {
      print('Fetching Hourly Temperature from $startDate to $endDate');
      print(deviceDetails?.deviceId);
      return await moistureReadingService.getSoilMoistureData(
        startDate,
        endDate,
        pots: widget.selectedCornPots,
        deviceId: deviceDetails?.deviceId ?? '',
        waterDistributed: true,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final moistureReadingData = ref.watch(moistureReadingProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Water Distribution'),
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: RangeDatePicker(
              onDateSelected: _onDateSelected,
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: moistureReadingData.when(
                data: (ApiData<List<MoistureReadingData>> data) {
                  if (data.isSuccess && data.data != null) {
                    return TableView.builder(
                      headerBuilder: (context, contentBuilder) {
                        return ColoredBox(
                          color: Colors.blueGrey[100]!,
                          child: contentBuilder(
                            context,
                            (context, column) {
                              const headers = {
                                0: "Pot",
                                1: "Date",
                                2: "Time",
                                3: "Soil Moisture",
                                4: "Temperature (°C)",
                              };
                              return Align(
                                alignment: Alignment.center,
                                child: Text(
                                  headers[column] ?? "",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      columns: [
                        TableColumn(width: 50, freezePriority: 1),
                        TableColumn(width: 200),
                        TableColumn(width: 200),
                        TableColumn(width: 100),
                        TableColumn(width: 200),
                      ],
                      rowCount: data.data!.length,
                      rowHeight: 56.0,
                      rowBuilder: (context, row, contentBuilder) {
                        final item = data.data![row];
                        return Material(
                          type: MaterialType.transparency,
                          child: InkWell(
                            onTap: () => print('Row $row clicked'),
                            child: contentBuilder(
                              context,
                              (context, column) {
                                String text = '';
                                switch (column) {
                                  case 0:
                                    text = item.pot.toString();
                                    break;
                                  case 1:
                                    text = item.formattedDate();
                                    break;
                                  case 2:
                                    text = item.formattedTime();
                                    break;
                                  case 3:
                                    text = item.moisture.toString();
                                    break;
                                  case 4:
                                    text = item.temperature.toString();
                                    break;
                                }
                                return Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    text,
                                    style: TextStyle(
                                        fontSize: column == 0 || column == 3
                                            ? 20
                                            : null),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                        child: Text(data.error ?? 'An error occurred'));
                  }
                },
                loading: () => Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stackTrace) => Center(
                  child: errorWidget(error.toString(),
                      onPressed: () => _onDateSelected(startDate, endDate)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onDateSelected(DateTime startDate, DateTime endDate) async {
    print('Start Date: $startDate, End Date: $endDate');
    this.startDate = startDate;
    this.endDate = endDate;
    ref.refresh(moistureReadingProvider);
  }
}
