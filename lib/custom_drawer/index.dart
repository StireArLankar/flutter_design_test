import 'package:flutter/material.dart';

import 'custom_drawer.dart';
import 'custom_drawer_guitar.dart';
import 'custom_drawer_discord.dart';

enum Variants { Scale, Rotate, Translate }

Variants variant = Variants.Translate;

class CustomDrawerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppBar appBar;
    Widget child;

    switch (variant) {
      case Variants.Rotate:
        appBar = AppBar();
        child = MyHomePage(appBar: appBar);
        child = CustomGuitarDrawer(child: child);
        break;

      case Variants.Scale:
        appBar = AppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => CustomDrawer.of(context).open(),
            ),
          ),
          title: Text('Hello Flutter Europe'),
        );
        child = MyHomePage(appBar: appBar);
        child = CustomDrawer(child: child);
        break;

      case Variants.Translate:
        appBar = AppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => CustomDrawerDiscord.of(context).toggleDrawer(),
            ),
          ),
          actions: <Widget>[
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.menu),
                onPressed: () => CustomDrawerDiscord.of(context).toggleDrawer2(),
              ),
            ),
          ],
          title: Text('Hello Custom Discord Drawer'),
        );
        child = MyHomePage(appBar: appBar);
        child = CustomDrawerDiscord(child: child);
        break;
    }

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: child,
    );
  }
}

class MyHomePage extends StatefulWidget {
  final AppBar appBar;

  MyHomePage({Key key, @required this.appBar}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() => _counter++);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
