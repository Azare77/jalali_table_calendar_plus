# Jalali  Table Calendar Plus

A rewritten package of [jalali_table_calendar](https://pub.dev/packages/jalali_table_calendar)

## Jalali Calendar

- Table view of the calendar
- Range selection
- Customizable holidays
- Modal for date selection
- Event list definition for each date
- Custom marker definition for each day

## Setup

### Add this line to the pubspec.yaml file

```yaml
jalali_table_calendar_plus: ^1.0.1
```

```dart
Widget buildCalendar(BuildContext context) {
  DateTime today = DateTime.now();
  Map <DateTime, List<dynamic>>events = {
    today: ['sample event', 26],
    today.add(const Duration(days: 1)): ['all types can use here', {"key": "value"}],
  };
  return JalaliTableCalendar(
    events: events,
    range: range,
    customHolyDays: [
      // use jalali month and day for this
      HolyDay(month: 4, day: 10), // For Repeated Days
      HolyDay(year: 1404, month: 1, day: 26), // For Only One Day
    ],
    onRangeSelected: (selectedDates) {
      for (DateTime date in selectedDates) {
        print(date);
      }
    },
    marker: (date, event) {
      if (event.isNotEmpty) {
        return Positioned(
            top: -2,
            left: 1,
            child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.blue),
                child: Text(event.length.toString())));
      }
      return null;
    },
    onDaySelected: (DateTime date) {},
  );
}

```

## HolyDays

HolyDay(year: Jalai_Year , month: Jalai_Month, day: Jalai_Day)

| Parameter | Usage       | Data Type |
 |-----------|-------------|-----------|
| year      | Jalai Year  | Int       |
| month     | Jalai Month | Int       |
| day       | Jalai Day   | Int       |

## Parameters

| Parameter       | Usage                                                | Data Type                                         |
|-----------------|------------------------------------------------------|---------------------------------------------------|
| events          | A map of events for each day                         | Map <DateTime,List<dynamic>>                      |
| range           | Used for range selection                             | bool                                              |
| customHolyDays  | A list of customizable holidays                      | List<HolyDay> HolyDay(year:Int,month:Int,day:Int) |
| onRangeSelected | Method executed after range selection is completed	  | List<DateTime>                                    |
| onDaySelected   | Method executed after single date selection          | DateTime                                          |
| marker          | Method to receive user-designed markers for each day | (DateTime date, List<dynamic> eventsOfDay)        |

## تقویم جلالی

بازنویسی شده پکیج   [jalal_table_calendar](https://pub.dev/packages/jalali_table_calendar)

- نمای جدولی تقویم
- انتخاب به صورت بازه ای
- تعریف تعطیلات به صورت شخصی سازی شده
- مودال برای انتخاب تاریخ
- تعریف لیست رویداد ها برای هر تاریخ
- تعریف مارکر مخصوص برای هر روز

## راه اندازی

### این خط را به فایل  pubspec.yaml اضافه کنید

```yaml
jalali_table_calendar_plus: ^1.0.1
```

```dart
Widget buildCalendar(BuildContext context) {
  DateTime today = DateTime.now();
  Map <DateTime, List<dynamic>>events = {
    today: ['sample event', 26],
    today.add(const Duration(days: 1)): ['all types can use here', {"key": "value"}],
  };
  return JalaliTableCalendar(
    events: events,
    range: range,
    customHolyDays: [
      // use jalali month and day for this
      HolyDay(month: 4, day: 10), // For Repeated Days
      HolyDay(year: 1404, month: 1, day: 26), // For Only One Day
    ],
    onRangeSelected: (selectedDates) {
      for (DateTime date in selectedDates) {
        print(date);
      }
    },
    marker: (date, event) {
      if (event.isNotEmpty) {
        return Positioned(
            top: -2,
            left: 1,
            child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.blue),
                child: Text(event.length.toString())));
      }
      return null;
    },
    onDaySelected: (DateTime date) {},
  );
}

```

## HolyDays

HolyDay(year: Jalai_Year , month: Jalai_Month, day: Jalai_Day)

| پارامتر | کاربرد    | Data Type |
|---------|-----------|-----------|
| year    | سال جلالی | Int       |
| month   | ماه جلالی | Int       |
| day     | روز جلالی | Int       |

## پارامتر ها

| پارامتر         | کاربرد                                                            | نوع داده                                          |
|-----------------|-------------------------------------------------------------------|---------------------------------------------------|
| events          | یک Map از رویداد های هر روز                                       | Map <DateTime,List<dynamic>>                      |
| range           | برای انتخاب بازه ای استفاده میشود                                 | bool                                              |
| customHolyDays  | لیستی از تطیلات شخصی سازی شده                                     | List<HolyDay> HolyDay(year:Int,month:Int,day:Int) |
| onRangeSelected | متدی که بعد از اتمام انتخاب بازه ای اجرا میشود                    | List<DateTime>                                    |
| onDaySelected   | متدی که بعد از انتخاب تاریخ در حالت تکی اجرا میشود                | DateTime                                          |
| marker          | متد ساخت مارکر های طراحی شده کاربر را برای هر روز را دریافت میکند | (DateTime date, List<dynamic> eventsOfDay)        |


