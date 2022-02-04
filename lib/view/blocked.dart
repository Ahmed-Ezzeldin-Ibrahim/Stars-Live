import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constant/contant.dart';

class BlockedWidget extends StatefulWidget {
  @override
  _BlockedWidgetState createState() => _BlockedWidgetState();
}

class _BlockedWidgetState extends State<BlockedWidget> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(h*.08),
        child: AppBar(
          backgroundColor: baseColor,
          leading: IconButton(icon: Icon(Icons.arrow_back_ios,size: 30,color: Colors.white,), onPressed: () => Navigator.pop(context)),
          centerTitle: true,
          elevation: 0,
          title: Text(
            localized(context, 'blocked'),
            style: GoogleFonts.cairo(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600
            ),
          ),
        ),
      ),
      body: Container(
        height: h,
        width: w,
        child: ListView.builder(
          itemCount: 5,
            itemBuilder: (context, index){
              return helpRow(
                title: 'Mahmoud Rabie',
                img: 'assets/img/person.png',
                onTap: (){},
              );
            }
        ),
      ),
    );
  }

  helpRow({String title, String img, Function onTap}){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 10),
      child: InkWell(
        onTap: onTap,
        child: Card(
          elevation: 0,
          shape: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.white
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(90),
                  child: Image.asset(img,height: 50,width: 50,),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  title,
                  style: GoogleFonts.cairo(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.w600
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
