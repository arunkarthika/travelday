import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CustomTimePicker extends StatelessWidget {
  final TimeOfDay initialTime;
  final void Function(TimeOfDay) onTimeSelected;

  CustomTimePicker({required this.initialTime, required this.onTimeSelected});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _showTimePicker(context);
      },
      child: Container(
        // padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          // border: Border.all(
          //   color: Colors.grey,
          //   width: 1.0,
          // ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              initialTime.format(context),
              style: TextStyle(fontSize: 16.0),
            ),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final TimeOfDay? pickedTime = await showCupertinoModalPopup<TimeOfDay>(
      context: context,
      builder: (BuildContext context) {
        return _buildTimePickerDialog(context);
      },
    );

    if (pickedTime != null) {
      onTimeSelected(pickedTime);
    }
  }

  Widget _buildTimePickerDialog(BuildContext context) {
    final now = DateTime.now();
    final initialDateTime = DateTime(now.year, now.month, now.day, initialTime.hour, initialTime.minute);
    final timePicker = CupertinoDatePicker(
      mode: CupertinoDatePickerMode.time,
      initialDateTime: initialDateTime,
      onDateTimeChanged: (DateTime dateTime) {
        final selectedTime = TimeOfDay.fromDateTime(dateTime);
        onTimeSelected(selectedTime);
      },
    );

    return Container(
      height: 200.0,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(child: timePicker),
        ],
      ),
    );
  }
}
