import 'package:flutter/material.dart';

import '../model/User.dart';
import '../repository/user_repository.dart';
import '../widget/level_color.dart';

class profileScreen extends StatefulWidget {
  User profileUser;
  profileScreen(this.profileUser);
  @override
  _profileScreenState createState() => _profileScreenState();
}

class _profileScreenState extends State<profileScreen> {
  String name, path;
  int level;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.network(
              widget.profileUser.image,
              width: MediaQuery.of(context).size.width,
              height: 200,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${widget.profileUser.name}',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Text(
              '${widget.profileUser.id}',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  decoration: BoxDecoration(gradient: LevelColors.getColor(widget.profileUser.userLevel.level), borderRadius: BorderRadius.circular(20)),
                  width: 120,
                  height: 50,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Lv.${widget.profileUser.userLevel.level}',
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20)),
                  width: 120,
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Lv.${currentUser.value.userLevel.level}',
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(30)),
                  child: FlatButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.favorite,
                        color: Colors.white,
                      ),
                      label: Text(
                        'دردشة',
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(30)),
                  child: FlatButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      label: Text(
                        'متابعة',
                        style: TextStyle(color: Colors.white),
                      )),
                )
              ],
            ),
            SizedBox(
              height: 80,
            ),
          ],
        ),
      ),
    );
  }
}
