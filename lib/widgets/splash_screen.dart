import 'dart:math' as math;
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _gradientController;
  late AnimationController _logoController;
  final List<FloatingShape> _shapes = List.generate(
    15,
    (index) => FloatingShape(math.Random()),
  );

  @override
  void initState() {
    super.initState();
    _gradientController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);

    _logoController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _gradientController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Animated Gradient Background
              AnimatedBuilder(
                animation: _gradientController,
                builder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.lerp(
                            const Color(0xFF1A237E),
                            const Color(0xFF4A148C),
                            _gradientController.value,
                          )!,
                          Color.lerp(
                            const Color(0xFF4A148C),
                            const Color(0xFF880E4F),
                            _gradientController.value,
                          )!,
                        ],
                      ),
                    ),
                  );
                },
              ),
              // Floating Shapes
              ..._shapes.map(
                (shape) => _AnimatedFloatingShape(
                  shape: shape,
                  maxWidth: constraints.maxWidth,
                  maxHeight: constraints.maxHeight,
                ),
              ),
              // Center Logo/Text
              Center(
                child: ScaleTransition(
                  scale: CurvedAnimation(
                    parent: _logoController,
                    curve: Curves.elasticOut,
                  ),
                  child: FadeTransition(
                    opacity: _logoController,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Container(
                        //   padding: const EdgeInsets.all(20),
                        //   decoration: BoxDecoration(
                        //     shape: BoxShape.circle,
                        //     color: Colors.white.withOpacity(0.1),
                        //     border: Border.all(
                        //       color: Colors.white.withOpacity(0.5),
                        //       width: 2,
                        //     ),
                        //     boxShadow: [
                        //       BoxShadow(
                        //         color: Colors.black.withOpacity(0.2),
                        //         blurRadius: 20,
                        //         spreadRadius: 5,
                        //       ),
                        //     ],
                        //   ),
                        //   child: const Icon(
                        //     Icons.cloud_done_rounded,
                        //     size: 80,
                        //     color: Colors.white,
                        //   ),
                        // ),
                        const SizedBox(height: 24),
                        Text(
                          'NEPHOSX',
                          style: Theme.of(context).textTheme.displayMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 4,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.3),
                                    offset: const Offset(2, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                        ),
                      ],
                    ),
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

class FloatingShape {
  late double size;
  late double relativeLeft; // 0.0 to 1.0
  late double relativeTop; // 0.0 to 1.0
  late double duration;
  late Color color;

  FloatingShape(math.Random random) {
    size = random.nextDouble() * 80 + 20;
    relativeLeft = random.nextDouble();
    relativeTop = random.nextDouble();
    duration = random.nextDouble() * 4 + 2;
    color = Colors.white.withOpacity(random.nextDouble() * 0.15 + 0.05);
  }
}

class _AnimatedFloatingShape extends StatefulWidget {
  final FloatingShape shape;
  final double maxWidth;
  final double maxHeight;

  const _AnimatedFloatingShape({
    required this.shape,
    required this.maxWidth,
    required this.maxHeight,
  });

  @override
  State<_AnimatedFloatingShape> createState() => _AnimatedFloatingShapeState();
}

class _AnimatedFloatingShapeState extends State<_AnimatedFloatingShape>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: widget.shape.duration.toInt()),
      vsync: this,
    )..repeat(reverse: true);

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(
        math.Random().nextDouble() - 0.5,
        math.Random().nextDouble() - 0.5,
      ), // Move diagonally slightly
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.shape.relativeLeft * widget.maxWidth,
      top: widget.shape.relativeTop * widget.maxHeight,
      child: SlideTransition(
        position: _offsetAnimation,
        child: Container(
          width: widget.shape.size,
          height: widget.shape.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.shape.color,
            boxShadow: [
              BoxShadow(
                color: widget.shape.color.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
