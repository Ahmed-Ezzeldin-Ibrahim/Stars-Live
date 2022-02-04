import '../constant/contant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgetPassWordWidget extends StatefulWidget {
  @override
  _ForgetPassWordWidgetState createState() => _ForgetPassWordWidgetState();
}

class _ForgetPassWordWidgetState extends State<ForgetPassWordWidget> {
  bool loading = false;
  TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    // var applocal = AppLocalizations.of(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: h,
            width: w,
          ),
          Container(
            height: h*.3,
            width: w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(180),
                    bottomRight: Radius.circular(180)
                ),
                image: DecorationImage(
                  image: AssetImage('assets/img/splash-screen.png'),
                  fit: BoxFit.cover,
                )
            ),
          ),
          Positioned(
              top: 20,
              child: Container(
                width: w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        icon: Icon(Icons.arrow_back,size: 30,color: Colors.white,),
                        onPressed: () => Navigator.pop(context)
                    ),
                    IconButton(
                        icon: Icon(Icons.list,size: 30,color: Colors.white,),
                        onPressed: (){}
                    ),
                  ],
                ),
              )
          ),
          Positioned(
            top: h*.35,
            left: 20,
            right: 20,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "البريد الالكترونى",
                    style: GoogleFonts.cairo(
                      color: Color.fromRGBO(191, 191, 191, 1),
                      fontSize: 15,
                    ),
                  ),
                  TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(12),
                          prefixIcon: Icon(Icons.mail_outline),
                          border: OutlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(191, 191, 191, 1)),borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(191, 191, 191, 1)),borderRadius: BorderRadius.circular(10)),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(191, 191, 191, 1)),borderRadius: BorderRadius.circular(10))
                      )
                  ),
                  SizedBox(height: 30),
                  MaterialButton(
                    onPressed: (){},
                    color: outLineColor,
                    elevation: 0,
                    height: 55,
                    minWidth: w,
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none
                    ),
                    child: Text(
                      'استعادة كلمة المرور',
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
