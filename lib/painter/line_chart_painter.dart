import 'package:flutter/material.dart';
import 'dart:math';

class LineChartPainter extends CustomPainter {
  final List<double> data;
  final List<String> labels;
  final Color lineColor;
  final Color pointColor;
  final Color gridColor;
  final double animationValue;

  LineChartPainter({
    required this.data,
    required this.labels,
    this.lineColor = Colors.blue,
    this.pointColor = Colors.blueAccent,
    this.gridColor = Colors.grey,
    this.animationValue = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final gridPaint = Paint()
      ..color = gridColor.withOpacity(0.3)
      ..strokeWidth = 1.0;

    const margin = 40.0;
    final chartWidth = size.width - margin * 2;
    final chartHeight = size.height - margin * 2;

    final maxValue = data.reduce(max);
    final minValue = data.reduce(min);
    final range = maxValue - minValue;

    for (int i = 0; i <= 5; i++) {
      final y = margin + (chartHeight / 5) * i;
      canvas.drawLine(
        Offset(margin, y),
        Offset(size.width - margin, y),
        gridPaint,
      );
    }

    for (int i = 0; i < data.length; i++) {
      final x = margin + (chartWidth / (data.length - 1)) * i;
      canvas.drawLine(
        Offset(x, margin),
        Offset(x, size.height - margin),
        gridPaint,
      );
    }

    final path = Path();
    final animatedPoints = <Offset>[];
    
    for (int i = 0; i < data.length; i++) {
      final x = margin + (chartWidth / (data.length - 1)) * i;
      final normalizedValue = range > 0 ? (data[i] - minValue) / range : 0.5;
      final targetY = size.height - margin - (chartHeight * normalizedValue);
      
      final startY = size.height - margin;
      final animatedY = startY + (targetY - startY) * animationValue;
      
      final point = Offset(x, animatedY);
      animatedPoints.add(point);
      
      if (i == 0) {
        path.moveTo(x, animatedY);
      } else {
        path.lineTo(x, animatedY);
      }
    }

    if (animationValue > 0) {
      canvas.drawPath(path, paint);
    }

    for (int i = 0; i < animatedPoints.length; i++) {
      final point = animatedPoints[i];
      final pointDelay = i * 0.1;
      final pointProgress = (animationValue - pointDelay).clamp(0.0, 1.0);
      
      if (pointProgress > 0) {
        final animatedPointPaint = Paint()
          ..color = pointColor.withOpacity(pointProgress)
          ..style = PaintingStyle.fill;
        
        canvas.drawCircle(point, 4.0 * pointProgress, animatedPointPaint);
      }
    }

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i <= 5; i++) {
      final value = maxValue - (range / 5) * i;
      final y = margin + (chartHeight / 5) * i;
      
      textPainter.text = TextSpan(
        text: value.toInt().toString(),
        style: const TextStyle(color: Colors.black54, fontSize: 12),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(5, y - textPainter.height / 2));
    }

    for (int i = 0; i < labels.length; i++) {
      final x = margin + (chartWidth / (data.length - 1)) * i;
      
      textPainter.text = TextSpan(
        text: labels[i],
        style: const TextStyle(color: Colors.black54, fontSize: 12),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, size.height - 30));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
