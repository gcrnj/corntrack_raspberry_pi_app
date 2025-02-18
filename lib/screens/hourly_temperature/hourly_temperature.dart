import 'package:corntrack_raspberry_pi_app/screens/range_date_picker/range_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HourlyTemperature extends ConsumerStatefulWidget {
  const HourlyTemperature({super.key});

  @override
  ConsumerState<HourlyTemperature> createState() => _HourlyTemperatureState();
}

class _HourlyTemperatureState extends ConsumerState<HourlyTemperature> {
  @override
  Widget build(BuildContext context) {
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
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ]
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onDateSelected(DateTime startDate, DateTime endDate) {
    print('Start Date: $startDate, End Date: $endDate');
  }
}
