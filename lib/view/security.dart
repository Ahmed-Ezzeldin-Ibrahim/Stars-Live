import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constant/contant.dart';
import 'change_password.dart';

class SecurityWidget extends StatefulWidget {
  @override
  _SecurityWidgetState createState() => _SecurityWidgetState();
}

class _SecurityWidgetState extends State<SecurityWidget> {
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
            localized(context, 'settings'),
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              helpRow(
                  title: localized(context, 'change_password'),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChangePassword()))
              )
            ],
          ),
        ),
      ),
    );
  }


  helpRow({String title, Function onTap}){
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: GoogleFonts.cairo(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600
                  ),
                ),
                IconButton(
                    icon: RotatedBox(
                        quarterTurns: 2,
                        child: Icon(Icons.arrow_back_ios,color: Colors.black,)),
                    onPressed: onTap
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
