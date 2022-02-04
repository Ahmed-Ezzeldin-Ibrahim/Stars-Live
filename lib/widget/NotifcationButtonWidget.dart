import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';

import '../repository/user_repository.dart';

class NotificationButtonWidget extends StatefulWidget {
  @override
  _NotificationButtonWidgetState createState() => _NotificationButtonWidgetState();
}

class _NotificationButtonWidgetState extends State<NotificationButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () async {
        if (currentUser.value.id != null) {
          Navigator.pushNamed(context, '/notificationWidget');
          // await NotificationsController.getNotifiyCount();
        } else {
          Navigator.of(context).pushReplacementNamed('/loginScreen');
        }
      },
      // child: NotificationsController.notificationscount == 0 || NotificationsController.notificationscount == null?
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: <Widget>[
          Image(
            image: AssetImage('assets/img/notify.png'),
            height: 25,
            width: 25,
          ),
          Container(
            child: Text(
              '0',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.caption.merge(
                    GoogleFonts.tajawal(color: Colors.white, fontSize: 12),
                  ),
            ),
            padding: EdgeInsets.all(0),
            decoration: BoxDecoration(color: Color(0xffa7ddff), borderRadius: BorderRadius.all(Radius.circular(10))),
            constraints: BoxConstraints(minWidth: 15, maxWidth: 15, minHeight: 15, maxHeight: 15),
          ),
        ],
      )
      // :
      // Stack(
      //   alignment: AlignmentDirectional.bottomEnd,
      //   children: <Widget>[
      //     Image(
      //       image: AssetImage('assets/img/notify.png'),
      //       height: 25,
      //       width: 25,
      //     ),
      //     Container(
      //       child: Text(
      //         NotificationsController.notificationscount.toString(),
      //         textAlign: TextAlign.center,
      //         style: Theme.of(context).textTheme.caption.merge(
      //           GoogleFonts.tajawal(color: Colors.white, fontSize: 13),
      //         ),
      //       ),
      //       padding: EdgeInsets.all(0),
      //       decoration:
      //       BoxDecoration(color:  Color(0xffa7ddff), borderRadius: BorderRadius.all(Radius.circular(10))),
      //       constraints: BoxConstraints(minWidth: 15, maxWidth: 15, minHeight: 15, maxHeight: 15),
      //     ),
      //   ],
      // ),
      ,
      color: Colors.transparent,
    );
  }
}
