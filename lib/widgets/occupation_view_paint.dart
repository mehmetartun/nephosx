import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../model/gpu_transaction.dart';
import '../model/slot.dart';

class OccupationView extends StatelessWidget {
  const OccupationView({
    super.key,
    this.occupiedSlots = const [],
    this.listedSlots = const [],
    this.unListedSlots = const [],
    required this.fromDate,
    required this.toDate,
  });
  final List<Slot> occupiedSlots;
  final List<Slot> listedSlots;
  final List<Slot> unListedSlots;
  final DateTime fromDate;
  final DateTime toDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return CustomPaint(
            size: Size(constraints.maxWidth, 17),
            painter: _SplitRectPainter(
              occupiedSlots: occupiedSlots,
              listedSlots: listedSlots,
              unListedSlots: unListedSlots,

              fromDate: fromDate,
              toDate: DateTime(toDate.year, 12, 31),
              foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              textColor: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          );
        },
      ),
    );
  }
}

class _SplitRectPainter extends CustomPainter {
  const _SplitRectPainter({
    required this.occupiedSlots,
    required this.listedSlots,
    required this.unListedSlots,
    required this.fromDate,
    required this.toDate,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.textColor,
  });
  final List<Slot> occupiedSlots;
  final List<Slot> listedSlots;
  final List<Slot> unListedSlots;
  final DateTime fromDate;
  final DateTime toDate;
  final Color foregroundColor;
  final Color backgroundColor;
  final Color textColor;

  @override
  void paint(Canvas canvas, Size size) {
    final stopPoints = getStopPoints(occupiedSlots, fromDate, toDate);
    final listedStopPoints = getStopPoints(listedSlots, fromDate, toDate);
    final unListedStopPoints = getStopPoints(unListedSlots, fromDate, toDate);
    final markerPoints = getMarkerPoints(fromDate, toDate);

    Paint backgroundColorPaint = Paint()..color = backgroundColor;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      backgroundColorPaint,
    );
    for (var stopPoint in stopPoints) {
      // paintRectangle(stopPoint, canvas, size, foregroundColor);
      paintRectangle(stopPoint, canvas, size, Colors.red);
    }
    for (var stopPoint in listedStopPoints) {
      // paintRectangle(stopPoint, canvas, size, foregroundColor);
      paintRectangle(stopPoint, canvas, size, Colors.blue);
    }
    for (var stopPoint in unListedStopPoints) {
      // paintRectangle(stopPoint, canvas, size, foregroundColor);
      paintRectangle(stopPoint, canvas, size, Colors.green);
    }
    for (var markerPoint in markerPoints) {
      paintBar(canvas, size, foregroundColor, markerPoint['location'], 1);
      paintText(
        canvas,
        size,
        textColor,
        markerPoint['location'],
        markerPoint['year'].toString(),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // Returns false because the painting logic never changes
  }
}

void paintRectangle(
  Map<String, dynamic> stopPoint,
  Canvas canvas,
  Size size,
  Color color,
) {
  final paint = Paint()..color = color;
  canvas.drawRect(
    Rect.fromLTWH(
      stopPoint['start'] * size.width,
      2,
      (stopPoint['end'] - stopPoint['start']) * size.width,
      size.height - 4,
    ),
    paint,
  );
}

void paintBar(
  Canvas canvas,
  Size size,
  Color color,
  double horizontalLocation,
  double lineWidth,
) {
  final paint = Paint()..color = color;
  canvas.drawRect(
    Rect.fromLTWH(horizontalLocation * size.width, 0, lineWidth, size.height),
    paint,
  );
}

void paintText(
  Canvas canvas,
  Size size,
  Color color,
  double horizontalLocation,
  String text,
) {
  var textSpan = TextSpan(
    text: text,
    style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
  );

  final textPainter = TextPainter(
    text: textSpan,
    textDirection: TextDirection.ltr,
  );

  textPainter.layout();

  final offset = Offset(horizontalLocation * size.width + 3, 3);

  textPainter.paint(canvas, offset);
}

List<Map<String, dynamic>> getStopPoints(
  List<Slot> slots,
  DateTime fromDate,
  DateTime toDate,
) {
  List<Map<String, dynamic>> stopPoints = [];
  int totalDuration = toDate.difference(fromDate).inSeconds;

  for (Slot slot in slots) {
    stopPoints.add({
      'start': math.max(
        slot.from.difference(fromDate).inSeconds / totalDuration,
        0,
      ),
      'end': math.min(
        1,
        slot.to.difference(fromDate).inSeconds / totalDuration,
      ),
    });
  }

  return stopPoints;
}

List<Map<String, dynamic>> getMarkerPoints(DateTime fromDate, DateTime toDate) {
  List<Map<String, dynamic>> markerPoints = [];
  int totalDuration = toDate.difference(fromDate).inSeconds;

  for (int i = fromDate.year + 1; i < toDate.year + 1; i++) {
    markerPoints.add({
      'location':
          DateTime(i, 1, 1).difference(fromDate).inSeconds / totalDuration,
      'year': i,
    });
  }

  return markerPoints;
}
