import 'dart:async';

import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import '../constant/contant.dart';
import '../view/home.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_overlay/loading_overlay.dart';
import '../view/registration.dart';
import 'LoadingScreen.dart';

class ConfirmPasswordWidget extends StatefulWidget {
  String phone;
  String statusCode;
  String verificationId;
  int forceResendingToke;
  bool fromForgetPass;
  ConfirmPasswordWidget({this.forceResendingToke,this.verificationId,this.statusCode,this.phone,this.fromForgetPass = false});
  @override
  _ConfirmPasswordWidgetState createState() => _ConfirmPasswordWidgetState();
}

class _ConfirmPasswordWidgetState extends State<ConfirmPasswordWidget> {
  String get verificationId => widget.verificationId;
  int get forceResendingToke => widget.forceResendingToke;
  TextEditingController _codeController1 = TextEditingController();
  String get phone => widget.phone;
  bool hidePassword = false;
  bool logInStatus = false;
  bool isValidate = false;
  bool loading = false;

  @override
  void dispose() {
    _codeController1.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    // var applocal = AppLocalizations.of(context);
    return WillPopScope(
        child: Scaffold(
          body: LoadingScreen(
            loading: loading,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: h*.1),
                child: Container(
                  height: h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)),
                      color: Colors.white
                  ),
                  width: w,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        localized(context, 'Sign_up'),
                        style: GoogleFonts.cairo(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 34,
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Image(
                        image: AssetImage('assets/img/logo.png'),
                        fit: BoxFit.fill,
                        height: 150,
                        width: 150,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'برجاء كتابة كود التاكيد',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(
                            color: Color(0xff010101),
                            fontSize: 17,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      PinCodeFields(
                        length: 6,
                        fieldBorderStyle: FieldBorderStyle.Square,
                        responsive: false,
                        fieldHeight: 50.0,
                        fieldWidth: w*.1,
                        borderWidth: 1.0,
                        activeBorderColor: Color(0xffB7B7B7),
                        activeBackgroundColor: Colors.white,
                        keyboardType: TextInputType.number,
                        controller: _codeController1,
                        autoHideKeyboard: false,
                        fieldBackgroundColor: Colors.white,
                        borderColor: Color(0xffB7B7B7),
                        textStyle: GoogleFonts.cairo(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                        onComplete: (output) {
                          // Your logic with pin code
                          print(output);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      MaterialButton(
                        onPressed: (){
                          if(phone.isNotEmpty){
                            getUserPhoneVerifications(widget.statusCode + phone);
                          }else{
                            Fluttertoast.showToast(msg: 'يجب التحقق من رقم الجوال بشكل صحيح');
                          }
                        },
                        child: Text('اعد ارسال ركز التاكيد',
                          style: GoogleFonts.cairo(
                              fontSize: 15,
                              decoration: TextDecoration.underline,
                              color: baseColor
                          ),),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      MaterialButton(
                        height: 55,
                        minWidth: 200,
                        color: Color(0xff6C757D),
                        shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Color(0xff6C757D)
                            )
                        ),
                        onPressed: () async{
                          // FirebaseAuth _auth = FirebaseAuth.instance;
                          // if(_codeController1.text.isNotEmpty && _codeController1.text.length == 6){
                          //   final code = _codeController1.text.trim();
                          //   setState(() {
                          //     loading = true;
                          //   });
                          //   var result;
                          //   print(code);
                          //   try{
                          //     AuthCredential credential =
                          //     PhoneAuthProvider.credential(
                          //         verificationId: verificationId,
                          //         smsCode: code
                          //     );

                          //     result = await _auth.signInWithCredential(credential);
                          //   }catch(e){
                          //     print("Error  $e");
                          //     Fluttertoast.showToast(msg: e.toString().split('[firebase_auth/session-expired]').last);
                          //   }
                          //   User user = result.user;
                          //   if(user != null){
                          //     Navigator.push(context,MaterialPageRoute(builder: (context) => RegistrationWidget()));
                          //     Fluttertoast.showToast(msg: 'login Done correctly');
                          //     setState(() {
                          //       loading = false;
                          //     });
                          //   }else{
                          //     setState(() {
                          //       loading = false;
                          //     });
                          //     Fluttertoast.showToast(msg: 'يجب التحق من كتابة الكود بشكل صحيح');
                          //     print("Error");
                          //   }
                          // }else{
                          //   Fluttertoast.showToast(msg: 'يجب ادخال كود التحقق بشكل صحيح');
                          //   setState(() {
                          //     isValidate = true;
                          //   });
                          // }
                        },
                        child: Text('كود التاكيد',style: GoogleFonts.cairo(
                            fontSize: 15,
                            color: Colors.white
                        ),),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                )),
          ),
        ),
        onWillPop: () async => false
    );
  }

  Future<bool> getUserPhoneVerifications(String phone) async{
    // print(phone);
    // FirebaseAuth _auth = FirebaseAuth.instance;
    // _auth.verifyPhoneNumber(
    //   phoneNumber: phone,
    //   timeout: Duration(seconds: 60),
    //   verificationCompleted: (AuthCredential credential) async{
    //     // Navigator.of(context).pushReplacementNamed('/pagesWidget');
    //     print(credential.providerId);
    //     print(credential.signInMethod);
    //     print(credential.token);
    //     setState(() {
    //       loading = false;
    //     });
    //     // await _auth.signInWithCredential(credential);
    //     //This callback would gets called when verification is done auto maticlly
    //   },
    //   verificationFailed: (FirebaseAuthException exception){
    //     setState(() {
    //       loading = false;
    //     });
    //     if(exception.toString().contains('We have blocked all requests')){
    //       Fluttertoast.showToast(msg: 'يجب المحاولة فى وقت لاحق لكثرة المحاولات السابقة');
    //     } if(exception.toString().contains('firebase_auth/invalid-verification-code')){
    //       print('exp ${exception}');
    //       Fluttertoast.showToast(msg: 'الكود الذي ادخلته غير صحيح يرجي التاكد من الكود');
    //     }else if(exception.toString().contains('firebase_auth/session-expired')){
    //       Fluttertoast.showToast(msg: 'الكود الذي ادخلته تم انتهاء مدته');
    //     }else{
    //       Fluttertoast.showToast(msg: 'يجب التاكد من رقم الجوال مع اختيار الكود');
    //     }
    //     print(exception);
    //   },
    //   codeSent: (String verificationId, [int forceResendingToken]){
    //     setState(() {
    //       loading = false;
    //     });
    //   },
    //   codeAutoRetrievalTimeout: (String verificationId) {},
    // );
 
  }
}
