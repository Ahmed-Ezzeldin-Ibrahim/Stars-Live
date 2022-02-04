import 'package:flutter/material.dart';
import '../constant/contant.dart';
import '../repository/user_repository.dart';
import '../widget/user_broadcaster_level.dart';
import '../widget/user_level_widget.dart';

class UserLevel extends StatefulWidget {
  @override
  State<UserLevel> createState() => _UserLevelState();
}

class _UserLevelState extends State<UserLevel> with TickerProviderStateMixin {
  TabController _tabController;
  ScrollController scrollController;
  @override
  void initState() {
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int height = 150;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverAppBar(
            backgroundColor: baseColor,
            pinned: true,
            title: TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Colors.white,
              controller: _tabController,
              tabs: [
                Tab(text: "مستوي المستخدم"),
                Tab(text: "مستوي المضيف"),
              ],
            ),
          ),
        ];
      },
      body: Scaffold(
        body: TabBarView(controller: _tabController, children: [
          UserLevelWidget(),
          UserBroadcasterLevel(),
          //Container(child: Text("Broadcaster Level")),
        ]),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

/*DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Colors.transparent,
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                bottom: TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(text: "Level1"),
                    Tab(text: "Level1"),
                  ],
                ),
              ),
            ];
          },
          body: 
        ),
      ),*/

/* AppBar(
    
        backgroundColor: Colors.transparent,
        toolbarHeight: 30,
        bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            controller: _tabController,
            tabs: [
              Tab(text: 'User Lv.'),
              Tab(text: 'Broadcaster Lv.'),
            ]),
      ),


      Center(
        child: TabBarView(
          controller: _tabController,
          children: [
            Container(),
            Container(),
          ],
        ),*/
