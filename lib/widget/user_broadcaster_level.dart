import 'package:flutter/material.dart';

import '../constant/contant.dart';
import '../repository/user_repository.dart';

class UserBroadcasterLevel extends StatefulWidget {
  @override
  State<UserBroadcasterLevel> createState() => _UserBroadcasterLevelState();
}

class _UserBroadcasterLevelState extends State<UserBroadcasterLevel> {
  int height = 150;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: w,
        height: h,
        child: Stack(
          //alignment: Alignment.center,
          children: [
            Container(
              height: h * 1.2,
              width: w,
            ),
            Container(
              height: 250,
              width: w,
              decoration: BoxDecoration(color: baseColor, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60), bottomRight: Radius.circular(60))),
            ),
            Positioned(
              top: 100,
              left: 20,
              right: 20,
              child: Container(
                height: 250,
                width: w - 40,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    SizedBox(
                      height: 60,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${currentUser.value.userHostLevel.level}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '# ${currentUser.value.id}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 17, color: Color(0xffC1C0C9), fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(".LV ${currentUser.value.userHostLevel.level}"),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                              inactiveTrackColor: Colors.black, activeTrackColor: Colors.tealAccent, thumbColor: Colors.transparent, thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0.0)),
                          child: Slider(
                            value: currentUser.value.userHostLevel.value + currentUser.value.userHostLevel.previous + 0.0,
                            min: currentUser.value.userHostLevel.previous + 0.0,
                            max: currentUser.value.userHostLevel.next + 0.0,
                            onChanged: (double newValue) {
                              setState(() {
                                height = newValue.round();
                              });
                            },
                          ),
                        ),
                        Text(".Lv ${currentUser.value.userHostLevel.level + 1}"),
                      ],
                    ),
                    Text("My XP :${currentUser.value.userHostLevel.current}"),
                    Text("To Next Level :${currentUser.value.userHostLevel.next}"),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 40,
              left: 20,
              right: 20,
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    color: Colors.black,
                    shape: BoxShape.circle,
                    image: DecorationImage(image: currentUser.value.image == null ? AssetImage('assets/img/person.png') : NetworkImage(currentUser.value.image), fit: BoxFit.contain)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
