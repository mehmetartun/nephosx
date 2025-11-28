import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../model/app_instruction.dart';
import 'instruction_display_widget.dart';

class InstructionsWidget extends StatefulWidget {
  const InstructionsWidget({super.key, required this.appInstructions});
  final List<AppInstruction> appInstructions;

  @override
  State<InstructionsWidget> createState() => _InstructionsWidgetState();
}

class _InstructionsWidgetState extends State<InstructionsWidget> {
  int currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void next() {
    if (currentIndex < widget.appInstructions.length - 1) {
      setState(() {
        currentIndex++;
      });
    }
  }

  void previous() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    }
  }

  void skip() {
    GoRouter.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            ElevatedButton(
              onPressed: currentIndex == 0 ? null : previous,
              child: const Text('Previous'),
            ),
            const SizedBox(width: 10),
            Row(
              children: List.generate(widget.appInstructions.length, (index) {
                return Container(
                  margin: EdgeInsets.all(2),
                  width: 10,
                  height: 10,
                  decoration: ShapeDecoration(
                    color: index == currentIndex
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.primaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: currentIndex == widget.appInstructions.length - 1
                  ? skip
                  : next,
              child: Text(
                currentIndex == widget.appInstructions.length - 1
                    ? "Skip"
                    : "Next",
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(width: double.infinity, height: double.infinity),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              // return ScaleTransition(scale: animation, child: child);
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
            child: InstructionDisplayWidget(
              key: ValueKey(currentIndex),
              index: currentIndex,
              itemCount: widget.appInstructions.length,
              appInstruction: widget.appInstructions[currentIndex],
            ),
          ),
          Positioned(
            right: 10,
            top: MediaQuery.of(context).viewPadding.top + 5,
            child: IconButton.filled(
              onPressed: () {
                GoRouter.of(context).pop();
              },
              icon: Icon(Icons.close),
            ),
          ),
        ],
      ),
    );
  }
}
