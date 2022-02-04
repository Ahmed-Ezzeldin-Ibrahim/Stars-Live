import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constant/contant.dart';
import '../controller/profie_controller.dart';
import '../model/top_users.dart';
import '../repository/following_repository.dart';

class FollowButton extends StatefulWidget {
  Follower following;
  FollowButton({this.following});

  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  Follower get following => widget.following;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Container(
      height: 40,
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: FlatButton(
        onPressed: () async {
          if (following.followed == 'true' && following != null && following.followed.isNotEmpty) {
            await removeFromFollowings(follow_id: following.pivot.followedId);
            await Provider.of<ProfileController>(context, listen: false).getCurrentUserData(context);
            setState(() {
              following.followed = 'false';
            });
          } else {
            await addToFollowings(follow_id: following.pivot.followedId);
            await Provider.of<ProfileController>(context, listen: false).getCurrentUserData(context);
            setState(() {
              following.followed = 'true';
            });
          }
          /* if (following.followed == 'true') {
            await removeFromFollowings(follow_id: following.pivot.followerId);
            await Provider.of<ProfileController>(context, listen: false)
                .getCurrentUserData(context);
            setState(() {
              following.followed = 'false';
            });
          } else {
            await addToFollowings(follow_id: following.pivot.followerId);
            await Provider.of<ProfileController>(context, listen: false)
                .getCurrentUserData(context);
            setState(() {
              following.followed = 'true';
            });
          }*/
        },
        color: following.followed == "false" && following != null && following.followed.isNotEmpty ? baseColor : baseColor.withOpacity(0.3),
        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.white)),
        child: Icon(
          following.followed == "false" && following != null && following.followed.isNotEmpty ? Icons.add : Icons.remove,
        ),
        /*Text(
          following.followed == "false"
              ? localized(context, 'follows')
              : localized(context, 'followg'),
          style: GoogleFonts.cairo(
              color: Colors.white,
              fontSize: h * .02,
              fontWeight: FontWeight.w400),
        ),*/
      ),
    );
  }
}
