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
    double height = MediaQuery.of(context).size.height;
    return Directionality(
      textDirection: widget.direction,
      child: Dialog(
        child: SizedBox(
          height: height / 3.5,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_SelectMode.year == mode)
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: () {
                          _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease);
                        },
                      ),
                    Flexible(
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
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
                                child: Center(
                                    child: Text((year + index).toString())));
                          } else {
                            return GestureDetector(
                                onTap: () {
                                  Navigator.pop(context,
                                      (selectedYear - 1304) * 12 + index);
                                },
                                child: Center(child: Text(monthNames[index])));
                          }
                        },
                      ),
                    ),
                    if (_SelectMode.year == mode)
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
            },
          ),
        ),
      ),
    );
  }
}
