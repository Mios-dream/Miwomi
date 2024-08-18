// import 'package:flutter/material.dart';
// import 'dart:math' as math;
//
// void main() {
//   runApp(MaterialApp(
//     home: Scaffold(
//       backgroundColor: Colors.black,
//       body: Center(
//         child: TemperatureControl(),
//       ),
//     ),
//   ));
// }
//
// class TemperatureControl extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       size: const Size(200, 200),
//       painter: TemperatureControlPainter(),
//     );
//   }
// }
//
// class TemperatureControlPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()
//       ..color = Colors.grey[850]!
//       ..style = PaintingStyle.fill;
//
//     // Draw background circle
//     canvas.drawCircle(
//         Offset(size.width / 2, size.height / 2), size.width / 2, paint);
//
//     // Draw the temperature arc (pink)
//     paint
//       ..color = Colors.pinkAccent
//       ..strokeWidth = 10
//       ..style = PaintingStyle.stroke;
//     canvas.drawArc(
//         Rect.fromCircle(
//             center: Offset(size.width / 2, size.height / 2),
//             radius: size.width / 2 - 10),
//         math.pi * 1.25, // start angle
//         math.pi * 0.5, // sweep angle
//         false,
//         paint);
//
//     // Draw the temperature arc (blue)
//     paint.color = Colors.blueAccent;
//     canvas.drawArc(
//         Rect.fromCircle(
//             center: Offset(size.width / 2, size.height / 2),
//             radius: size.width / 2 - 10),
//         math.pi * 1.75,
//         math.pi * 0.5,
//         false,
//         paint);
//
//     // Draw the center text (20°)
//     TextSpan span = new TextSpan(
//         style: new TextStyle(color: Colors.white, fontSize: 24), text: '20°');
//     TextPainter tp = new TextPainter(
//         text: span,
//         textAlign: TextAlign.center,
//         textDirection: TextDirection.ltr);
//     tp.layout();
//     tp.paint(canvas,
//         Offset(size.width / 2 - tp.width / 2, size.height / 2 - tp.height / 2));
//
//     // Draw "室内温度" text below the temperature value
//     span = new TextSpan(
//         style: new TextStyle(color: Colors.grey, fontSize: 14), text: '室内温度');
//     tp = new TextPainter(
//         text: span,
//         textAlign: TextAlign.center,
//         textDirection: TextDirection.ltr);
//     tp.layout();
//     tp.paint(canvas,
//         Offset(size.width / 2 - tp.width / 2, size.height / 2 + tp.height));
//
//     // Draw the bottom information ("69m²", "69m")
//     span = new TextSpan(
//         style: new TextStyle(color: Colors.white, fontSize: 16), text: '69m²');
//     tp = new TextPainter(
//         text: span,
//         textAlign: TextAlign.center,
//         textDirection: TextDirection.ltr);
//     tp.layout();
//     tp.paint(canvas, Offset(size.width / 2 - tp.width - 20, size.height - 50));
//
//     span = new TextSpan(
//         style: new TextStyle(color: Colors.white, fontSize: 16), text: '69m');
//     tp = new TextPainter(
//         text: span,
//         textAlign: TextAlign.center,
//         textDirection: TextDirection.ltr);
//     tp.layout();
//     tp.paint(canvas, Offset(size.width / 2 + 20, size.height - 50));
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }

import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: CustomCircularProgressIndicator(),
        ),
      ),
    );
  }
}

class CustomCircularProgressIndicator extends StatefulWidget {
  const CustomCircularProgressIndicator({Key? key}) : super(key: key);

  @override
  _CustomCircularProgressIndicatorState createState() =>
      _CustomCircularProgressIndicatorState();
}

class _CustomCircularProgressIndicatorState
    extends State<CustomCircularProgressIndicator> {
  double _progress = 0.5; // 设置进度值

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      child: CustomPaint(
        painter: _CircularGradientPainter(_progress),
      ),
    );
  }
}

class _CircularGradientPainter extends CustomPainter {
  double progress;

  _CircularGradientPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment(-1, -1),
        end: Alignment(1, 1),
        colors: <Color>[
          Colors.red,
          Colors.purple,
          Colors.blue,
        ],
      ).createShader(Rect.fromLTWH(0.0, 0.0, size.width, size.height));

    paint.strokeCap = StrokeCap.round;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 20.0;

    final Rect rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2 - paint.strokeWidth / 2,
    );

    canvas.drawArc(rect, -math.pi / 2, 2 * math.pi * progress, false, paint);
  }

  @override
  bool shouldRepaint(_CircularGradientPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
