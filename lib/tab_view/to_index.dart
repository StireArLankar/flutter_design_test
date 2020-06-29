import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'dart:math' as math;

class ToIndexPage extends StatefulWidget {
  ToIndexPage({Key key}) : super(key: key);

  @override
  _ToIndexPageState createState() => _ToIndexPageState();
}

class _ToIndexPageState extends State<ToIndexPage> with SingleTickerProviderStateMixin {
  static const maxCount = 100;
  final random = math.Random();
  final scrollDirection = Axis.vertical;
  TabController _controller;
  List<String> _tabs = [
    'firstaaaaaaaa',
    'secondaaaaaaa',
    'thirdaaaaaaa',
    'fourthaaaaaa',
    'fifthaaaaa',
  ];

  AutoScrollController _autoScrollController;
  List<List<int>> randomList;

  @override
  void initState() {
    super.initState();

    _controller = TabController(vsync: this, length: _tabs.length, initialIndex: 0);

    _autoScrollController = AutoScrollController(
      axis: scrollDirection,
    );

    randomList =
        List.generate(maxCount, (index) => <int>[index, (1000 * random.nextDouble()).toInt()]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _scrollToIndex,
        tooltip: 'Increment',
        child: Text(counter.toString()),
      ),
      body: NestedScrollView(
        controller: _autoScrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                title: const Text('Books'), // This is the title in the app bar.
                pinned: true,
                expandedHeight: 150.0,

                forceElevated: innerBoxIsScrolled,
                bottom: TabBar(
                  isScrollable: true,
                  controller: _controller,
                  tabs: _tabs.map((String name) => Tab(text: name)).toList(),
                ),
              ),
            ),
          ];
        },
        body: Builder(builder: (context) {
          return NotificationListener<ScrollNotification>(
            onNotification: (not) {
              print(not.metrics);
              return true;
            },
            child: CustomScrollView(
              key: PageStorageKey<String>('123'),
              slivers: <Widget>[
                SliverOverlapInjector(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(8.0),
                  sliver: SliverList(delegate: SliverChildBuilderDelegate((ctx, index) {
                    final data = randomList[index];
                    return Padding(
                      padding: EdgeInsets.all(8),
                      child: _getRow(data[0], math.max(data[1].toDouble(), 50.0)),
                    );
                  })),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  int counter = 20;
  Future _scrollToIndex() async {
    setState(() {
      counter++;

      if (counter >= maxCount) counter = 0;
    });

    await _autoScrollController.scrollToIndex(counter, preferPosition: AutoScrollPosition.begin);
    _autoScrollController.highlight(counter);
  }

  Widget _getRow(int index, double height) {
    return _wrapScrollTag(
      index: index,
      child: Container(
        padding: EdgeInsets.all(8),
        alignment: Alignment.topCenter,
        height: height,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.lightBlue, width: 4),
            borderRadius: BorderRadius.circular(12)),
        child: Text('index: $index, height: $height'),
      ),
    );
  }

  Widget _wrapScrollTag({int index, Widget child}) => AutoScrollTag(
        key: ValueKey(index),
        controller: _autoScrollController,
        index: index,
        child: child,
        highlightColor: Colors.black.withOpacity(0.1),
      );
}
