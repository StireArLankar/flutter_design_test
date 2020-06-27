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
      data: ThemeData.dark().copyWith(buttonColor: Colors.amber[200]),
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Stack(
            children: <Widget>[
              AlignButton(Alignment.topLeft, Page2()),
              AlignButton(Alignment.topLeft, Page2()),
              AlignButton(Alignment.topCenter, Page2()),
              AlignButton(Alignment.topRight, Page2()),
              AlignButton(Alignment.centerRight, Page2()),
              AlignButton(Alignment.bottomRight, Page2()),
              AlignButton(Alignment.bottomCenter, Page2()),
              AlignButton(Alignment.bottomLeft, Page2()),
              AlignButton(Alignment.centerLeft, Page2()),
              AlignButton(Alignment.center, Page2()),
            ],
          ),
        ),
      ),
    );
  }
}

class AlignButton extends StatelessWidget {
  final AlignmentGeometry align;
  final Widget page;

  const AlignButton(
    this.align,
    this.page, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: align,
      child: GestureDetector(
        onTapUp: (details) {
          final route = ScaleRoute(page: page, offset: details.globalPosition);
          Navigator.of(context).pushReplacement(route);
        },
        child: Container(
          width: 100,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).buttonTheme.colorScheme.primaryVariant,
          ),
          alignment: Alignment.center,
          child: Text('Go!'),
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
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Stack(
            children: <Widget>[
              AlignButton(Alignment.topLeft, Page1()),
              AlignButton(Alignment.topLeft, Page1()),
              AlignButton(Alignment.topCenter, Page1()),
              AlignButton(Alignment.topRight, Page1()),
              AlignButton(Alignment.centerRight, Page1()),
              AlignButton(Alignment.bottomRight, Page1()),
              AlignButton(Alignment.bottomCenter, Page1()),
              AlignButton(Alignment.bottomLeft, Page1()),
              AlignButton(Alignment.centerLeft, Page1()),
              AlignButton(Alignment.center, Page1()),
            ],
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
