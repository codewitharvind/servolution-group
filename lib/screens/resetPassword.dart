// ignore_for_file: deprecated_member_use, unnecessary_const

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servolution/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:servolution/utils/styles.dart';

bool _isLoading = true;

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: todo
    // TODO: implement build

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 25, 5, 5),
                    child: Image.asset(
                      'assets/servolutions_logo.jpg',
                      height: 200,
                      width: 200,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 00, 5, 5),
                child: Styles.headingText,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                child: Text(
                  "Reset Password",
                  style: GoogleFonts.poppins(
                      fontSize: 15.0, color: const Color(0xff3c4250)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(05.0, 10.0, 05.0, 0.0),
                child: Card(
                  color: Colors.black12,
                  child: InkWell(
                    splashColor: Colors.lightBlueAccent.withAlpha(30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                          child: Text(
                            'Password must contain one number (0-9), one lowercase letter (a-z) and one uppercase letter (A-Z). No special characters are allowed.',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14.0,
                                color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                      child: TextFormField(
                        obscureText: true,
                        controller: newPasswordController,
                        validator: validatePassword,
                        style: GoogleFonts.poppins(
                            fontSize: 15.0, color: const Color(0xff6b6c6e)),
                        cursorColor: Theme.of(context).cursorColor,
                        maxLength: 50,
                        textAlign: TextAlign.start,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color: Color(0xFFcccccc),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFcccccc)),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                      child: TextFormField(
                        obscureText: true,
                        controller: confirmPasswordController,
                        validator: comparePassword,
                        style: GoogleFonts.poppins(
                            fontSize: 15.0, color: const Color(0xff6b6c6e)),
                        cursorColor: Theme.of(context).cursorColor,
                        maxLength: 50,
                        textAlign: TextAlign.start,
                        decoration: const InputDecoration(
                          labelText: 'Confrim Password',
                          labelStyle: TextStyle(
                            color: Color(0xFFcccccc),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFcccccc)),
                          ),
                        ),
                      ),
                    ),
                    // ignore: sized_box_for_whitespace
                    Container(
                      height: 60.0,
                      child: RaisedButton(
                        onPressed: _isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  setState(() => _isLoading = true);
                                  SharedPreferences sharedPreferences =
                                      await SharedPreferences.getInstance();
                                  String password =
                                      confirmPasswordController.text;

                                  Response response;
                                  final Dio dio = Dio();
                                  response = await dio.post(
                                      'http://49.248.144.235/lv/servolutions/api/resetpassword',
                                      queryParameters: {
                                        'otp': sharedPreferences
                                            .getString('otp_receive'),
                                        'new_password': password,
                                        'user_id':
                                            sharedPreferences.getInt('user_id')
                                      });
                                  print(response.data.toString());

                                  if (response.data['status'] == true) {
                                    print('Success');
                                    setState(() => _isLoading = false);
                                    final snackBar = SnackBar(
                                      content: Text(response.data['message'],
                                          style: GoogleFonts.poppins(
                                              fontSize: 12.0,
                                              color: Colors.white)),
                                      backgroundColor:
                                          (const Color(0xfffcb913)),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const login()));
                                  } else {
                                    // _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text('Assign a GlobalKey to the Scaffold')));
                                    print(response.data['message']);
                                    setState(() => _isLoading = false);
                                    final snackBar = SnackBar(
                                      content: Text(response.data['message'],
                                          style: GoogleFonts.poppins(
                                              fontSize: 12.0,
                                              color: Colors.white)),
                                      backgroundColor:
                                          (const Color(0xfffcb913)),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                }
                              },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0)),
                        padding: const EdgeInsets.all(0.0),
                        child: Ink(
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  const Color(0xfffcb913),
                                  const Color(0xfffcb913)
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(30.0)),
                          child: Container(
                            constraints: const BoxConstraints(
                                maxWidth: 200.0, minHeight: 60.0),
                            alignment: Alignment.center,
                            child: Text(
                              "Submit",
                              textAlign: TextAlign.center,
                              style: Styles.googleFontBlack,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _isLoading ? Styles.spinLoader : const SizedBox(),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 50, 5, 5),
                child: InkWell(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const login()));
                  },
                  child: Text(
                    "Login",
                    style: Styles.googleFontGrey,
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  String? validatePassword(String? value) {
    String patttern = r'(^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$)';
    RegExp regExp = RegExp(patttern);
    if (value!.isEmpty) {
      return "New Password is required";
    } else if (!regExp.hasMatch(value)) {
      print(value);
      return "Password not in proper format";
    } else {
      return null;
    }
  }

  String? comparePassword(String? value) {
    if (value!.isEmpty) {
      return "Confirm Password is required";
    } else if (newPasswordController.text != confirmPasswordController.text) {
      return "Password mismatch";
    } else {
      return null;
    }
  }
}
