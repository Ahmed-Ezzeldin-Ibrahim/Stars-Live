import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:starslive/helper/echo.dart';
import 'package:starslive/view/registration.dart';

import '../constant/contant.dart';
import '../controller/profie_controller.dart';
import '../controller/user_controller.dart';
import '../widget/LoadingScreen.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  GlobalKey<FormState> _loginKey = GlobalKey<FormState>();
  UserController userController = UserController();
  String selectedValue;
  bool isDocumenter = false;
  bool logInStatus = false;
  bool isValidate = false;
  bool loading = false;
  bool lockPass = false;
  bool lockPassPop = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordPopController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  // FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  getToken() async {
    // await _firebaseMessaging.getToken().then((String _deviceToken) {
    //   //user.deviceToken = _deviceToken;
    //   print('token $_deviceToken');
    // });
  }

  @override
  void initState() {
    if (false && kDebugMode) {
      _emailController.text = 'developer2@developer.com';
      _passwordController.text = '123123';
    }
    getToken();
    //googleSignIn.signOut();
    googleSignIn.onCurrentUserChanged.listen((googleSignInAccount) {
      //controlSignIn(googleSignInAccount);
    }, onError: (googleError) {
      print('Error message:' + googleError);
    });
    googleSignIn.signInSilently(suppressErrors: false).then((googleSignInAccount) {
      //controlSignIn(googleSignInAccount);
    }).catchError((googleError) {
      print('Error message:' + googleError.toString());
    });
    // FacebookAuth.instance.logOut();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordPopController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return LoadingScreen(
      loading: loading,
      child: Scaffold(
        backgroundColor: baseColor,
        body: Form(
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
                child: Container(
                  width: w * .9,
                  height: 474,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.08), blurRadius: 7, spreadRadius: 7)]),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localized(context, 'Sign_in'),
                          style: GoogleFonts.cairo(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 34,
                          ),
                        ),
                        SizedBox(
                          height: 25,
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
                                return 'should fill email';
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
                          height: 25,
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
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: lockPass ? false : true,
                            validator: (input) {
                              if (input.isEmpty) {
                                return 'should fill password';
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
                        SizedBox(height: 40),
                        Center(
                          child: MaterialButton(
                            onPressed: () {
                              loginBtn(context);
                            },
                            color: baseColor,
                            elevation: 0,
                            height: 55,
                            minWidth: 276,
                            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(45), borderSide: BorderSide.none),
                            child: Text(
                              localized(context, 'Sign_in'),
                              style: GoogleFonts.cairo(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: InkWell(
                            onTap: () {},
                            child: Text(
                              localized(context, 'Forgot_your_password'),
                              style: GoogleFonts.cairo(
                                color: Color(0xff262628),
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Center(
                          child: InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegistrationWidget(),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  localized(context, 'Dont_have_an_account'),
                                  style: GoogleFonts.cairo(
                                    color: Color(0xff262628),
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  localized(context, 'Sign_up'),
                                  style: GoogleFonts.cairo(
                                    color: Color(0xFF1A71D4),
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                  top: 574 + h * .15,
                  right: 30,
                  left: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      socialLogin(color: Color(0xffFC3850), onTap: logInUserUsingGoogle, img: 'assets/img/google.png'),
                      // SizedBox(
                      //   width: 20,
                      // ),
                      // socialLogin(
                      //     onTap: () {
                      //       Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (context) => AddPhoneNumberWidget(),
                      //         ),
                      //       );
                      //     },
                      //     color: Color(0xff4FC4FF),
                      //     img: 'assets/img/iphone_log.png'),
                      // SizedBox(
                      //   width: 20,
                      // ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void showSuccessMessage(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Sign In Succes",
              textAlign: TextAlign.center,
            ),
            content: Text(message),
            actions: [
              FlatButton(
                child: Text("Go to Home"),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/Pages', arguments: 2);
                },
              )
            ],
          );
        });
  }

  void showErrorMessage(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Sign In Error",
              textAlign: TextAlign.center,
            ),
            content: Text(message),
            actions: [
              FlatButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  saveUserInformationToAPI(String name, String email, String id, BuildContext context) async {
    setState(() {
      loading = true;
    });
    userController.user.email = email;
    userController.user.google_id = id;
    print('${userController.user.google_id} ******');
    userController.user.phone = _phoneController.text;
    userController.user.name = name;
    // userController.user.phone = _passwordPopController.text;
    userController.googleFaceBookRegister(context).catchError((e) {
      setState(() {
        loading = false;
      });
    });
  }

  socialLogin({Color color, String img, Function onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        child: Center(
          child: Image.asset(
            img,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  void loginBtn(BuildContext context) async {
    if (_loginKey.currentState.validate()) {
      setState(() {
        loading = true;
      });
      print('login btn 1');

      userController.user.email = _emailController.text;
      userController.user.password = _passwordController.text;
      // Fluttertoast.showToast(msg: _passwordController.text);
      print('login btn 2');
      final prefs = GetStorage();
      prefs.write('email', '${_emailController.text}');
      prefs.write('password', '${_passwordController.text}');
      print('login btn 3');
      userController.login(context).whenComplete(() async {
        await Provider.of<ProfileController>(context, listen: false).getCurrentUserData(context);
        setState(() => loading = false);
      }).catchError((error) {
        print('error $error');
        setState(() => loading = false);
      });
    } else {
      setState(() {
        isValidate = true;
      });
    }
  }

  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> _login() async {
    //final LoginResult result = await FacebookAuth.instance.login(); // by default we request the email and the public profile

    // AccessToken result = await FacebookAuth.instance.login();

    // if (result.userId != null) {
    //   saveUserFacebookInformationToAPI();
    // } else {
    // }
  }

  logInUserUsingFaceBook() {
    showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (context) {
          return Dialog(
            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
            child: Container(
              height: 250,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
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
                      keyboardType: TextInputType.phone,
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'should fill phone number';
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
                  SizedBox(height: 30),
                  Center(
                    child: MaterialButton(
                        color: baseColor,
                        minWidth: 150,
                        height: 45,
                        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                        child: Text(
                          localized(context, 'Sign_in'),
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        onPressed: () {
                          if (_phoneController.text.isEmpty) {
                            Fluttertoast.showToast(msg: 'Phone Number is Required');
                            return;
                          }
                          Navigator.pop(context);
                          _login().then((value) {});
                        }),
                  )
                ],
              ),
            ),
          );
        });
  }

  logInUserUsingGoogle() async {
    Echo('logInUserUsingGoogle');
    loading = true;
    setState(() {});
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    Echo('GoogleSignInAccount');
    try {
      final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        await saveUserInformationToAPI(googleSignInAccount.displayName, googleSignInAccount.email, googleSignInAccount.id, context);
      } else {
        Echo('GoogleSignInAccount null');
      }
    } on FirebaseAuthException catch (e) {
      showErrorMessage(e.message);
      Echo('logInUserUsingGoogle error $e');
      print('5555');
    }
    loading = false;
    setState(() {});
    Echo('logInUserUsingGoogle end');
  }

  /*saveUserInformationToAPI() async {
    final GoogleSignInAccount googleCurrentUser = googleSignIn.currentUser;
    setState(() {
      loading = true;
    });
    print(googleCurrentUser.email);
    userController.user.email = googleCurrentUser.email;
    userController.user.google_id = googleCurrentUser.id;
    //userController.user.phone = _phoneController.text;
    userController.user.name = googleCurrentUser.displayName;
    userController.user.deviceToken = user.deviceToken;
    userController.googleFaceBookRegister().catchError((e) {
      setState(() {
        loading = false;
      });
    }).whenComplete(() async {
      await Provider.of<ProfileController>(context, listen: false)
          .getCurrentUserData(context);

      setState(() {
        loading = false;
      });
    });
  }*/

  saveUserFacebookInformationToAPI() async {
    // final userData = await FacebookAuth.instance.getUserData();
    // setState(() {
    //   loading = true;
    // });
    // print("USER ID IS");
    // print(userData["id"]);
    // userController.user.email = userData["email"];
    // userController.user.google_id = userData["id"];
    // userController.user.phone = _phoneController.text;
    // userController.user.name = userData["name"];
    // // userController.user.phone = _passwordPopController.text;
    // userController.googleFaceBookRegister().catchError((e) {
    //   setState(() {
    //     loading = false;
    //   });
    // }).whenComplete(() async {
    //   await Provider.of<ProfileController>(context, listen: false)
    //       .getCurrentUserData(context);
    //   setState(() {
    //     loading = false;
    //   });
    // });
  }

  /*controlSignIn(GoogleSignInAccount googleSignInAccount) async {
    if (googleSignInAccount != null) {
      saveUserInformationToAPI();
    } else {
      setState(() {
        loading = false;
      });
    }
  }*/

  /*controlFacebookSignIn(GoogleSignInAccount googleSignInAccount) async {
    if (googleSignInAccount != null) {
      saveUserInformationToAPI();
    } else {
      setState(() {
        loading = false;
      });
    }
  }*/
}
