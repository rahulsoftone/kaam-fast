import 'package:flutter/material.dart';
import 'package:kaam_fast/utils/constants/color_picker.dart';

class AnimatedRadarWidget extends StatefulWidget {
  final double size;
  final Color color;
  final Widget? centerChild;

  const AnimatedRadarWidget({
    super.key,
    this.size = 200,
    this.color = primary,
    this.centerChild,
  });

  @override
  State<AnimatedRadarWidget> createState() => _AnimatedRadarWidgetState();
}

class _AnimatedRadarWidgetState extends State<AnimatedRadarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _RadarPainter(
              progress: _controller.value,
              color: widget.color,
            ),
            child: Center(
              child: widget.centerChild ??
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.color,
                      boxShadow: [
                        BoxShadow(
                          color: widget.color.withValues(alpha: 0.5),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.radar,
                      color: kWhite,
                      size: 26,
                    ),
                  ),
            ),
          );
        },
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  final double progress;
  final Color color;

  _RadarPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    for (int i = 0; i < 3; i++) {
      final currentProgress = (progress + (i * 0.33)) % 1.0;
      final radius = currentProgress * maxRadius;
      final opacity = (1.0 - currentProgress).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = color.withValues(alpha: opacity * 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      canvas.drawCircle(center, radius, paint);

      final fillPaint = Paint()
        ..color = color.withValues(alpha: opacity * 0.08)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(center, radius, fillPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
