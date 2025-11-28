import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeekBounds {
  final DateTime monday;
  final DateTime sunday;

  WeekBounds({required this.monday, required this.sunday});

  @override
  String toString() {
    return 'WeekBounds(monday: $monday, sunday: $sunday)';
  }
}

/// Calculates the Monday and Sunday of the week for a given [date].
///
/// The returned [WeekBounds] object contains [DateTime] objects set to
/// midnight (00:00:00) on their respective days.
/// Assumes that the week starts on Monday (weekday == 1) and ends on
/// Sunday (weekday == 7).
WeekBounds getWeekBounds(DateTime date) {
  // 1. Normalize the input date to midnight.
  // This prevents issues with time zones or time-of-day logic.
  final DateTime normalizedDate = DateTime(date.year, date.month, date.day);

  // 2. Find Monday.
  // DateTime.weekday returns 1 for Monday and 7 for Sunday.
  // We subtract the number of days past Monday to find Monday.
  // Example: If it's Wednesday (3), we subtract (3 - 1) = 2 days.
  // Example: If it's Monday (1), we subtract (1 - 1) = 0 days.
  // Example: If it's Sunday (7), we subtract (7 - 1) = 6 days.
  final DateTime monday = normalizedDate.subtract(
    Duration(days: normalizedDate.weekday - DateTime.monday),
  );

  // 3. Find Sunday.
  // Sunday is 6 days after Monday (or 7 - weekday from the original date).
  final DateTime sunday = normalizedDate.add(
    Duration(days: DateTime.sunday - normalizedDate.weekday),
  );

  // You could also calculate Sunday from the Monday we found:
  // final DateTime sunday = monday.add(const Duration(days: 6));

  return WeekBounds(monday: monday, sunday: sunday);
}

class DateSelect extends StatefulWidget {
  const DateSelect({super.key, required this.onChanged});
  final void Function(DateTime) onChanged;

  @override
  State<DateSelect> createState() => _DateSelectState();
}

class _DateSelectState extends State<DateSelect> {
  DateTime selectedDate = DateTime.now();
  late List<DateTime> dates = [];

  @override
  void initState() {
    // TODO: implement initState
    selectedDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    for (var i = 0; i < 7; i++) {
      dates.add(getWeekBounds(selectedDate).monday.add(Duration(days: i)));
    }
    super.initState();
  }

  // @override
  // void didUpdateWidget(covariant DateSelect oldWidget) {
  //   // TODO: implement didUpdateWidget

  //   super.didUpdateWidget(oldWidget);
  //   widget.onChanged(selectedDate);
  // }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    children.add(
      IconButton.filledTonal(
        icon: Icon(Icons.arrow_left),
        onPressed: () {
          setState(() {
            selectedDate = getWeekBounds(
              selectedDate,
            ).monday.subtract(Duration(days: 1));
            // widget.onChanged(selectedDate);
            dates = []; // Clear the list once before the loop
            for (var i = 0; i < 7; i++) {
              dates.add(
                getWeekBounds(selectedDate).monday.add(Duration(days: i)),
              );
            }
          });
          widget.onChanged(selectedDate);
        },
      ),
    );
    for (var i = 0; i < 7; i++) {
      children.add(
        GestureDetector(
          onTap: () {
            setState(() {
              selectedDate = dates[i];
            });
            widget.onChanged(selectedDate);
          },
          child: Container(
            padding: EdgeInsets.all(4),
            decoration: ShapeDecoration(
              color: dates[i] == selectedDate
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surfaceContainerHigh,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    DateFormat("MMM").format(dates[i]).toUpperCase(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: dates[i] == selectedDate
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                Text(
                  dates[i].day.toString(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: dates[i] == selectedDate
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  DateFormat("EEE").format(dates[i]),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: dates[i] == selectedDate
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      children.add(SizedBox(width: 3));
    }
    children.removeLast();
    children.add(
      IconButton.filledTonal(
        icon: Icon(Icons.arrow_right),
        onPressed: () {
          setState(() {
            selectedDate = getWeekBounds(
              selectedDate,
            ).sunday.add(Duration(days: 1));
            // widget.onChanged(selectedDate);
            dates = []; // Clear the list once before the loop
            for (var i = 0; i < 7; i++) {
              dates.add(
                getWeekBounds(selectedDate).monday.add(Duration(days: i)),
              );
            }
          });
          widget.onChanged(selectedDate);
        },
      ),
    );
    // return SizedBox(
    //   height: 100,
    //   child: ListView.separated(
    //     primary: false,
    //     scrollDirection: Axis.horizontal,
    //     shrinkWrap: true,
    //     physics: NeverScrollableScrollPhysics(),
    //     itemBuilder: (context, index) =>
    //         Text(dates[index].day.toString()),
    //     separatorBuilder: (context, index) => SizedBox(width: 5, height: 4),
    //     itemCount: dates.length,
    //   ),
    // );
    return Row(
      children: children,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    );
    // return GridView.builder(
    //   shrinkWrap: true,
    //   physics: NeverScrollableScrollPhysics(),
    //   padding: const EdgeInsets.all(16.0),
    //   // Use the crossAxisCount to configure the grid delegate
    //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //     crossAxisCount: 7,
    //     crossAxisSpacing: 10.0, // Spacing between columns
    //     mainAxisSpacing: 10.0, // Spacing between rows
    //     childAspectRatio: 0.3, // This is the key to making them square
    //   ),
    //   itemCount: dates.length,
    //   itemBuilder: (context, index) {
    //     // Your button widget goes here
    //     return GestureDetector(
    //       onTap: () {},
    //       child: Container(
    //         padding: EdgeInsets.all(4),
    //         decoration: ShapeDecoration(
    //           color: Theme.of(context).colorScheme.primaryContainer,
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(10),
    //           ),
    //         ),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Text(
    //               dates[index].day.toString(),
    //               style: Theme.of(context).textTheme.headlineSmall?.copyWith(
    //                 color: Theme.of(context).colorScheme.onPrimaryContainer,
    //               ),
    //             ),
    //             Text(
    //               DateFormat("EEE").format(dates[index]),
    //               style: Theme.of(context).textTheme.headlineSmall?.copyWith(
    //                 color: Theme.of(context).colorScheme.onPrimaryContainer,
    //               ),
    //             ),

    //             // Align(
    //             //   alignment: Alignment.bottomRight,
    //             //   child: Column(
    //             //     mainAxisSize: MainAxisSize.min,
    //             //     children: [
    //             //       Text(
    //             //         NumberFormat('0 mL').format(sizes[index].volumeInML),
    //             //         style: Theme.of(context).textTheme.titleMedium
    //             //             ?.copyWith(
    //             //               color: Theme.of(
    //             //                 context,
    //             //               ).colorScheme.onPrimaryContainer,
    //             //             ),
    //             //       ),
    //             //       Text(
    //             //         NumberFormat(
    //             //           '0.0 oz',
    //             //         ).format(sizes[index].volumeInML.mLtoOz()),
    //             //         style: Theme.of(context).textTheme.titleMedium
    //             //             ?.copyWith(
    //             //               color: Theme.of(
    //             //                 context,
    //             //               ).colorScheme.onPrimaryContainer,
    //             //             ),
    //             //       ),
    //             //     ],
    //             //   ),
    //             // ),
    //           ],
    //         ),
    //       ),
    //     );
    //   },
    // );
  }
}
