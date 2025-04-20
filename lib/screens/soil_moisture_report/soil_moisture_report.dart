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

  DateTime startDate = DateTime.now()
      .copyWith(day: 1, hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
  DateTime endDate = DateTime.now().copyWith(
      hour: 23, minute: 59, second: 59, millisecond: 999, microsecond: 999);

  final moistureReadingService = MoistureReadingServiceFactory.create();
  late final FutureProvider<ApiData<List<MoistureReadingData>>>
      temperatureProvider;

  @override
  void initState() {
    final deviceDetails = ref.read(deviceDetailsProvider);
    temperatureProvider =
        FutureProvider<ApiData<List<MoistureReadingData>>>((ref) async {
      print('Fetching Soil Moisture Report from $startDate to $endDate');
      return await moistureReadingService.getSoilMoistureData(
          startDate, endDate,
          deviceId: deviceDetails?.deviceId ?? '',
          pots: widget.selectedCornPots);
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
                              final headers =
                                  List<String>.empty(growable: true);
                              headers.add(
                                "Date",
                              );
                              headers.add(
                                "Time",
                              );
                              headers.add(
                                "Temperature (°C)",
                              );

                              if (widget.selectedCornPots.contains(Pots.pot1)) {
                                headers.add("Pot 1");
                              }

                              if (widget.selectedCornPots.contains(Pots.pot2)) {
                                headers.add("Pot 2");
                              }

                              if (widget.selectedCornPots.contains(Pots.pot3)) {
                                headers.add("Pot 3");
                              }

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
                        // Date Column
                        TableColumn(width: 200),
                        // Time Column
                        TableColumn(width: 200),
                        // Temperature Column
                        TableColumn(width: 200),

                        if (widget.selectedCornPots.contains(Pots.pot1))
                          TableColumn(width: 50, freezePriority: 1),

                        if (widget.selectedCornPots.contains(Pots.pot2))
                          TableColumn(width: 50, freezePriority: 1),

                        if (widget.selectedCornPots.contains(Pots.pot3))
                          TableColumn(width: 50, freezePriority: 1),
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
                                    text = item.temperature.toString();
                                  case 3:
                                    text = item.moisture1.toString();
                                  case 4:
                                    text = item.moisture2.toString();
                                  case 5:
                                    text = item.moisture3.toString();
                                }
                                return Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    text,
                                    style: TextStyle(
                                        fontSize: column == 0
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
                    return errorWidget(
                      data.error ?? 'An error occurred',
                      onPressed: () => _onDateSelected(startDate, endDate),
                    );
                  }
                },
                loading: () => Center(
                  child: CircularProgressIndicator(),
                ),
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
