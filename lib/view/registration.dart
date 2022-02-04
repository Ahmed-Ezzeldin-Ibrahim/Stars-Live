// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constant/contant.dart';
import '../controller/user_controller.dart';
import '../helper/locationHelper.dart';
import '../model/User.dart';
import '../widget/LoadingScreen.dart';
import 'login.dart';

class RegistrationWidget extends StatefulWidget {
  @override
  _RegistrationWidgetState createState() => _RegistrationWidgetState();
}

class _RegistrationWidgetState extends State<RegistrationWidget> {
  UserController userController = UserController();
  GlobalKey<FormState> _loginKey = GlobalKey<FormState>();
  bool isValidate = false;
  bool lockPass = false;
  bool loading = false;
  String dropdownValueGender;
  User user = User();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  // FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  getToken() async {
    // await _firebaseMessaging.getToken().then((String _deviceToken) {
    //   userController.user.deviceToken = _deviceToken;
    //   print('token $_deviceToken');
    // });
    await LocationHelper.getUserCurrentLocation();
  }

  @override
  void initState() {
    if (false && kDebugMode) {
      _phoneController.text = '123123123';
      _nameController.text = 'Developer Test';
      _emailController.text = 'developer@dev.com';
      _passwordController.text = '123123';
      dropdownValueGender = 'ذكر';
    }
    getToken();
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: baseColor,
      body: LoadingScreen(
        loading: loading,
        child: Form(
          key: _loginKey,
          //autovalidate: isValidate,
          child: Stack(
            children: [
              Container(
                height: h,
                width: w,
              ),
              Positioned(
                top: h * .15,
                left: 10,
                right: 10,
                bottom: 20,
                child: Container(
                  width: w * .9,
                  height: h - h * .15,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.08), blurRadius: 7, spreadRadius: 7)]),
                  padding: EdgeInsets.all(15),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                          height: 8,
                        ),
                        Text(
                          localized(context, 'name'),
                          style: GoogleFonts.cairo(
                            color: Color(0xff9B9B9B),
                            fontSize: 15,
                          ),
                        ),
                        TextFormField(
                            controller: _nameController,
                            validator: (input) {
                              if (input.isEmpty) {
                                return 'الاسم مطلوب';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(12),
                                // prefixIcon: Icon(Icons.mail_outline),
                                filled: true,
                                fillColor: Color(0xffF5F5F5),
                                border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(45)),
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(45)),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(45)))),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          localized(context, 'Email'),
                          style: GoogleFonts.cairo(
                            color: Color(0xff9B9B9B),
                            fontSize: 15,
                          ),
                        ),
                        TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (input) {
                              if (input.isEmpty) {
                                return 'البريد الإلكتروني مطلوب';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(12),
                                // prefixIcon: Icon(Icons.mail_outline),
                                filled: true,
                                fillColor: Color(0xffF5F5F5),
                                border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(45)),
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(45)),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(45)))),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          localized(context, 'phone'),
                          style: GoogleFonts.cairo(
                            color: Color(0xff9B9B9B),
                            fontSize: 15,
                          ),
                        ),
                        TextFormField(
                            controller: _phoneController,
                            readOnly: false,
                            keyboardType: TextInputType.phone,
                            validator: (input) {
                              if (input.isEmpty) {
                                return 'رقم الهاتف مطلوب';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(12),
                                // prefixIcon: Icon(Icons.mail_outline),
                                filled: true,
                                fillColor: Color(0xffF5F5F5),
                                border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(45)),
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(45)),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(45)))),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          localized(context, 'Password'),
                          style: GoogleFonts.cairo(
                            color: Color(0xff9B9B9B),
                            fontSize: 15,
                          ),
                        ),
                        TextFormField(
                            controller: _passwordController,
                            obscureText: lockPass ? false : true,
                            keyboardType: TextInputType.visiblePassword,
                            validator: (input) {
                              if (input.isEmpty) {
                                return 'كلمة السر مطلوبة';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(12),
                                // prefixIcon: Icon(Icons.lock_outline),
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        lockPass = !lockPass;
                                      });
                                    },
                                    child: !lockPass ? Icon(Icons.visibility_off) : Icon(Icons.visibility)),
                                filled: true,
                                fillColor: Color(0xffF5F5F5),
                                border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(45)),
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(45)),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(45)))),
                        SizedBox(height: 8),
                        Text(
                          localized(context, 'gender'),
                          style: GoogleFonts.cairo(
                            color: Color(0xff9B9B9B),
                            fontSize: 15,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xffF5F5F5),
                            borderRadius: BorderRadius.circular(45.0),
                            border: Border.all(color: Colors.white),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: DropdownButton<String>(
                              value: dropdownValueGender,
                              iconSize: 24,
                              elevation: 16,
                              isExpanded: true,
                              hint: Text(''),
                              underline: DropdownButtonHideUnderline(child: Container()),
                              style: GoogleFonts.tajawal(color: Colors.white),
                              onChanged: (String newValue) {
                                setState(() {
                                  dropdownValueGender = newValue;
                                  print(newValue);
                                  print(dropdownValueGender);
                                });
                              },
                              items: <String>[localized(context, 'male'), localized(context, 'female')].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: GoogleFonts.tajawal(color: Colors.black),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Center(
                          child: MaterialButton(
                            onPressed: () {
                              signUpBTN(context);
                            },
                            color: baseColor,
                            elevation: 0,
                            height: 55,
                            minWidth: 276,
                            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(45), borderSide: BorderSide.none),
                            child: Text(
                              localized(context, 'Sign_up'),
                              style: GoogleFonts.cairo(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        InkWell(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LogIn())),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                localized(context, 'Do_have_an_account'),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.cairo(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff9B9B9B),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                localized(context, 'Sign_in'),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.cairo(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  signUpBTN(BuildContext context) async {
    if (_loginKey.currentState.validate()) {
      setState(() {
        loading = true;
      });
      userController.user.email = _emailController.text;
      userController.user.name = _nameController.text;
      userController.user.phone = _phoneController.text;
      userController.user.gender = dropdownValueGender;
      userController.user.longitude = LocationHelper.long;
      userController.user.latitude = LocationHelper.lat;
      userController.user.country = LocationHelper.locationAddress;
      userController.user.password = _passwordController.text;
      if (dropdownValueGender == null) {
        Fluttertoast.showToast(msg: 'Select your gender');
        return;
      }

      try {
        await userController.userRegister(this.userController, context);
      } catch (e) {
        setState(() {
          loading = false;
        });
      }
    } else {
      setState(() {
        isValidate = true;
      });
    }
    setState(() {
      loading = false;
    });
  }
}
