import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';

import '../constant/contant.dart';
import '../model/top_users.dart';
import '../widget/level_color.dart';

class UserProfile extends StatefulWidget {
  final User user;
  UserProfile({this.user});
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Builder(builder: (context) {
          return Conditional.single(
            context: context,
            conditionBuilder: (context) => widget.user != null,
            fallbackBuilder: (context) => Center(child: CircularProgressIndicator()),
            widgetBuilder: (context) => SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                          width: double.infinity,
                          height: 300,
                          child: Image.network(
                            widget.user.image,
                            fit: BoxFit.cover,
                          )),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.user.name,
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'ID : ${widget.user.id}',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(width: 120, height: 50, child: LevelColors(level: widget.user.levelUser.level)),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20)),
                              width: 120,
                              height: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${widget.user.levelHost.level}',
                                    style: TextStyle(fontSize: 20),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 200,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(color: Colors.greenAccent, borderRadius: BorderRadius.circular(30)),
                              child: FlatButton.icon(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.chat_rounded,
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
                              decoration: BoxDecoration(color: baseColor, borderRadius: BorderRadius.circular(30)),
                              child: FlatButton.icon(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  'متابعة',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
