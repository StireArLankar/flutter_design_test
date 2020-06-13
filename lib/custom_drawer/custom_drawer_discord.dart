import 'package:flutter/material.dart';

class CustomDrawerDiscord extends StatefulWidget {
  final Widget child;

  const CustomDrawerDiscord({Key key, @required this.child}) : super(key: key);

  static CustomDrawerDiscordState of(BuildContext context) =>
      context.findAncestorStateOfType<CustomDrawerDiscordState>();

  @override
  CustomDrawerDiscordState createState() => CustomDrawerDiscordState();
}

class CustomDrawerDiscordState extends State<CustomDrawerDiscord>
    with SingleTickerProviderStateMixin {
  static const Duration toggleDuration = Duration(milliseconds: 250);
  static const double maxSlide = 225;
  static const double minDragStartEdge = 60;
  static const double maxDragStartEdge = maxSlide - 16;
  AnimationController _animationController;
  bool _canBeDragged = false;

  bool isDraggingLeft = false;
  bool isDraggingRight = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: CustomDrawerDiscordState.toggleDuration,
      lowerBound: -1.0,
      upperBound: 1.0,
      value: 0.0,
    );
  }

  void close() => _animationController.animateTo(
        0.0,
        duration: CustomDrawerDiscordState.toggleDuration,
      );

  void open() => _animationController.animateTo(
        -1.0,
        duration: CustomDrawerDiscordState.toggleDuration,
      );

  void open2() => _animationController.animateTo(
        1.0,
        duration: CustomDrawerDiscordState.toggleDuration,
      );

  void toggleDrawer() => _animationController.value == -1.0 ? close() : open();
  void toggleDrawer2() => _animationController.value == 1.0 ? close() : open2();

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_animationController.isCompleted) {
          close();
          return false;
        }
        return true;
      },
      child: GestureDetector(
        onHorizontalDragStart: _onDragStart,
        onHorizontalDragUpdate: _onDragUpdate,
        onHorizontalDragEnd: _onDragEnd,
        child: AnimatedBuilder(
          animation: _animationController,
          child: widget.child,
          builder: (context, child) {
            double animValue = _animationController.value;
            final slideAmount = -maxSlide * animValue;

            return Stack(
              children: <Widget>[
                Opacity(
                  child: MyDrawer(),
                  opacity: (-animValue).clamp(0.0, 1.0),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Opacity(
                    child: MyDrawer2(),
                    opacity: (animValue).clamp(0.0, 1.0),
                  ),
                ),
                Container(color: Colors.black12, width: double.infinity, height: double.infinity),
                Transform(
                  transform: Matrix4.identity()..translate(slideAmount),
                  alignment: Alignment.centerLeft,
                  child: Opacity(
                    opacity: (1 - animValue.abs() / 2).clamp(0.5, 1.0),
                    child: GestureDetector(
                      onTap: _animationController.isCompleted ? close : null,
                      child: child,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _onDragStart(DragStartDetails details) {
    final width = MediaQuery.of(context).size.width;

    bool isDragOpenFromLeft =
        _animationController.value == 0.0 && details.globalPosition.dx < minDragStartEdge;

    bool isDragCloseFromRight =
        _animationController.value == -1.0 && details.globalPosition.dx > maxDragStartEdge;

    bool fromRightClosed =
        _animationController.value == 0.0 && details.globalPosition.dx > width - minDragStartEdge;

    bool fromRight =
        _animationController.value == 1.0 && details.globalPosition.dx < width - maxDragStartEdge;

    if (isDragOpenFromLeft || isDragCloseFromRight) {
      isDraggingLeft = true;
    }

    if (fromRightClosed || fromRight) {
      isDraggingRight = true;
    }

    _canBeDragged = isDraggingLeft || isDraggingRight;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      double delta = -details.primaryDelta / maxSlide;

      if (isDraggingRight) {
        _animationController.value = (_animationController.value + delta).clamp(0.0, 1.0);
      } else if (isDraggingLeft) {
        _animationController.value = (_animationController.value + delta).clamp(-1.0, 0.0);
      }
    }
  }

  void _onDragEnd(DragEndDetails details) {
    if (_animationController.isDismissed || _animationController.isCompleted) {
      return;
    }

    final dur = CustomDrawerDiscordState.toggleDuration.inMilliseconds;

    if (_animationController.value < -0.5) {
      _animationController.animateTo(
        -1.0,
        duration: Duration(milliseconds: (dur * (1.0 + _animationController.value)).round()),
      );
    } else if (_animationController.value > 0.5) {
      _animationController.animateTo(
        1.0,
        duration: Duration(milliseconds: (dur * (1.0 - _animationController.value)).round()),
      );
    } else {
      _animationController.animateTo(
        0.0,
        duration: Duration(milliseconds: (dur * _animationController.value.abs()).round()),
      );
    }

    isDraggingRight = false;
    isDraggingLeft = false;
  }
}

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blueAccent,
      child: SafeArea(
        child: Theme(
          data: ThemeData(brightness: Brightness.dark),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              ListTile(
                leading: Icon(Icons.new_releases),
                title: Text('News'),
              ),
              ListTile(
                leading: Icon(Icons.star),
                title: Text('Favourites'),
              ),
              ListTile(
                leading: Icon(Icons.map),
                title: Text('Map'),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyDrawer2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blueAccent,
      child: SafeArea(
        child: Theme(
          data: ThemeData(brightness: Brightness.dark),
          child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                buildRow(Icons.new_releases, 'News'),
                buildRow(Icons.star, 'Favourites'),
                buildRow(Icons.map, 'Map'),
                buildRow(Icons.settings, 'Settings'),
                buildRow(Icons.person, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRow(IconData icon, String text) {
    return Container(
      width: CustomDrawerDiscordState.maxSlide,
      child: ListTile(
        leading: Icon(icon),
        title: Text(text),
      ),
    );
  }
}
