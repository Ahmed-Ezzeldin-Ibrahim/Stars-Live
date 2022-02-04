import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../constant/contant.dart';
import '../model/User.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  GlobalKey<FormState> _chaangePassKey = GlobalKey<FormState>();
  bool isValidate = false;
  bool hidePassword = false;
  bool hidePassword1 = false;
  bool hidePassword2 = false;
  User user = User();
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _oldPasswordController.dispose();
    super.dispose();
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(h * .08),
        child: AppBar(
          backgroundColor: baseColor,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context)),
          centerTitle: true,
          elevation: 0,
          title: Text(
            localized(context, 'change_password'),
            style: GoogleFonts.cairo(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      body: LoadingOverlay(
        isLoading: loading,
        progressIndicator: AlertDialog(
          backgroundColor: backColor,
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: baseColor,
              )),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(
                height: 20,
              ),
              Text(localized(context, 'loading_for_change_password')),
            ],
          ),
        ),
        child: Container(
          height: h,
          width: w,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: h * .03),
          child: Form(
            key: _chaangePassKey,
            child: ListView(
              children: [
                TextFormField(
                  keyboardType: TextInputType.text,
                  validator: (input) => input.length < 3 ? localized(context, 'should_be_more_than_3_letters') : null,
                  controller: _oldPasswordController,
                  obscureText: !hidePassword,
                  decoration: InputDecoration(
                      errorStyle: GoogleFonts.cairo(color: Colors.grey),
                      contentPadding: EdgeInsets.all(12),
                      hintText: '${localized(context, 'write_old_password')}',
                      hintStyle: GoogleFonts.cairo(color: Color(0xffB7B7B7), fontSize: h * 0.017),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                        color: Theme.of(context).focusColor,
                        icon: Icon(
                          hidePassword ? Icons.visibility : Icons.visibility_off,
                          color: Color(0xffB7B7B7),
                        ),
                      ),
                      filled: true,
                      fillColor: Color(0xffF5F5F5),
                      border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(45)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(45)),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(45))),
                ),
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.text,
                  validator: (input) => input.length < 3 ? localized(context, 'should_be_more_than_3_letters') : null,
                  controller: _passwordController,
                  obscureText: !hidePassword1,
                  decoration: InputDecoration(
                      errorStyle: GoogleFonts.cairo(color: Colors.grey),
                      contentPadding: EdgeInsets.all(12),
                      hintText: '${localized(context, 'write_new_password')}',
                      hintStyle: GoogleFonts.cairo(color: Color(0xffB7B7B7), fontSize: h * 0.017),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            hidePassword1 = !hidePassword1;
                          });
                        },
                        color: Theme.of(context).focusColor,
                        icon: Icon(
                          hidePassword1 ? Icons.visibility : Icons.visibility_off,
                          color: Color(0xffB7B7B7),
                        ),
                      ),
                      filled: true,
                      fillColor: Color(0xffF5F5F5),
                      border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(45)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(45)),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(45))),
                ),
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.text,
                  validator: (input) => input.length < 3 ? localized(context, 'should_be_more_than_3_letters') : null,
                  controller: _confirmPasswordController,
                  obscureText: !hidePassword2,
                  decoration: InputDecoration(
                      errorStyle: GoogleFonts.cairo(color: Colors.grey),
                      contentPadding: EdgeInsets.all(12),
                      hintText: '${localized(context, 'confirm_write_new_password')}',
                      hintStyle: GoogleFonts.cairo(color: Color(0xffB7B7B7), fontSize: h * 0.017),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            hidePassword2 = !hidePassword2;
                          });
                        },
                        color: Theme.of(context).focusColor,
                        icon: Icon(
                          hidePassword2 ? Icons.visibility : Icons.visibility_off,
                          color: Color(0xffB7B7B7),
                        ),
                      ),
                      filled: true,
                      fillColor: Color(0xffF5F5F5),
                      border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(45)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(45)),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(45))),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FlatButton(
                      onPressed: () {
                        // Navigator.of(context).pushNamed('/forgetPasswordScreen');
                      },
                      child: Text(
                        localized(context, 'forget_password'),
                        style: GoogleFonts.cairo(
                          fontSize: h * .018,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50),
                Center(
                  child: FlatButton(
                      child: Text(
                        localized(context, 'save'),
                        style: GoogleFonts.cairo(color: Colors.white),
                      ),
                      height: 50,
                      minWidth: 110,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45.0),
                      ),
                      color: baseColor,
                      onPressed: () {
                        if (_chaangePassKey.currentState.validate()) {
                          _chaangePassKey.currentState.save();
                          setState(() {
                            loading = true;
                          });
                          user.password = _passwordController.text;
                          // changePassword(oldPassWord: _oldPasswordController.text,user: user).then((value){
                          //   if(value == 0 ){
                          //     setState(() {
                          //       loading = false;
                          //     });
                          //     Navigator.pushNamed(context, "/pagesWidget",arguments: 0);
                          //   }else{
                          //     setState(() {
                          //       loading = false;
                          //     });
                          //   }
                          // });
                        } else {
                          setState(() {
                            isValidate = true;
                            loading = false;
                          });
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
