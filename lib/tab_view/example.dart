import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class Example extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  AutoScrollController _autoScrollController;
  final scrollDirection = Axis.vertical;

  bool isExpaned = true;
  bool get _isAppBarExpanded {
    return _autoScrollController.hasClients &&
        _autoScrollController.offset > (160 - kToolbarHeight);
  }

  @override
  void initState() {
    _autoScrollController = AutoScrollController(
      viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: scrollDirection,
    )..addListener(() {
        _isAppBarExpanded
            ? isExpaned != false
                ? setState(
                    () {
                      isExpaned = false;
                      print('setState is called');
                    },
                  )
                : {}
            : isExpaned != true
                ? setState(() {
                    print('setState is called');
                    isExpaned = true;
                  })
                : {};
      });

    super.initState();
  }

  Future _scrollToIndex(int index) async {
    await _autoScrollController.scrollToIndex(index, preferPosition: AutoScrollPosition.begin);
    _autoScrollController.highlight(index);
  }

  Widget _wrapScrollTag({int index, Widget child}) {
    return AutoScrollTag(
      key: ValueKey(index),
      controller: _autoScrollController,
      index: index,
      child: child,
      highlightColor: Colors.black.withOpacity(0.1),
    );
  }

  _buildSliverAppbar() {
    return SliverAppBar(
      brightness: Brightness.light,
      pinned: true,
      expandedHeight: 200.0,
      backgroundColor: Colors.black,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        // background: BackgroundSliverAppBar(),
        background: Image.network(
          'https://images.alphacoders.com/720/thumb-1920-720915.png',
          fit: BoxFit.cover,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: isExpaned ? 0.0 : 1,
          child: DefaultTabController(
            length: 3,
            child: TabBar(
              onTap: (index) async {
                _scrollToIndex(index);
              },
              tabs: List.generate(
                3,
                (i) {
                  return Tab(
                    text: 'Detail Business',
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (not) {
          print(not.metrics);
          return true;
        },
        child: CustomScrollView(
          controller: _autoScrollController,
          slivers: <Widget>[
            _buildSliverAppbar(),
            SliverList(
                delegate: SliverChildListDelegate([
              _wrapScrollTag(
                  index: 0,
                  child: Container(
                    height: 300,
                    color: Colors.blue,
                  )),
              _wrapScrollTag(
                  index: 1,
                  child: Container(
                    height: 300,
                    color: Colors.green,
                  )),
              _wrapScrollTag(
                  index: 2,
                  child: Container(
                    height: 300,
                    color: Colors.red,
                  )),
            ])),
          ],
        ),
      ),
    );
  }
}
