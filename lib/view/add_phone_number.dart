import 'package:country_code_picker/country_code_picker.dart';
import '../constant/contant.dart';
import '../widget/ConfirmPasswordWidget.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_overlay/loading_overlay.dart';
import '../widget/LoadingScreen.dart';

class AddPhoneNumberWidget extends StatefulWidget {
  @override
  _AddPhoneNumberWidgetState createState() => _AddPhoneNumberWidgetState();
}

class _AddPhoneNumberWidgetState extends State<AddPhoneNumberWidget> {
  String selectedValue = '+20';
  bool loading = false;
  TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    // var applocal = AppLocalizations.of(context);
    return Scaffold(
      body: LoadingScreen(
        loading: loading,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              child: Container(
                height: h*.6,
                width: w,
              ),
            ),
            Positioned(
              top: 140,
              left: 20,
              right: 20,
              child: SingleChildScrollView(
                child: Container(
                  height: h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)),
                      color: Colors.white
                  ),
                  width: w,
                  child: Column(
                    children: [
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
                      Container(
                        width: w,
                        child: Text(
                          localized(context, 'phone'),
                          textAlign: TextAlign.start,
                          style: GoogleFonts.cairo(
                            color: Color(0xff9B9B9B),
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          validator: (input){
                            if(input.isEmpty){
                              return 'should fill phone';
                            }else{
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(12),
                              // prefixIcon: Icon(Icons.mail_outline),]
                              prefixIcon: CountryCodePicker(
                                builder: (countryCode){
                                  return Container(
                                    width: 70,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(countryCode.dialCode.replaceAll("+", "")+"+"),
                                        Image.asset(countryCode.flagUri,
                                          package: 'country_code_picker',
                                          width: 27,)
                                      ],
                                    ),
                                  );
                                },
                                onChanged: (CountryCode countryCode) {
                                  //Todo : manipulate the selected country code here
                                  print("New Country selected: " + countryCode.toString());
                                  setState(() {selectedValue = countryCode.toString();});
                                },
                                initialSelection: '+20',
                                favorite: ['+966','+20'],
                                showCountryOnly: false,
                                showOnlyCountryWhenClosed: false,
                                alignLeft: false,
                              ),
                              filled: true,
                              fillColor: Color(0xffF5F5F5),
                              border: OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.circular(45)),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.circular(45)),
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.circular(45))
                          )
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      MaterialButton(
                        height: 50,
                        minWidth: 200,
                        color: baseColor,
                        shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none
                        ),
                        onPressed: (){
                          setState(() {
                            loading = true;
                          });
                          if(_phoneController.text.isEmpty || _phoneController.text.length<0){
                            setState(() {
                              loading = false;
                            });
                            Fluttertoast.showToast(msg: 'يجب ادخال رقم الجوال');
                          }else{
                            getUserPhoneVerifications('$selectedValue${_phoneController.text}').then((value){
                              //Navigator.pushReplacementNamed(context, '/Pages',arguments: 2);
                            });
                          }
                        },
                        child: Text('تاكيد رقم الهاتف',style: GoogleFonts.cairo(
                            fontSize: 15,
                            color: Colors.white
                        ),),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> getUserPhoneVerifications(String phone) async{
    print(phone);
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
    //     Navigator.push(context, MaterialPageRoute(builder: (context){
    //       return ConfirmPasswordWidget(forceResendingToke: forceResendingToken,verificationId: verificationId,statusCode: selectedValue,phone: _phoneController.text,);
    //     }));
    //   },
    //   codeAutoRetrievalTimeout: (String verificationId) {},
    // );
  }

}
