import 'dart:math' as Math;
import 'package:flutter/material.dart';

class CustomPageTransitionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Page1(),
    );
  }
}

class Page1 extends StatelessWidget {
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(),
        body: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.height / 2,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTapUp: (details) {
                final route = ScaleRoute(page: Page2(), offset: details.globalPosition);
                Navigator.of(context).pushReplacement(route);
              },
              child: Container(
                width: 100,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ThemeData.dark().buttonTheme.colorScheme.background,
                ),
                alignment: Alignment.center,
                child: Text('Go!'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(),
        body: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.height / 2,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTapUp: (details) {
                final route = ScaleRoute(page: Page1(), offset: details.globalPosition);
                Navigator.of(context).pushReplacement(route);
              },
              child: Container(
                width: 100,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ThemeData.light().buttonTheme.colorScheme.background,
                ),
                alignment: Alignment.center,
                child: Text('Go!'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ScaleRoute extends PageRouteBuilder {
  final Widget page;
  final Offset offset;

  static const duration = const Duration(seconds: 1);

  ScaleRoute({@required this.page, @required this.offset})
      : super(
          pageBuilder: (_, __, ___) => page,
          transitionDuration: duration,
          transitionsBuilder: (_, animation, __, child) {
            // print(animation);
            // print(__);
            return TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 1),
              duration: duration,
              curve: Curves.easeOutCubic,
              builder: (context, size, child) {
                return ClipOval(
                  clipBehavior: Clip.hardEdge,
                  clipper: MyCircleClipper(size, offset),
                  child: IgnorePointer(child: child, ignoring: size < 1.0),
                );
              },
              child: child,
            );
          },
        );
}

class MyCircleClipper extends CustomClipper<Rect> {
  final double scale;
  final Offset offset;

  MyCircleClipper(
    this.scale,
    this.offset,
  );

  double getX(Size size) => size.width + 2 * (size.width / 2 - offset.dx).abs();
  double getY(Size size) => size.height + 2 * (size.height / 2 - offset.dy).abs();

  @override
  Rect getClip(Size size) {
    var radius = Math.sqrt(Math.pow(getX(size), 2) + Math.pow(getY(size), 2));

    return Rect.fromCenter(
      center: offset,
      width: radius * scale,
      height: radius * scale,
    );
  }

  @override
  bool shouldReclip(MyCircleClipper oldClipper) {
    return scale != oldClipper.scale;
  }
}
