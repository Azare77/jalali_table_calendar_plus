part of 'package:jalali_table_calendar_plus/Widget/table_calendar.dart';

enum _SelectMode { year, month }

class _SelectYearMonth extends StatefulWidget {
  const _SelectYearMonth(
      {required this.month, required this.year, required this.direction});

  final int year;
  final int month;
  final TextDirection direction;

  @override
  State<_SelectYearMonth> createState() => _SelectYearMonthState();
}

class _SelectYearMonthState extends State<_SelectYearMonth> {
  late PageController _pageController;
  late int page;
  late int selectedYear;
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
  _SelectMode mode = _SelectMode.year;

  @override
  void initState() {
    page = (widget.year - 1304) ~/ 12;
    _pageController = PageController(initialPage: (widget.year - 1304) ~/ 12);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.direction,
      child: Dialog(
        child: SizedBox(
          height: 250,
          child: PageView.builder(
            itemCount: mode == _SelectMode.year ? 17 : 1,
            // 200 years * 12 months
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                this.page = page;
              });
            },
            itemBuilder: (context, index) {
              return Center(
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 5,
                      mainAxisExtent: 50),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    if (_SelectMode.year == mode) {
                      int year = 1304 + (page * 12);
                      return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedYear = year + index;
                              mode = _SelectMode.month;
                            });
                          },
                          child:
                              Center(child: Text((year + index).toString())));
                    } else {
                      return GestureDetector(
                          onTap: () {
                            Navigator.pop(
                                context, (selectedYear - 1304) * 12 + index);
                          },
                          child: Center(child: Text(monthNames[index])));
                    }
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
