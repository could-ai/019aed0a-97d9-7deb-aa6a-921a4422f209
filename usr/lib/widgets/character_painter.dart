import 'package:flutter/material.dart';
import 'dart:math';

class CharacterPainter extends CustomPainter {
  final double happiness;
  final double energy;
  final bool isSleeping;
  final bool isDirty;

  CharacterPainter({
    required this.happiness,
    required this.energy,
    required this.isSleeping,
    required this.isDirty,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE0AC69) // Skin tone
      ..style = PaintingStyle.fill;

    final outlinePaint = Paint()
      ..color = Colors.brown.shade900
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    // Draw the main body shape (Abstract "Pou" like shape but elongated)
    final path = Path();
    
    // Base width
    double w = size.width;
    double h = size.height;
    
    // A slightly phallic but cartoonish blob shape (rounded cylinder with a wider base)
    path.moveTo(w * 0.2, h * 0.9); // Bottom left
    path.quadraticBezierTo(w * 0.1, h * 0.5, w * 0.2, h * 0.3); // Left side curve
    path.quadraticBezierTo(w * 0.2, h * 0.05, w * 0.5, h * 0.05); // Top curve (head)
    path.quadraticBezierTo(w * 0.8, h * 0.05, w * 0.8, h * 0.3); // Top right
    path.quadraticBezierTo(w * 0.9, h * 0.5, w * 0.8, h * 0.9); // Right side curve
    path.quadraticBezierTo(w * 0.5, h * 1.0, w * 0.2, h * 0.9); // Bottom curve
    
    path.close();

    // Draw shadow
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.95), width: w * 0.7, height: 20),
      Paint()..color = Colors.black26,
    );

    // Draw body
    canvas.drawPath(path, paint);
    canvas.drawPath(path, outlinePaint);

    // Draw "Hood" line (distinctive feature)
    final hoodPath = Path();
    hoodPath.moveTo(w * 0.2, h * 0.35);
    hoodPath.quadraticBezierTo(w * 0.5, h * 0.45, w * 0.8, h * 0.35);
    canvas.drawPath(hoodPath, outlinePaint..strokeWidth = 2.0..color = Colors.brown.shade800.withOpacity(0.5));


    // Draw Face
    _drawFace(canvas, size);

    // Draw Dirt if dirty
    if (isDirty) {
      _drawDirt(canvas, size);
    }
  }

  void _drawFace(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;
    
    // Eyes
    if (isSleeping) {
      // Closed eyes
      final eyePaint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0;
      
      canvas.drawLine(Offset(w * 0.35, h * 0.4), Offset(w * 0.45, h * 0.4), eyePaint);
      canvas.drawLine(Offset(w * 0.55, h * 0.4), Offset(w * 0.65, h * 0.4), eyePaint);
    } else {
      // Open eyes
      final whitePaint = Paint()..color = Colors.white;
      final pupilPaint = Paint()..color = Colors.black;

      // Left Eye
      canvas.drawCircle(Offset(w * 0.4, h * 0.4), 12, whitePaint);
      canvas.drawCircle(Offset(w * 0.4, h * 0.4), 5, pupilPaint);

      // Right Eye
      canvas.drawCircle(Offset(w * 0.6, h * 0.4), 12, whitePaint);
      canvas.drawCircle(Offset(w * 0.6, h * 0.4), 5, pupilPaint);
    }

    // Mouth
    final mouthPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final mouthPath = Path();
    if (happiness > 50) {
      // Happy smile
      mouthPath.moveTo(w * 0.4, h * 0.55);
      mouthPath.quadraticBezierTo(w * 0.5, h * 0.65, w * 0.6, h * 0.55);
    } else {
      // Sad frown
      mouthPath.moveTo(w * 0.4, h * 0.6);
      mouthPath.quadraticBezierTo(w * 0.5, h * 0.55, w * 0.6, h * 0.6);
    }
    canvas.drawPath(mouthPath, mouthPaint);
  }

  void _drawDirt(Canvas canvas, Size size) {
    final dirtPaint = Paint()..color = Colors.brown.withOpacity(0.6);
    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.7), 10, dirtPaint);
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.6), 15, dirtPaint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.2), 8, dirtPaint);
  }

  @override
  bool shouldRepaint(covariant CharacterPainter oldDelegate) {
    return oldDelegate.happiness != happiness ||
           oldDelegate.energy != energy ||
           oldDelegate.isSleeping != isSleeping ||
           oldDelegate.isDirty != isDirty;
  }
}
