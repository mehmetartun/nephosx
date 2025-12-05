import 'package:flutter/material.dart';

import '../model/gpu_transaction.dart';

class OccupationView extends StatelessWidget {
  const OccupationView({
    super.key,
    required this.transactions,
    required this.fromDate,
    required this.toDate,
  });
  final List<GpuTransaction> transactions;
  final DateTime fromDate;
  final DateTime toDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,

      child: LayoutBuilder(
        builder: (context, constraints) {
          return CustomPaint(
            size: Size(constraints.maxWidth, 17),
            painter: _SplitRectPainter(
              transactions: transactions,
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
    required this.transactions,
    required this.fromDate,
    required this.toDate,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.textColor,
  });
  final List<GpuTransaction> transactions;
  final DateTime fromDate;
  final DateTime toDate;
  final Color foregroundColor;
  final Color backgroundColor;
  final Color textColor;

  @override
  void paint(Canvas canvas, Size size) {
    final stopPoints = getStopPoints(transactions, fromDate, toDate);
    final markerPoints = getMarkerPoints(fromDate, toDate);

    Paint backgroundColorPaint = Paint()..color = backgroundColor;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      backgroundColorPaint,
    );
    for (var stopPoint in stopPoints) {
      // paintRectangle(stopPoint, canvas, size, foregroundColor);
      paintRectangle(stopPoint, canvas, size, Colors.black26);
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
  List<GpuTransaction> transactions,
  DateTime fromDate,
  DateTime toDate,
) {
  List<Map<String, dynamic>> stopPoints = [];
  int totalDuration = toDate.difference(fromDate).inSeconds;

  for (GpuTransaction transaction in transactions) {
    stopPoints.add({
      'start':
          transaction.startDate.difference(fromDate).inSeconds / totalDuration,
      'end': transaction.endDate.difference(fromDate).inSeconds / totalDuration,
    });
  }

  return stopPoints;
}

List<Map<String, dynamic>> getMarkerPoints(DateTime fromDate, DateTime toDate) {
  List<Map<String, dynamic>> markerPoints = [];
  int totalDuration = toDate.difference(fromDate).inSeconds;

  int numYears = toDate.year - fromDate.year;

  for (int i = fromDate.year; i <= toDate.year; i++) {
    markerPoints.add({
      'location':
          DateTime(i, 1, 1).difference(fromDate).inSeconds / totalDuration,
      'year': i,
    });
  }

  return markerPoints;
}
