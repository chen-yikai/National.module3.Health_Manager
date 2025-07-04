import 'package:flutter/material.dart';
import 'dart:math';

class BarChartPainter extends CustomPainter {
  final List<double> data;
  final List<String> labels;
  final Color barColor;
  final Color gridColor;
  final double barWidth;
  final double animationValue;

  BarChartPainter({
    required this.data,
    required this.labels,
    this.barColor = Colors.green,
    this.gridColor = Colors.grey,
    this.barWidth = 0.6,
    this.animationValue = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final gridPaint = Paint()
      ..color = gridColor.withOpacity(0.3)
      ..strokeWidth = 1.0;

    const double margin = 40.0;
    final chartWidth = size.width - margin * 2;
    final chartHeight = size.height - margin * 2;

    final maxValue = data.reduce(max);

    for (int i = 0; i <= 5; i++) {
      final y = margin + (chartHeight / 5) * i;
      canvas.drawLine(
        Offset(margin, y),
        Offset(size.width - margin, y),
        gridPaint,
      );
    }

    final barSpacing = chartWidth / data.length;
    final actualBarWidth = barSpacing * barWidth;

    for (int i = 0; i < data.length; i++) {
      final x = margin + barSpacing * i + (barSpacing - actualBarWidth) / 2;
      final normalizedValue = maxValue > 0 ? data[i] / maxValue : 0;
      final targetBarHeight = chartHeight * normalizedValue;
      
      final barDelay = i * 0.05;
      final totalAnimationTime = 1.0 + (data.length - 1) * 0.05;
      
      final adjustedAnimationValue = (animationValue * totalAnimationTime - barDelay).clamp(0.0, 1.0);
      
      final animatedBarHeight = targetBarHeight * adjustedAnimationValue;
      final y = size.height - margin - animatedBarHeight;

      final opacity = adjustedAnimationValue;
      final gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          barColor.withOpacity(0.8 * opacity),
          barColor.withOpacity(opacity),
        ],
      );

      final rect = Rect.fromLTWH(x, y, actualBarWidth, animatedBarHeight);
      final gradientPaint = Paint()..shader = gradient.createShader(rect);

      final roundedRect = RRect.fromRectAndRadius(
        rect,
        const Radius.circular(4),
      );
      canvas.drawRRect(roundedRect, gradientPaint);

      if (adjustedAnimationValue > 0.7) {
        final textOpacity = ((adjustedAnimationValue - 0.7) / 0.3).clamp(0.0, 1.0);
        final textPainter = TextPainter(
          text: TextSpan(
            text: data[i].toInt().toString(),
            style: TextStyle(
              color: Colors.black87.withOpacity(textOpacity),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
            x + (actualBarWidth - textPainter.width) / 2,
            y - textPainter.height - 5,
          ),
        );
      }
    }

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i <= 5; i++) {
      final value = maxValue - (maxValue / 5) * i;
      final y = margin + (chartHeight / 5) * i;

      textPainter.text = TextSpan(
        text: value.toInt().toString(),
        style: const TextStyle(color: Colors.black54, fontSize: 12),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(5, y - textPainter.height / 2));
    }

    for (int i = 0; i < labels.length; i++) {
      final x = margin + barSpacing * i + barSpacing / 2;

      textPainter.text = TextSpan(
        text: labels[i],
        style: const TextStyle(color: Colors.black54, fontSize: 12),
      );
      textPainter.layout();
      textPainter.paint(
          canvas, Offset(x - textPainter.width / 2, size.height - 30));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
