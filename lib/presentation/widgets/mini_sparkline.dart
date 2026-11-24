import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class MiniSparkline extends StatelessWidget {
  final List<double> points;
  final bool isPositive;
  final double width;
  final double height;

  const MiniSparkline({
    super.key,
    required this.points,
    required this.isPositive,
    this.width = 54.0,
    this.height = 28.0,
  });

  @override
  Widget build(BuildContext context) {
    if (points.length < 2) return SizedBox(width: width, height: height);

    return CustomPaint(
      size: Size(width, height),
      painter: _SparklinePainter(
        points: points,
        color: isPositive ? AppColors.marketGreen : AppColors.marketRed,
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> points;
  final Color color;

  _SparklinePainter({required this.points, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final min = points.reduce((a, b) => a < b ? a : b);
    final max = points.reduce((a, b) => a > b ? a : b);
    final range = (max - min == 0) ? 1.0 : (max - min);

    final path = Path();
    for (int i = 0; i < points.length; i++) {
      final x = (i / (points.length - 1)) * size.width;
      final normalizedY = (points[i] - min) / range;
      final y = size.height - (normalizedY * size.height);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) => true;
}
