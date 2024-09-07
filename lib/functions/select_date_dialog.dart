import 'package:flutter/material.dart';
import 'package:jalali_table_calendar_plus/jalali_table_calendar_plus.dart';

Future<DateTime?> pickDate({
  required BuildContext context,
  TextDirection direction = TextDirection.rtl,
  Map<DateTime, List>? events,
  MarkerBuilder? marker,
  bool useOfficialHolyDays = true,
  List<HolyDay> customHolyDays = const [],
}) async {
  DateTime? selectedDate = await showDialog<DateTime>(
      context: context,
      builder: (_) => _TableCalendarPicker(
          direction, events, marker, useOfficialHolyDays, customHolyDays));
  return selectedDate;
}

class _TableCalendarPicker extends StatelessWidget {
  const _TableCalendarPicker(this.direction, this.events, this.marker,
      this.useOfficialHolyDays, this.customHolyDays);

  final TextDirection direction;

  final Map<DateTime, List>? events;
  final MarkerBuilder? marker;
  final bool useOfficialHolyDays;
  final List<HolyDay> customHolyDays;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 100;
    double height = MediaQuery.of(context).size.height / 100;
    DateTime? selectedDate;
    return Dialog(
      insetPadding:
          EdgeInsets.symmetric(vertical: height * 25, horizontal: width * 5),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: JalaliTableCalendar(
                onDaySelected: (date) {
                  selectedDate = date;
                },
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, selectedDate);
                },
                child: const Text('تایید'))
          ],
        ),
      ),
    );
  }
}
