import 'package:corntrack_raspberry_pi_app/data/api_data.dart';
import 'package:corntrack_raspberry_pi_app/screens/range_date_picker/range_date_picker.dart';
import 'package:corntrack_raspberry_pi_app/services/moisture_reading_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_table_view/material_table_view.dart';
import 'package:material_table_view/table_view_typedefs.dart';

import '../../data/hourly_temperature_data.dart';
import '../error/error_widget.dart';

class HourlyTemperature extends ConsumerStatefulWidget {
  const HourlyTemperature({super.key});

  @override
  ConsumerState<HourlyTemperature> createState() => _HourlyTemperatureState();
}

class _HourlyTemperatureState extends ConsumerState<HourlyTemperature> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  final moistureReadingService = MoistureReadingServiceFactory.create();
  late final FutureProvider<ApiData<List<HourlyTemperatureData>>>
      temperatureProvider;

  @override
  void initState() {
    temperatureProvider =
        FutureProvider<ApiData<List<HourlyTemperatureData>>>((ref) async {
      print('Fetching Hourly Temperature from $startDate to $endDate');
      return await moistureReadingService.getHourlyTemperature(
          startDate, endDate);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final temperatureData = ref.watch(temperatureProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Hourly Temperature'),
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
                data: (ApiData<List<HourlyTemperatureData>> data) {
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
                                0: "Date",
                                1: "Time",
                                2: "Temperature (°C)",
                              };

                              return Align(
                                alignment: Alignment.center,
                                child: Text(
                                  headers[column] ?? "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      columns: [
                        TableColumn(width: 200, freezePriority: 1),
                        // Time Column
                        TableColumn(width: 200),
                        // Temperature Column
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
                                    text = item.formattedDate();
                                  case 1:
                                    text = item.formattedTime();
                                  case 2:
                                    text = item.temperature;
                                }
                                return Align(
                                  alignment: Alignment.center,
                                  child: Text(text),
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
