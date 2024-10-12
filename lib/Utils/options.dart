import 'package:flutter/material.dart';

class JalaliTableCalendarOption {
  final TextStyle? daysOfWeekStyle;
  final TextStyle? headerStyle;
  final TextStyle? daysStyle;
  final TextStyle? todayStyle;
  final Color? currentDayColor;
  final Color? selectedDayShapeColor;
  final Color? selectedDayColor;
  final List<String>? daysOfWeekTitles;
  final EdgeInsets? headerPadding;
  final double calendarHeight;
  final double dayItemSize;

  JalaliTableCalendarOption({
    this.daysOfWeekStyle,
    this.headerStyle,
    this.daysStyle,
    this.todayStyle,
    this.currentDayColor,
    this.selectedDayColor,
    this.selectedDayShapeColor,
    this.daysOfWeekTitles,
    this.calendarHeight = 300,
    this.dayItemSize = 50,
    this.headerPadding,
  }) : assert(daysOfWeekTitles == null || daysOfWeekTitles.length == 7, "daysOfWeekTitles length must be 7");
}
