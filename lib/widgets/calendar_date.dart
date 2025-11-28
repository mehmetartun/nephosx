import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarDate extends StatefulWidget {
  const CalendarDate({super.key, required this.date, this.onTap});
  final DateTime date;
  final void Function(DateTime)? onTap;

  @override
  State<CalendarDate> createState() => _CalendarDateState();
}

class _CalendarDateState extends State<CalendarDate> {
  late bool _selected;
  @override
  void initState() {
    super.initState();
  }

  // void onTapped() {
  //   setState(() {
  //     _selected = !_selected;
  //   });
  //   widget.onTap == null ? null : widget.onTap!();
  // }

  @override
  Widget build(BuildContext context) {
    Color bgColor = Theme.of(context).colorScheme.tertiaryContainer;

    Color fgColor = Theme.of(context).colorScheme.onTertiaryContainer;

    return GestureDetector(
      onTap: widget.onTap == null
          ? null
          : () {
              widget.onTap!(widget.date);
            },
      child: SizedBox(
        height: 70,
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            // shadowColor: const Color.fromARGB(0, 244, 196, 196),
            clipBehavior: Clip.hardEdge,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              color: bgColor,
            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                  color: Colors.black,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    DateFormat('MMM').format(widget.date).toUpperCase(),
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(color: Colors.white),
                  ),
                ),
                Expanded(
                  child: FittedBox(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          DateFormat('d').format(widget.date),
                          style: Theme.of(
                            context,
                          ).textTheme.headlineLarge?.copyWith(color: fgColor),
                        ),
                        Text(
                          DateFormat('EEE').format(widget.date).toUpperCase(),
                          style: Theme.of(
                            context,
                          ).textTheme.titleSmall?.copyWith(color: fgColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
