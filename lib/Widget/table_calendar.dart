// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:jalali_table_calendar_plus/Utils/options.dart';
import 'package:shamsi_date/shamsi_date.dart';

import 'package:jalali_table_calendar_plus/Utils/holy_day.dart';

part 'package:jalali_table_calendar_plus/Utils/select_year_month.dart';

typedef OnDaySelected = void Function(DateTime day);
typedef MarkerBuilder = Widget? Function(DateTime date, List<dynamic> events);
typedef RangeDates = void Function(List<DateTime> dates);

class JalaliTableCalendar extends StatefulWidget {
  const JalaliTableCalendar({
    super.key,
    this.direction = TextDirection.rtl,
    this.onDaySelected,
    this.marker,
    this.events,
    this.onRangeSelected,
    this.range = false,
    this.useOfficialHolyDays = true,
    this.customHolyDays = const [],
    this.option,
  });

  final TextDirection direction;
  final MarkerBuilder? marker;
  final OnDaySelected? onDaySelected;
  final RangeDates? onRangeSelected;
  final Map<DateTime, List>? events;
  final bool range;
  final bool useOfficialHolyDays;
  final List<HolyDay> customHolyDays;
  final JalaliTableCalendarOption? option;

  @override
  JalaliTableCalendarState createState() => JalaliTableCalendarState();
}

class JalaliTableCalendarState extends State<JalaliTableCalendar> {
  Jalali? _startSelectDate;

  Jalali? _endSelectDate;

