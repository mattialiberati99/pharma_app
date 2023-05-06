import 'package:flutter/material.dart';
/// Draws a custom border with solid stroke with [borderColor] if provided
class TacMenuPainter extends CustomPainter {
  /// Optional color for border
  final Color? borderColor;

  TacMenuPainter({this.borderColor = Colors.transparent});

  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width*0.008196721,size.height*0.5000000);
    path_0.cubicTo(size.width*0.008196721,size.height*0.2283844,size.width*0.2283844,size.height*0.008196721,size.width*0.5000000,size.height*0.008196721);
    path_0.lineTo(size.width*0.5000000,size.height*0.008196721);
    path_0.cubicTo(size.width*0.7716156,size.height*0.008196721,size.width*0.9918033,size.height*0.2283844,size.width*0.9918033,size.height*0.5000000);
    path_0.lineTo(size.width*0.9918033,size.height*0.9918033);
    path_0.lineTo(size.width*0.5000000,size.height*0.9918033);
    path_0.cubicTo(size.width*0.2283844,size.height*0.9918033,size.width*0.008196721,size.height*0.7716156,size.width*0.008196721,size.height*0.5000000);
    path_0.lineTo(size.width*0.008196721,size.height*0.5000000);
    path_0.close();

    Paint paint_0_stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.01639344;
    paint_0_stroke.color = (borderColor ?? borderColor?.withOpacity(1.0))!;
    canvas.drawPath(path_0,paint_0_stroke);

    // Paint paint_0_fill = Paint()..style=PaintingStyle.fill;
    // paint_0_fill.color = Color(0xff000000).withOpacity(1.0);
    // canvas.drawPath(path_0,paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CustomShape extends ShapeBorder {
  const CustomShape({required this.size});

  final Size size;

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    return;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path path_0 = Path();
    path_0.moveTo(0,size.height*0.5000000);
    path_0.cubicTo(0,size.height*0.2238575,size.width*0.2238575,0,size.width*0.5000000,0);
    path_0.cubicTo(size.width*0.7761425,0,size.width,size.height*0.2238575,size.width,size.height*0.5000000);
    path_0.lineTo(size.width,size.height);
    path_0.lineTo(size.width*0.5000000,size.height);
    path_0.cubicTo(size.width*0.2238575,size.height,0,size.height*0.7761425,0,size.height*0.5000000);
    path_0.close();

    return path_0;
  }

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();

  @override
  ShapeBorder scale(double t) => CustomShape(size: size);
}