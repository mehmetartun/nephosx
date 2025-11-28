import 'package:flutter/material.dart';

class ExpandingText extends StatefulWidget {
  const ExpandingText({super.key, required this.title, required this.text});
  final String title;
  final String text;

  @override
  State<ExpandingText> createState() => _ExpandingTextState();
}

class _ExpandingTextState extends State<ExpandingText> {
  bool isExpanded = false;

  void toggle() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggle,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Icon(
                Icons.more_horiz_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
          AnimatedCrossFade(
            duration: Duration(milliseconds: 300),
            crossFadeState: isExpanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            secondChild: Text(
              widget.text,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            firstChild: Text(
              widget.text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
