import 'package:flutter/material.dart';

class Header extends StatefulWidget {
  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverPersistentHeader(
          pinned: true,
          delegate: SliverCustomHeaderDelegate(
            collapsedHeight: 50,
            coverImgUrl: 'https://images.alphacoders.com/720/thumb-1920-720915.png',
            expandedHeight: 300,
            title: 'Title',
            paddingTop: MediaQuery.of(context).viewPadding.top,
          ),
        ),
        SliverPersistentHeader(
          pinned: true,
          delegate: StickyTabBarDelegate(
            child: ColoredTabBar(
              color: Color.fromRGBO(20, 20, 20, 0.2),
              tabBar: TabBar(
                labelColor: Colors.black,
                controller: _tabController,
                tabs: <Widget>[
                  Tab(text: 'Home'),
                  Tab(text: 'Profile'),
                ],
              ),
            ),
          ),
        ),
        // SliverAppBar(
        //   pinned: true,
        //   actions: <Widget>[
        //     IconButton(
        //       icon: Icon(Icons.list),
        //       onPressed: () {},
        //     )
        //   ],
        //   expandedHeight: 120,
        //   backgroundColor: Colors.cyan[400],
        //   flexibleSpace: FlexibleSpaceBar(
        //     background: Image.network(
        //       'https://images.alphacoders.com/720/thumb-1920-720915.png',
        //       fit: BoxFit.cover,
        //     ),
        //     title: Text('Pinned'),
        //   ),
        // ),
        SliverFillRemaining(
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              Container(
                color: Colors.red[50],
                child: Text('Content of Home'),
              ),
              Center(child: Text('Content of Profile')),
            ],
          ),
        ),
      ],
    );
  }
}

class SliverCustomHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double collapsedHeight;
  final double expandedHeight;
  final double paddingTop;
  final String coverImgUrl;
  final String title;

  SliverCustomHeaderDelegate({
    this.collapsedHeight,
    this.expandedHeight,
    this.paddingTop,
    this.coverImgUrl,
    this.title,
  });

  @override
  double get minExtent => collapsedHeight + paddingTop;

  @override
  double get maxExtent => expandedHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  Color makeStickyHeaderBgColor(double shrinkOffset) {
    final int alpha = (shrinkOffset / (maxExtent - minExtent) * 255).clamp(0, 255).toInt();
    return Color.fromARGB(alpha, 255, 255, 255);
  }

  Color makeStickyHeaderTextColor(double shrinkOffset, bool isIcon) {
    if (shrinkOffset <= 50) {
      return isIcon ? Colors.white : Colors.transparent;
    } else {
      final int alpha = (shrinkOffset / (maxExtent - minExtent) * 255).clamp(0, 255).toInt();
      return Color.fromARGB(alpha, 0, 0, 0);
    }
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      height: maxExtent,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Background image
          Container(child: Image.network(coverImgUrl, fit: BoxFit.cover)),
          // Put your head back
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(
              color: makeStickyHeaderBgColor(shrinkOffset), // Background color
              child: SafeArea(
                bottom: false,
                child: Container(
                  height: collapsedHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: makeStickyHeaderTextColor(
                            shrinkOffset,
                            true,
                          ), // Return icon color
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Builder(builder: (context) {
                        var fontSize = 20.0;

                        if (shrinkOffset > 100) {
                          fontSize = 30.0;
                        } else if (shrinkOffset < 100 && shrinkOffset > 50) {
                          final temp = (shrinkOffset - 50) / 5;
                          fontSize = temp + 20;
                        }

                        return Text(
                          title,
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.w500,
                            color: makeStickyHeaderTextColor(
                              shrinkOffset,
                              true,
                            ), // Title color
                          ),
                        );
                      }),
                      IconButton(
                        icon: Icon(
                          Icons.share,
                          color: makeStickyHeaderTextColor(
                            shrinkOffset,
                            true,
                          ), // Share icon color
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final PreferredSizeWidget child;

  StickyTabBarDelegate({@required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get maxExtent => child.preferredSize.height;

  @override
  double get minExtent => child.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class ColoredTabBar extends Container implements PreferredSizeWidget {
  ColoredTabBar({this.color, this.tabBar});

  final Color color;
  final TabBar tabBar;

  @override
  Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: tabBar,
    );
  }
}
