import 'dart:convert';

import 'package:corntrack_raspberry_pi_app/data/graph_data.dart';
import 'package:corntrack_raspberry_pi_app/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../data/api_data.dart';
import '../data/device_details.dart';
import '../services/graph_services.dart';
import '../services/photos_services.dart';

// Provider for managing the state

class GraphScreen extends ConsumerStatefulWidget {
  final List<Pots> selectedPots;

  const GraphScreen({super.key, required this.selectedPots});

  @override
  ConsumerState<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends ConsumerState<GraphScreen> {
  late final FutureProvider<ApiData<GraphData>> graphProvider;
  final GraphService graphService = GraphServiceFactory.create();

  @override
  void initState() {
    graphProvider = FutureProvider<ApiData<GraphData>>((ref) async {
      final deviceDetails = ref.read(deviceDetailsProvider);
      final deviceId = deviceDetails?.deviceId;
      print("Getting GraphData with deviceId=$deviceId");
      final apiData = await graphService.getGraphData(deviceId ?? '');
      print(
          "Result GraphData photos = ${apiData.isSuccess} - ${apiData.error} - ${apiData.data}");
      return apiData;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final graphDataAsync = ref.watch(graphProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Soil Monitoring")),
      body: graphDataAsync.when(
        data: (apiData) {
          final graphData = apiData.data;
          print('Got $graphData');
          return graphData == null
              ? Center(child: Text("No data available"))
              : SingleChildScrollView(
                child: Center(
                  child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 75),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text("Device ID: ${graphData.deviceId}",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(height: 10),
                          Text("Conclusion:",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(graphData.conclusion,
                              style: TextStyle(fontSize: 14)),
                          SizedBox(height: 20),
                          Text("Graph:",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Image.memory(graphData.graphImage, fit: BoxFit.contain),
                        ],
                      ),
                    ),
                ),
              );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text("Error: $error")),
      ),
    );
  }
}
