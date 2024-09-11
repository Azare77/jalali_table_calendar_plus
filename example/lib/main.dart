import 'package:flutter/material.dart';
import 'package:jalali_table_calendar_plus/jalali_table_calendar_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late DateTime today;
  DateTime? dialogSelectedDate;
  late Map<DateTime, List<dynamic>> events;
  bool range = false;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    DateTime now = DateTime.now();
    today = DateTime(now.year, now.month, now.day);
    events = {
      today: ['sample event', 66546],
      today.add(const Duration(days: 1)): [6, 5, 465, 1, 66546],
      today.add(const Duration(days: 2)): [6, 5, 465, 66546],
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            JalaliTableCalendar(
              events: events,
              range: range,
              option: JalaliTableCalendarOption(
                daysOfWeekTitles: [
                  "شنبه",
                  "یکشنبه",
                  "دوشنبه",
                  "سه شنبه",
                  "چهارشنبه",
                  "پنجشنبه",
                  "جمعه"
                ],
              ),
              selectedDate: selectedDate,
              customHolyDays: [
                // use jalali month and day for this
                HolyDay(month: 4, day: 10), // For Repeated Days
                HolyDay(year: 1404, month: 1, day: 26), // For Only One Day
              ],
              onRangeSelected: (selectedDates) {
                for (DateTime date in selectedDates) {
                  debugPrint(date.toString());
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
              onDaySelected: (DateTime date) {
                print(date);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("انتخاب بازه ای"),
                Switch(
                    value: range,
                    onChanged: (value) {
                      setState(() {
                        range = value;
                      });
                    }),
              ],
            ),
            ElevatedButton(
                onPressed: () async {
                  DateTime? dateTime = await pickDate(context: context);
                  setState(() {
                    dialogSelectedDate = dateTime;
                    selectedDate = dialogSelectedDate!;
                  });
                },
                child: const Text('انتخاب تاریخ')),
            if (dialogSelectedDate != null)
              Text('تاریخ انتخاب شده به میلادی$dialogSelectedDate'),
          ],
        ),
      ),
    );
  }
}
