import 'dart:convert';

import 'package:corntrack_raspberry_pi_app/data/date_range.dart';
import 'package:corntrack_raspberry_pi_app/data/graph_data.dart';
import 'package:corntrack_raspberry_pi_app/screens/dashboard/dashboard_screen.dart';
import 'package:corntrack_raspberry_pi_app/screens/range_date_picker/range_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../data/api_data.dart';
import '../data/device_details.dart';
import '../services/graph_services.dart';

// Provider for managing the state

// Provider for managing GraphData state
final graphSelectedDateRangeProvider = StateProvider<DateRange?>((ref) {
  final now = DateTime.now();
  final start = now.copyWith(
    day: 1,
    hour: 0,
    minute: 0,
    second: 0,
    millisecond: 0,
    microsecond: 0,
  );
  final end = DateTime.now().copyWith(hour: 23,
      minute: 59,
      second: 59,
      millisecond: 99,
      microsecond: 99);
  return DateRange(start, end);
});

final graphProvider =
FutureProvider.family<ApiData<List<GraphData>>, List<String>>(
        (ref, moistureId) async {
      final graphService = GraphServiceFactory.create();
      final deviceDetails = ref.read(deviceDetailsProvider);
      final deviceId = deviceDetails?.deviceId ?? '';
      final selectedDateRange = ref.watch(graphSelectedDateRangeProvider);

      print(
          "Fetching GraphData for deviceId=$deviceId & moistureId=$moistureId");
      final apiData = await graphService.getGraphData(deviceId, moistureId, selectedDateRange);
      print(
          "Result GraphData: ${apiData.isSuccess} - ${apiData.error} - ${apiData
              .data}");

      return apiData;
    });

class GraphScreen extends ConsumerStatefulWidget {
  final List<String> moistureIds;

  const GraphScreen({super.key, required this.moistureIds});

  @override
  ConsumerState<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends ConsumerState<GraphScreen> {
  @override
  Widget build(BuildContext context) {
    final graphDataAsync = ref.watch(graphProvider(widget.moistureIds));

    return Scaffold(
      appBar: AppBar(title: Text("Smart Farming Dashboard")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            RangeDatePicker(onDateSelected: (startDate, endDate) {
              ref.read(graphSelectedDateRangeProvider.notifier).state = DateRange(startDate, endDate);

            }),
            graphDataAsync.when(
              data: (apiData) {
                final graphDataList = apiData.data ?? List.empty();
                print('Got $graphDataList');
                return graphDataList.isEmpty
                    ? Center(child: Text("No data available"))
                    : Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 25.0, horizontal: 75),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                  "Device ID: ${graphDataList.first.deviceId}",
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            for (final graphData in graphDataList)
                              graphItem(graphData)
                          ],
                        ),
                      ),
                    );
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text("Error: $error")),
            ),
          ],
        ),
      ),
    );
  }

  Widget graphItem(GraphData graphData) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white, // Background color
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle("Pot #${graphData.potMoistureNumber}:"),
          const SizedBox(height: 8),
          _buildTitle("Conclusion:"),
          _buildText(graphData.conclusion),
          const SizedBox(height: 12),
          _buildTitle("Graph:"),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.memory(graphData.graphImage, fit: BoxFit.cover),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
    );
  }

  Widget _buildText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, color: Colors.black54),
    );
  }
}
