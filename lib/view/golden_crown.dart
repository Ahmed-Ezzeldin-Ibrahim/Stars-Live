import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:provider/provider.dart';
import '../constant/contant.dart';
import '../provider/top_users_provider.dart';
import '../widget/top_users/gift_recievers/daily_gift_recievers.dart';
import '../widget/top_users/gift_recievers/monthly_gift_recievers.dart';
import '../widget/top_users/gift_recievers/yearly_gift_recievers.dart';
import '../widget/top_users/gift_senders/daily_gift_senders.dart';
import '../widget/top_users/gift_senders/monthly_gift_senders.dart';
import '../widget/top_users/gift_senders/yearly_gift_senders.dart';

class GoldenCrown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _kTabPages = <Widget>[
      //const Center(child: Icon(Icons.cloud, size: 64.0, color: Colors.teal)),
      TabsExample1(),
      TabsExample2(),
    ];
    final _kTabs = <Widget>[
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: const Tab(
          text: 'الماسات المستلمة',
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white,
            )),
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: const Tab(
          text: 'الكوينز المقدمة',
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white,
            )),
      ),
    ];
    return DefaultTabController(
      length: _kTabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الترتيب'),
          centerTitle: true,
          backgroundColor: baseColor,
          bottom: TabBar(
            tabs: _kTabs,
          ),
        ),
        body: TabBarView(
          children: _kTabPages,
        ),
      ),
    );
  }
}

class TabsExample1 extends StatefulWidget {
  @override
  State<TabsExample1> createState() => _TabsExample1State();
}

class _TabsExample1State extends State<TabsExample1> {
  bool selected;
  @override
  Widget build(BuildContext context) {
    final _kTabs = <Widget>[
      Container(
        child: const Tab(
          text: 'اليوم',
        ),
      ),
      Container(
        child: const Tab(
          text: 'الشهر ',
        ),
      ),
      Container(
        child: const Tab(
          text: 'السنة',
        ),
      ),
    ];
    return DefaultTabController(
      length: _kTabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: baseColor,
          title: TabBar(
            tabs: _kTabs,
          ),
        ),
        body: TabBarView(
          children: [
            DailyGiftRecievers(),
            MonthlyGiftRecievers(),
            YearlyGiftRecievers(),
          ],
        ),
      ),
    );
  }
}

class TabsExample2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _kTabs = <Widget>[
      Container(
        child: const Tab(
          text: 'اليوم',
        ),
      ),
      Container(
        child: const Tab(
          text: 'الشهر',
        ),
      ),
      Container(
        child: const Tab(
          text: 'السنة',
        ),
      ),
    ];
    return DefaultTabController(
      length: _kTabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: baseColor,
          title: TabBar(
            tabs: _kTabs,
          ),
        ),
        body: TabBarView(
          children: [
            DailyGiftSenders(),
            MonthlyGiftSenders(),
            YearlyGiftSenders(),
          ],
        ),
      ),
    );
  }
}
