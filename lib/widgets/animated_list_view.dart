import 'package:flutter/material.dart';

class AnimatedListView extends StatefulWidget {
  const AnimatedListView({
    super.key,
    required this.items,
    required this.height,
  });
  final List<Widget> items;
  final double height;

  @override
  State<AnimatedListView> createState() => _AnimatedListViewState();
}

class _AnimatedListViewState extends State<AnimatedListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    // 4. Don't forget to dispose of it!
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

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
        children: widget.items,
      ),
    );
  }
}
