import 'package:corntrack_utils/utils/colors_utility.dart';
import 'package:flutter/material.dart';

class RangeDatePicker extends StatefulWidget {
  final Function(DateTime startDate, DateTime endDate) onDateSelected;

  const RangeDatePicker({super.key, required this.onDateSelected});

  @override
  State<RangeDatePicker> createState() => _RangeDatePickerState();
}

class _RangeDatePickerState extends State<RangeDatePicker> {
  DateTime _startDate = DateTime.now()
      .copyWith(day: 1, hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
  DateTime _endDate = DateTime.now().copyWith(
      hour: 23, minute: 59, second: 59, millisecond: 999, microsecond: 999);

  final BoxDecoration _widgetDecorator = BoxDecoration(
    color: lightYellowColor,
    borderRadius: BorderRadius.circular(12),
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 24,
        ),
        _childWidget(
          dateTime: _startDate,
          text: 'From',
          minDate: DateTime(2024),
          maxDate: _endDate,
          // Ensure startDate is before endDate
          onChanged: (newValue) {
            setState(() {
              _startDate = newValue.copyWith(
                hour: 0,
                minute: 0,
                second: 0,
                millisecond: 0,
                microsecond: 0,
              );
              widget.onDateSelected(_startDate, _endDate);
            });
          },
        ),
        _childWidget(
          dateTime: _endDate,
          text: 'To',
          minDate: _startDate,
          // Ensure endDate is after startDate
          maxDate: DateTime.now().copyWith(
              hour: 23,
              minute: 59,
              second: 59,
              millisecond: 999,
              microsecond: 999),
          onChanged: (newValue) {
            setState(() {
              _endDate = newValue.copyWith(
                hour: 23,
                minute: 59,
                second: 59,
                millisecond: 999,
                microsecond: 999,
              );
              widget.onDateSelected(_startDate, _endDate);
            });
          },
        ),
      ],
    );
  }

  Widget _childWidget({
    required DateTime dateTime,
    required String text,
    required DateTime minDate,
    required DateTime maxDate,
    required Function(DateTime newValue) onChanged,
  }) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(
          width: 4,
        ),
        Ink(
          decoration: BoxDecoration(
            color: yellowColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            focusColor: lightYellowColor,
            highlightColor: lightYellowColor,
            splashColor: lightYellowColor,
            hoverColor: lightYellowColor,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: dateTime,
                firstDate: minDate, // ✅ Enforce valid range
                lastDate: maxDate, // ✅ Enforce valid range
              );

              if (pickedDate != null) {
                onChanged(pickedDate);
              }
            },
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                "${dateTime.toLocal()}".split(' ')[0],
                // Display date in YYYY-MM-DD format
              ),
            ),
          ),
        ),
        SizedBox(
          width: 24,
        ),
      ],
    );
  }
}
