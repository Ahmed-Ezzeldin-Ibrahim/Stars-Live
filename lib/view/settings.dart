
import '../constant/contant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'blocked.dart';
import 'security.dart';

class SettingsWidget extends StatefulWidget {
  final languageProvider;
  SettingsWidget({this.languageProvider});
  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  bool selcetNotify = false;
  bool selcetFollowServce = false;
  bool selcetSaveReport = false;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    // var applocal = AppLocalizations.of(context);
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
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SecurityWidget())),
                  title: localized(context, 'secuirty')
              ),
              helpRow(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => BlockedWidget())),
                title: localized(context, 'blocked')
              ),
              helpRow(
                onTap: changeLanguage,
                title: localized(context, 'language')
              ),
            ],
          ),
        ),
      ),
    );
  }

  changeLanguage() {
    showDialog(
        context: context,
        builder: (BuildContext con){
          return Dialog(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              height: 220,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      localized(context, 'language'),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.cairo(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: (){
                      widget.languageProvider.changeLanguage(Locale("ar"));
                      Navigator.of(con).pop();
                    },
                    child: Text(
                      'اللغة العربية',
                      style: GoogleFonts.cairo(
                          color: Color(0xffFFC32C),
                          fontSize: 18,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: (){
                      widget.languageProvider.changeLanguage(Locale("en"));
                      Navigator.of(con).pop();
                    },
                    child: Text(
                      'English',
                      style: GoogleFonts.cairo(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                  ),
                ],
              ),
            ),
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none,
            ),
          );
        }
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
