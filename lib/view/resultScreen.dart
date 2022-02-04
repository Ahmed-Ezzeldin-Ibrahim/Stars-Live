import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../repository/user_repository.dart';

class ResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
            ),
            Text(
              'تم انتهاء البث المباشر',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 32),
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '00:01:07',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.access_time_outlined,
                  color: Colors.white,
                  size: 18,
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Image.network(
                currentUser.value.image,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /*SizedBox(
                  width: 55,
                  child: Column(
                    children: [
                      Text(
                        '0',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        ),
                      ),
                      const SizedBox(height: 5,),
                      Text(
                        'إعجابات',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14
                        ),
                      ),
                    ],
                  ),
                ),*/
                SizedBox(
                  width: 55,
                  child: Column(
                    children: [
                      Text(
                        "${currentUser.value.diamonds}",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'ألماس',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Column(
                    children: [
                      Text(
                        currentUser.value.followers == null ? "" : '${currentUser.value.followers.length}',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'متابعون جدد',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 55,
                  child: Column(
                    children: [
                      Text(
                        '0',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'جمهور',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: FlatButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'الصفحة الرئيسية',
                      style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w800),
                    )),
              ),
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
