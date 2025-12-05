import 'dart:math';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class ComputerGridAnimation extends StatefulWidget {
  const ComputerGridAnimation({super.key});

  @override
  State<ComputerGridAnimation> createState() => _ComputerGridAnimationState();
}

class _ComputerGridAnimationState extends State<ComputerGridAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _textController;
  late Animation<double> _animation;
  late AnimationController _progressController;
  final List<_IconItem> _icons = [];
  final Random _random = Random();
  Size? _lastSize;
  bool _hasRunForwardOnce = false;

  // Configuration
  static const double _iconSize = 50.0;
  static const double _padding = 0.0;
  static const Duration _totalDuration = Duration(seconds: 30);
  static const Duration _flightDuration = Duration(milliseconds: 200);

  @override
  void initState() {
    super.initState();
    // _controller = AnimationController(vsync: this, duration: _totalDuration);
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    _textController.forward();
    // _controller.addStatusListener((status) {
    //   if (status == AnimationStatus.completed && !_hasRunForwardOnce) {
    //     _hasRunForwardOnce = true;
    //     _textController.forward();
    //   }
    // });
    _textController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // _textController.reset();
        // _textController.forward();
        _progressController.forward();
      }
    });
    // _progressController.forward();
  }

  void _initializeIcons(Size size) {
    if (_lastSize == size && _icons.isNotEmpty) return;
    _lastSize = size;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    final double gridWidth = size.width * 1.1;
    final double gridHeight = size.height * 1.1;

    final int cols = (gridWidth / _iconSize).floor();
    final int rows = (gridHeight / _iconSize).floor();

    if (cols <= 0 || rows <= 0) return;

    final double startX = centerX - (cols * _iconSize) / 2;
    final double startY = centerY - (rows * _iconSize) / 2;

    _icons.clear();

    // Create all grid positions
    List<Offset> gridPositions = [];
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        gridPositions.add(
          Offset(startX + c * _iconSize, startY + r * _iconSize),
        );
      }
    }

    // Generate start times evenly distributed
    int totalIcons = gridPositions.length;
    List<double> startTimes = List.generate(totalIcons, (index) {
      double maxStartTime =
          (_totalDuration.inMilliseconds - _flightDuration.inMilliseconds)
              .toDouble();
      if (maxStartTime < 0) maxStartTime = 0;
      return (index / totalIcons) * maxStartTime;
    });

    startTimes.shuffle(_random);

    for (int i = 0; i < totalIcons; i++) {
      _icons.add(
        _IconItem(
          startPosition: _getRandomOutsidePosition(size),
          targetPosition: gridPositions[i],
          startTimeMs: startTimes[i],
        ),
      );
    }
  }

  Offset _getRandomOutsidePosition(Size size) {
    int side = _random.nextInt(4);
    double x, y;

    switch (side) {
      case 0: // Top
        x = _random.nextDouble() * size.width;
        y = -_iconSize;
        break;
      case 1: // Right
        x = size.width + _iconSize;
        y = _random.nextDouble() * size.height;
        break;
      case 2: // Bottom
        x = _random.nextDouble() * size.width;
        y = size.height + _iconSize;
        break;
      case 3: // Left
      default:
        x = -_iconSize;
        y = _random.nextDouble() * size.height;
        break;
    }
    return Offset(x, y);
  }

  @override
  void dispose() {
    // _controller.dispose();
    _textController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          _initializeIcons(constraints.biggest);

          return Stack(
            alignment: Alignment.center,
            children: [
              Container(width: double.infinity, height: double.infinity),

              // AnimatedBuilder(
              //   animation: _controller,
              //   builder: (context, child) {
              //     final double currentMs =
              //         _controller.value * _totalDuration.inMilliseconds;

              //     return Stack(
              //       children: _icons.map((icon) {
              //         double progress = 0.0;
              //         if (currentMs >= icon.startTimeMs) {
              //           progress =
              //               (currentMs - icon.startTimeMs) /
              //               _flightDuration.inMilliseconds;
              //         }

              //         progress = progress.clamp(0.0, 1.0);
              //         final double curvedProgress = Curves.easeOut.transform(
              //           progress,
              //         );

              //         final double currentX =
              //             icon.startPosition.dx +
              //             (icon.targetPosition.dx - icon.startPosition.dx) *
              //                 curvedProgress;
              //         final double currentY =
              //             icon.startPosition.dy +
              //             (icon.targetPosition.dy - icon.startPosition.dy) *
              //                 curvedProgress;

              //         return Positioned(
              //           left: currentX,
              //           top: currentY,
              //           width: _iconSize,
              //           height: _iconSize,
              //           child: Padding(
              //             padding: const EdgeInsets.all(_padding),
              //             child: Icon(
              //               Symbols.memory,
              //               color: Colors.grey[400]!.withOpacity(progress),
              //               size: _iconSize - _padding * 2,
              //               weight: 100,
              //             ),
              //           ),
              //         );
              //       }).toList(),
              //     );
              //   },
              // ),
              AnimatedBuilder(
                animation: _textController,
                builder: (context, child) {
                  // if (_textController.value == 0)
                  //   return const SizedBox.shrink();

                  // Calculate width: 0 to 50% of screen width
                  final double targetWidth = constraints.maxWidth * 0.25;
                  final double currentWidth =
                      targetWidth +
                      targetWidth *
                          Curves.easeOutBack.transform(_textController.value);

                  return SizedBox(
                    width: currentWidth,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        color: Colors.black,
                        child: Text(
                          "NephosX",
                          style: TextStyle(
                            color: Colors.white.withAlpha(
                              (_textController.value * 255).toInt(),
                            ),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                bottom: constraints.maxHeight * 0.25,
                child: Container(
                  width: constraints.maxWidth * 0.3,
                  height: 6,
                  child: AnimatedBuilder(
                    animation: _progressController,
                    builder: (context, child) {
                      return LinearProgressIndicator(
                        value: _progressController.value,
                        borderRadius: BorderRadius.circular(10),
                        // controller: _progressController,
                        // stopIndicatorRadius: 10,
                        // value: _progressController.value,
                        // value: 0.5,
                        color: Colors.white,
                        backgroundColor: Colors.grey,
                        minHeight: 10,
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _IconItem {
  final Offset startPosition;
  final Offset targetPosition;
  final double startTimeMs;

  _IconItem({
    required this.startPosition,
    required this.targetPosition,
    required this.startTimeMs,
  });
}
