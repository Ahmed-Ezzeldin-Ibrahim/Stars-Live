import 'package:flutter/material.dart';

class LiveText extends StatelessWidget {
  final int userNo;

  LiveText({this.userNo = 0});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Colors.indigo, Colors.blue
                    ],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(4.0))
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 8.0),
                child: Text('LIVE',style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:5,right:10),
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.6),
                      borderRadius: BorderRadius.all(Radius.circular(4.0))
                  ),
                  height: 28,
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.remove_red_eye_rounded,color: Colors.white,size: 13,),
                        SizedBox(width: 5,),
                        Text('$userNo',style: TextStyle(color: Colors.white,fontSize: 11),),
                      ],
                    ),
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
