import 'package:corntrack_raspberry_pi_app/data/moisture_reading_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_table_view/material_table_view.dart';

import '../../data/api_data.dart';
import '../../services/moisture_reading_services.dart';
import '../dashboard/dashboard_screen.dart';
import '../error/error_widget.dart';
import '../range_date_picker/range_date_picker.dart';

class SoilMoistureReport extends ConsumerStatefulWidget {
  final List<Pots> selectedCornPots;

  const SoilMoistureReport({super.key, required this.selectedCornPots});

  @override
  ConsumerState<SoilMoistureReport> createState() => _SoilMoistureReportState();
}

class _SoilMoistureReportState extends ConsumerState<SoilMoistureReport> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  final moistureReadingService = MoistureReadingServiceFactory.create();
  late final FutureProvider<ApiData<List<MoistureReadingData>>>
      temperatureProvider;

  @override
  void initState() {
    temperatureProvider =
        FutureProvider<ApiData<List<MoistureReadingData>>>((ref) async {
      print('Fetching Soil Moisture Report from $startDate to $endDate');
      return await moistureReadingService.getSoilMoistureData(
          startDate, endDate, widget.selectedCornPots);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final temperatureData = ref.watch(temperatureProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Soil Moisture Report'),
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: RangeDatePicker(
              onDateSelected: _onDateSelected,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: temperatureData.when(
                data: (ApiData<List<MoistureReadingData>> data) {
                  if (data.isSuccess && data.data != null) {
                    return TableView.builder(
                      // Add Header
                      headerBuilder: (context, contentBuilder) {
                        return ColoredBox(
                          color: Colors.blueGrey[100]!,
                          // Header background color
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
                        // Time Column
                        TableColumn(width: 200),
                        // Temperature Column
                        TableColumn(width: 100),
                        TableColumn(width: 200),
                        // Temperature Column
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
                                    text = item.pot;
                                  case 1:
                                    text = item.formattedDate();
                                  case 2:
                                    text = item.formattedTime();
                                  case 3:
                                    text = item.moisture;
                                  case 4:
                                    text = item.temperature ?? '';
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
                loading: () => CircularProgressIndicator(),
                error: (error, stackTrace) => Center(
                  child: errorWidget(
                    error.toString(),
                    onPressed: () => _onDateSelected(startDate, endDate),
                  ),
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
    ref.refresh(temperatureProvider.future);
  }
}
