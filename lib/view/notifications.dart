import 'package:flutter_svg/svg.dart';
import '../constant/contant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../helper/MyPopupMenuItem.dart';
import 'comments.dart';

class NotificationsWidget extends StatefulWidget {
  int currentIndex;
  NotificationsWidget({this.currentIndex = 1});
  @override
  _NotificationsWidgetState createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends State<NotificationsWidget> with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2, initialIndex: widget.currentIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: baseColor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 0,
          title: Text(''),
          leading: InkWell(
            onTap: (){},
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SvgPicture.asset('assets/img/search.svg',height: 15,width: 15,),
            ),
          ),
          actions: [
            InkWell(
              onTap: (){},
              child: Image.asset('assets/img/add.png',height: 30,width: 30,color: Color(0xffFFFF4A),),
            ),
            SizedBox(
              width: 10,
            )
          ],
          bottom: TabBar(
            indicatorColor: Color(0xffFFFF4A),
            labelPadding: EdgeInsets.symmetric(vertical: 10),
            controller: _tabController,
            tabs: [
              Text(localized(context, 'Followers'),style: TextStyle(fontSize: 17,color: Colors.white),),
              Text(localized(context, 'Commen'),style: TextStyle(fontSize: 17,color: Colors.white),),
            ],
          ),
        ),
        body:  TabBarView(
          controller: _tabController,
          children: [
            _buildWidgetView(
                ind: 5
            ),
            _buildWidgetView(
                ind: 10
            ),
          ],
        ),
      ),
    );
  }

  _buildWidgetView({int ind}) {
    return ListView.builder(
      itemCount: ind,
      itemBuilder: (context,index){
        return _postWidget();
      },
    );
  }

  _postWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/img/person.png'),
                    fit: BoxFit.cover
                  )
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nice Work',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 18,color: Colors.black,
                          fontWeight: FontWeight.w600),),
                      Container(
                          width: 60,
                          height: 25,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xffFF8960),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.star_border,size: 15,color: Colors.white,),
                              SizedBox(width: 5,),
                              Text('15',style: TextStyle(fontSize: 10,color: Colors.white),),
                            ],
                          )
                      ),
                    ],
                  )
              ),
              MaterialButton(
                onPressed: _fillowFunc,
                color: Color(0xffDAD9E2),
                height: 25,
                minWidth: 65,
                child: Text(localized(context, 'follow'),style: TextStyle(
                  fontSize: 14,
                  color: Colors.black
                ),),
              ),
              SizedBox(
                width: 5,
              ),
              GestureDetector(
                onTapUp: (details)async{
                  double dx = details.globalPosition.dx;
                  double dy = details.globalPosition.dy;
                  double dx2 = MediaQuery.of(context).size.width - dx;
                  double dy2 = MediaQuery.of(context).size.width - dy;
                  _popUpFunc(
                    dx2: dx2,
                    dx: dx,
                    dy2: dy2,
                    dy: dy
                  );
                },
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Icon(
                    Icons.more_horiz_sharp,
                    size: 30,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            '‏مجهول يضع هذه الورقة المؤثرة أمام أحد الأندية الرياضية في الكويت غيره وحرصا على شباب المسلمين !!',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 17,
              color: Colors.black
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ClipRRect(
              child: Image.asset('assets/img/person.png',),
            borderRadius: BorderRadius.circular(10),
          ),
          SizedBox(
            height: 20,
          ),
          _actionWidget()
        ],
      ),
    );
  }

  _actionWidget(){
    return Row(
      children: [
        SizedBox(
          width: 10,
        ),
        InkWell(
          onTap: (){},
          child: Image.asset('assets/img/like.png',height: 25,width: 25,),
        ),
        SizedBox(
          width: 10,
        ),
        Text('22', style: TextStyle(
            fontSize: 17
        ),),
        SizedBox(
          width: 30,
        ),
        InkWell(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CommentsWidget()));
          },
          child: Image.asset('assets/img/comment.png',height: 25,width: 25,),
        ),
        SizedBox(
          width: 10,
        ),
        Text('22', style: TextStyle(
            fontSize: 17
        ),),
        SizedBox(
          width: 30,
        ),
      ],
    );
  }

  void _popUpFunc({dx, dy, dx2, dy2}) {
    showMenu(
        context: context,
        shape: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(20)
        ),
        position: RelativeRect.fromLTRB(dx, dy, dx2, dy2),
        items: [
          MyPopupMenuItem(
            onClick: () async{},
            child: Text(
              localized(context, 'share_post'),
              style: GoogleFonts.cairo(
                  color: baseColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w400),
            ),
          ),
          MyPopupMenuItem(
            onClick: () async{},
            child: Text(
              localized(context, 'tell_problem_post'),
              style: GoogleFonts.cairo(
                  color: baseColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w400),
            ),
          ),
          MyPopupMenuItem(
            onClick: () async{},
            child: Text(
              localized(context, 'edit_post'),
              style: GoogleFonts.cairo(
                  color: baseColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w400),
            ),
          ),
          MyPopupMenuItem(
            onClick: () async{},
            child: Text(
              localized(context, 'delete_post'),
              style: GoogleFonts.cairo(
                  color: baseColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ]);
  }

  void _fillowFunc() {

  }
}

class NotificationTemplete extends StatefulWidget {
  String Image;
  String title;
  String date;
  Function onTap;
  NotificationTemplete({this.title,this.Image,this.onTap,this.date});
  @override
  _NotificationTempleteState createState() => _NotificationTempleteState();
}

class _NotificationTempleteState extends State<NotificationTemplete> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        elevation: 0,
        shape: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: widget.onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xffCBCBCB),
                            ),
                            height: 60,
                            width: 60,
                          ),
                          Positioned(
                            top: 10,
                            left: 10,
                            right: 10,
                            bottom: 10,
                            child: Image(
                              image: AssetImage(widget.Image),
                              height: 30,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          widget.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: GoogleFonts.cairo(
                              color: Color(0xff160F0F),
                              fontSize: 18,
                              fontWeight: FontWeight.w400
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10,),
                Text(
                  widget.date,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: GoogleFonts.cairo(
                      color: Color(0xffC7C7C7),
                      fontSize: 18,
                      fontWeight: FontWeight.w400
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

