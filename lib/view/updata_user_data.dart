import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../constant/contant.dart';
import '../controller/user_controller.dart';
import '../repository/user_repository.dart';
import '../widget/LoadingScreen.dart';

class UpdateUserData extends StatefulWidget {
  @override
  _UpdateUserDataState createState() => _UpdateUserDataState();
}

class _UpdateUserDataState extends State<UpdateUserData> {
  UserController userController = UserController();
  GlobalKey<FormState> _loginKey = GlobalKey<FormState>();
  bool isValidate = false;
  bool lockPass = false;
  bool loading = false;
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  File file;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  setUserData(){
    _phoneController = TextEditingController(text: currentUser.value.phone);
    _nameController = TextEditingController(text: currentUser.value.name);
    _emailController = TextEditingController(text: currentUser.value.email);
  }

  @override
  void initState() {
    setUserData();
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
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
                top: 100,
                left: 10,
                right: 10,
                bottom: 20,
                child: Container(
                  width: w*.9,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.08),
                            blurRadius: 7,
                            spreadRadius: 7
                        )
                      ]
                  ),
                  padding: EdgeInsets.only(top: 70,left: 15,right: 15),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localized(context, 'name'),
                          style: GoogleFonts.cairo(
                            color: Color(0xff9B9B9B),
                            fontSize: 15,
                          ),
                        ),
                        TextFormField(
                            controller: _nameController,
                            validator: (input){
                              if(input.isEmpty){
                                return 'should fill name';
                              }else{
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(12),
                                // prefixIcon: Icon(Icons.mail_outline),
                                filled: true,
                                fillColor: Color(0xffF5F5F5),
                                border: OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.circular(45)),
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.circular(45)),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.circular(45))
                            )
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
                            validator: (input){
                              if(input.isEmpty){
                                return 'should fill email';
                              }else{
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(12),
                                // prefixIcon: Icon(Icons.mail_outline),
                                filled: true,
                                fillColor: Color(0xffF5F5F5),
                                border: OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.circular(45)),
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.circular(45)),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.circular(45))
                            )
                        ),
                        SizedBox(
                          height: 25,
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
                            validator: (input){
                              if(input.isEmpty){
                                return 'should fill phone';
                              }else{
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(12),
                                // prefixIcon: Icon(Icons.mail_outline),
                                filled: true,
                                fillColor: Color(0xffF5F5F5),
                                border: OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.circular(45)),
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.circular(45)),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.circular(45))
                            )
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Center(
                          child: MaterialButton(
                            onPressed: (){
                              UpdateBTN(context);
                            },
                            color: baseColor,
                            elevation: 0,
                            height: 55,
                            minWidth: 276,
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(45),
                                borderSide: BorderSide.none
                            ),
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
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                  top: 50,
                  left: 20,
                  right: 20,
                  child: InkWell(
                    onTap: getImage,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white,width: 2),
                              color: Colors.black,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: file != null?FileImage(file):currentUser.value.image == null? AssetImage('assets/img/person.png'):
                                  NetworkImage(currentUser.value.image),
                                  fit: BoxFit.contain
                              )
                          ),
                        ),
                        Positioned(
                            top: 0,
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              alignment: Alignment.center,
                              height: 30,
                              width: 30,
                              child: Padding(
                                padding: const EdgeInsets.all(30),
                                child: Image.asset(
                                  'assets/img/edit.png',
                                  color: Colors.white,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            )
                        ),
                      ],
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }

  UpdateBTN(BuildContext context) {
    if(_loginKey.currentState.validate()){
      setState(() {
        loading = true;
      });
      userController.user.email = _emailController.text;
      userController.user.phone = _phoneController.text;
      userController.user.name = _nameController.text;
      userController.user.file = file;
      userController.userUpdateData(context).whenComplete(() => setState(() => loading = false));
    }else{
      setState(() {
        isValidate = true;
      });
    }
  }
}
