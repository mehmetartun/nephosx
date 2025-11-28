import 'package:flutter/material.dart';

import '../model/month_summary.dart';
import 'month_summary_widget.dart';

class AnimatedMonthListView extends StatefulWidget {
  const AnimatedMonthListView({
    super.key,
    required this.items,
    required this.height,
    required this.onTap,
  });
  final List<MonthSummary> items;
  final Function(DateTime item) onTap;
  final double height;

  @override
  State<AnimatedMonthListView> createState() => _AnimatedMonthListViewState();
}

class _AnimatedMonthListViewState extends State<AnimatedMonthListView> {
  final ScrollController _scrollController = ScrollController();
  late final List<MonthSummary> _items;

  @override
  void dispose() {
    // 4. Don't forget to dispose of it!
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _items = widget.items;
    _items.sort((a, b) => a.month.compareTo(b.month));

    // 3. Add the post-frame callback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Check if the controller is attached to a scroll view
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent, // Scroll to the bottom
          duration: const Duration(milliseconds: 1000), // Animation duration
          curve: Curves.easeInOut, // Animation curve
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: ListView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        primary: false,
        children: widget.items.map((item) {
          return GestureDetector(
            child: MonthSummaryWidget(monthSummary: item),
            onTap: () {
              widget.onTap(item.month);
            },
          );
        }).toList(),
      ),
    );
  }
}
