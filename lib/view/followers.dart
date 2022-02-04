import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../constant/contant.dart';
import '../controller/profie_controller.dart';
import '../model/User.dart';
import '../repository/following_repository.dart';

class FollowersWidget extends StatefulWidget {
  List<Follower> following;
  String titleOfPopUp;
  FollowersWidget({this.titleOfPopUp, this.following});
  @override
  _FollowersWidgetState createState() => _FollowersWidgetState();
}

class _FollowersWidgetState extends State<FollowersWidget> {
  List<Follower> get following => widget.following;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return AlertDialog(
        shape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(25)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.titleOfPopUp,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.cairo(color: Colors.black, fontSize: 25, fontWeight: FontWeight.w600),
            ),
            IconButton(icon: Icon(Icons.clear), onPressed: () => Navigator.pop(context))
          ],
        ),
        content: following == null
            ? Container(
                height: h * .5,
                width: w,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Container(
                height: h * .5,
                width: w,
                child: ListView.separated(
                  itemCount: following.length,
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 0,
                    );
                  },
                  itemBuilder: (context, index) {
                    return FollowersListWidget(
                      following: following[index],
                      titleOfPopUp: widget.titleOfPopUp,
                    );
                  },
                ),
              ));
  }
}

class FollowersListWidget extends StatefulWidget {
  Follower following;
  String titleOfPopUp;
  FollowersListWidget({this.following, this.titleOfPopUp});
  @override
  _FollowersListWidgetState createState() => _FollowersListWidgetState();
}

class _FollowersListWidgetState extends State<FollowersListWidget> {
  Follower get following => widget.following;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      child: InkWell(
        onTap: () {
          // if(following.email != currentUser.value.email){
          //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => ShowWriterProfileWidget(comeUserId: following.id,)));
          // }else if(following.email == currentUser.value.email){
          //   Navigator.pushNamed(context,'/pagesWidget',arguments: 4);
          // }
        },
        child: Card(
          shape: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
          elevation: 0,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(
                  image: NetworkImage(following.image),
                  fit: BoxFit.cover,
                  height: 50,
                  width: 50,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      following.name,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.cairo(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    following.type == null
                        ? Text('')
                        : Text(
                            following.type,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: GoogleFonts.cairo(color: Color(0xffC9C9C9), fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                  ],
                ),
              ),
              FlatButton(
                onPressed: () async {
                  if (widget.titleOfPopUp == localized(context, 'following')) {
                    if (following.followed == 'true') {
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
                  } else {
                    if (following.followed == 'true') {
                      await removeFromFollowings(follow_id: following.pivot.followerId);
                      await Provider.of<ProfileController>(context, listen: false).getCurrentUserData(context);
                      setState(() {
                        following.followed = 'false';
                      });
                    } else {
                      await addToFollowings(follow_id: following.pivot.followerId);
                      await Provider.of<ProfileController>(context, listen: false).getCurrentUserData(context);
                      setState(() {
                        following.followed = 'true';
                      });
                    }
                  }
                },
                color: following.followed == "false" ? baseColor : baseColor.withOpacity(.3),
                shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.white)),
                height: 35,
                minWidth: 90,
                child: Text(
                  following.followed == "false" ? localized(context, 'follows') : localized(context, 'followg'),
                  style: GoogleFonts.cairo(color: Colors.white, fontSize: h * .02, fontWeight: FontWeight.w400),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