  Jalali _selectedDate = Jalali.now();
  Jalali _selectedPage = Jalali.now();
  late PageController _pageController;
  late ThemeData themeData;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _calculateInitialPage());
  }

  int _calculateInitialPage() {
    int currentMonth = Jalali.now().month;
    return 99 * 12 + currentMonth - 1;
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    if (!widget.range) {
      _startSelectDate = null;
      _endSelectDate = null;
    }
    return Directionality(
      textDirection: widget.direction,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildDaysOfWeek(),
          _buildCalendarPageView()
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final List<String> monthNames = [
      'فروردین',
      'اردیبهشت',
      'خرداد',
      'تیر',
      'مرداد',
      'شهریور',
      'مهر',
      'آبان',
      'آذر',
      'دی',
      'بهمن',
      'اسفند',
    ];
    return Container(
      padding: widget.option?.headerPadding ?? const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease);
            },
          ),
          GestureDetector(
            onTap: () async {
              int? newPage = await showDialog(
                context: context,
                builder: (_) => _SelectYearMonth(
                  year: _selectedPage.year,
                  month: _selectedPage.month,
                  direction: widget.direction,
                ),
              );
              if (newPage != null) {
                _pageController.jumpToPage(newPage);
              }
            },
            child: Text(
              '${monthNames[_selectedPage.month - 1]} ${_selectedPage.year}',
              style:
                  widget.option?.headerStyle ?? const TextStyle(fontSize: 20.0),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDaysOfWeek() {
    List<String> daysOfWeek = ['ش', 'ی', 'د', 'س', 'چ', 'پ', 'ج'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(7, (index) {
        final fridayColor = daysOfWeek[index] == 'ج' ? Colors.red : null;
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Center(
            child: Text(
              widget.option?.daysOfWeekTitles?[index] ?? daysOfWeek[index],
              style: widget.option?.daysOfWeekStyle
                      ?.copyWith(color: fridayColor) ??
                  TextStyle(color: fridayColor),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCalendarPageView() {
    return SizedBox(
      height: 350,
      child: PageView.builder(
        itemCount: 2400, // 200 years * 12 months
        controller: _pageController,
        onPageChanged: (int page) {
          setState(() {
            int year = 1304 + (page ~/ 12);
            int month = (page % 12) + 1;
            _selectedPage = Jalali(year, month, 1);
          });
        },
        itemBuilder: (context, index) {
          int year = 1304 + (index ~/ 12);
          int month = (index % 12) + 1;
          Jalali firstDayOfMonth = Jalali(year, month, 1);
          int daysInMonth = firstDayOfMonth.monthLength;
          int startingWeekday =
              firstDayOfMonth.weekDay; // 1 (Saturday) - 7 (Friday)
          return _buildGridView(year, month, daysInMonth, startingWeekday);
        },
      ),
    );
  }

  Widget _buildGridView(
      int year, int month, int daysInMonth, int startingWeekday) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7, mainAxisSpacing: 5, mainAxisExtent: 50),
      itemCount: daysInMonth + (startingWeekday - 1),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        if (index < startingWeekday - 1) {
          return Container(
            height: 100,
          ); // Empty cell
        } else {
          int day = index - (startingWeekday - 2);
          if (day > _selectedDate.monthLength) {
            day = _selectedDate.monthLength;
          }
          Jalali date = Jalali(year, month, day);
          bool isSelected = _isSelectedDay(date);
          bool isToday = _isToday(date);
          bool isHolyDay = _isHolyDay(date);
          Widget? marker = widget.marker != null
              ? widget.marker!(date.toDateTime(), dayEvents(date.toDateTime()))
              : null;

          final styleColor = isToday && !isSelected
              ? widget.option?.currentDayColor ?? themeData.primaryColorDark
              : isSelected
                  ? widget.option?.selectedDayColor ??
                      themeData.scaffoldBackgroundColor
                  : date.weekDay == 7 || isHolyDay
                      ? Colors.red
                      : null;
          return Stack(
            children: [
              GestureDetector(
                onTap: () {
                  if (widget.range) {
                    setRange(date);
                  }
                  if (widget.onDaySelected != null) {
                    widget.onDaySelected!(date.toDateTime());
                  }
                  setState(() {
                    _selectedDate = date;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? widget.option?.selectedDayShapeColor ??
                            themeData.primaryColor
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '${date.day}',
                      style: widget.option?.daysStyle
                              ?.copyWith(color: styleColor) ??
                          TextStyle(color: styleColor),
                    ),
                  ),
                ),
              ),
              if (marker != null) marker,
            ],
          );
        }
      },
    );
  }

  List<dynamic> dayEvents(DateTime date) {
    List events = [];
    widget.events?.forEach(
      (key, value) {
        if (key == date) {
          events.add({key, value});
        }
      },
    );
    return events;
  }

  bool _isSelectedDay(Jalali date) {
    if (widget.range && _startSelectDate != null && _endSelectDate != null) {
      DateTime dateTime = date.toDateTime();
      DateTime startRange = _startSelectDate!.addDays(-1).toDateTime();
      DateTime endRange = _endSelectDate!.addDays(1).toDateTime();
      if (dateTime.isAfter(startRange) && dateTime.isBefore(endRange)) {
        return true;
      }
      return false;
    }

    return (!widget.range || _startSelectDate != null) &&
        _selectedDate.day == date.day &&
        date.month == _selectedDate.month &&
        date.year == _selectedDate.year;
  }

  bool _isToday(Jalali date) {
    Jalali toDay = Jalali.now();
    return date.day == toDay.day &&
        date.month == toDay.month &&
        date.year == toDay.year;
  }

  void setRange(Jalali date) {
    if (_startSelectDate != null && _endSelectDate != null) {
      _startSelectDate = null;
      _endSelectDate = null;
    }
    if (_startSelectDate == null) {
      _startSelectDate = date;
      return;
    }
    if (_endSelectDate == null) {
      _endSelectDate = date;
      if (_endSelectDate!.distanceFrom(_selectedDate) < 0) {
        _endSelectDate = _startSelectDate;
        _startSelectDate = date;
      }
      DateTime day = _startSelectDate!.toDateTime();
      List<DateTime> days = [];
      while (day.isBefore(_endSelectDate!.addDays(1).toDateTime())) {
        days.add(day);
        day = day.add(const Duration(days: 1));
      }
      if (widget.onRangeSelected != null) {
        widget.onRangeSelected!(days);
      }
      return;
    }
    setState(() {});
  }

  bool _isHolyDay(Jalali date) {
    List<HolyDay> holyDays = [
      HolyDay(month: 01, day: 1),
      HolyDay(month: 01, day: 2),
      HolyDay(month: 01, day: 3),
      HolyDay(month: 01, day: 4),
      HolyDay(month: 01, day: 12),
      HolyDay(month: 01, day: 13),
      HolyDay(month: 03, day: 14),
      HolyDay(month: 03, day: 15),
    ];
    holyDays.addAll(widget.customHolyDays);
    for (HolyDay holyDay in holyDays) {
      if ((holyDay.year == 0 || holyDay.year == date.year) &&
          holyDay.month == date.month &&
          holyDay.day == date.day) {
        return true;
      }
    }
    return false;
  }
}
