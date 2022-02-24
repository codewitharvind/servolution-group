
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
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

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
              /* Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                child: PinFieldAutoFill(
                  decoration: UnderlineDecoration(
                    textStyle:
                        const TextStyle(fontSize: 18, color: Colors.black),
                    colorBuilder:
                        FixedColorBuilder(Colors.black.withOpacity(0.3)),
                  ),
                  currentCode: "123456",
                  onCodeSubmitted: (code) {},
                  onCodeChanged: (code) {
                    if (code!.length == 6) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    }
                  },
                ),
              ), */
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                child: TextFormField(
                  obscureText: true,
                  controller: passwordController,
                  style: GoogleFonts.poppins(
                      fontSize: 15.0, color: const Color(0xff6b6c6e)),
                  cursorColor: Theme.of(context).cursorColor,
                  // initialValue: '',
                  maxLength: 50,
                  textAlign: TextAlign.start,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      color: Color(0xFFcccccc),
                    ),
                    /*helperText: 'Helper text',*/
                    /*suffixIcon: Icon(
                      Icons.check_circle,
                    ),*/
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
                  controller: confirmpasswordController,
                  style: GoogleFonts.poppins(
                      fontSize: 15.0, color: const Color(0xff6b6c6e)),
                  cursorColor: Theme.of(context).cursorColor,
                  // initialValue: '',
                  maxLength: 50,
                  textAlign: TextAlign.start,
                  decoration: const InputDecoration(
                    labelText: 'Confrim Password',
                    labelStyle: TextStyle(
                      color: Color(0xFFcccccc),
                    ),
                    /*helperText: 'Helper text',*/
                    /*suffixIcon: Icon(
                      Icons.check_circle,
                    ),*/
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
                          /*Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => dashboard()));*/

                          if (passwordController.text == '') {
                            // ignore: avoid_print
                            print("Password Empty");
                            final snackBar = SnackBar(
                              content: Text('Password should Not Be Empty',
                                  style: GoogleFonts.poppins(
                                      fontSize: 12.0, color: Colors.black)),
                              // ignore: prefer_const_constructors
                              backgroundColor: (Color(0xfffcb913)),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else if (confirmpasswordController.text == '') {
                            // ignore: avoid_print
                            print("Confirm Password Empty");
                            final snackBar = SnackBar(
                              content: Text(
                                  'Confirm Password should Not Be Empty',
                                  style: GoogleFonts.poppins(
                                      fontSize: 12.0, color: Colors.black)),
                              // ignore: prefer_const_constructors
                              backgroundColor: (Color(0xfffcb913)),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else if (passwordController.text !=
                              confirmpasswordController.text) {
                            print("Password mismatch");
                            final snackBar = SnackBar(
                              content: Text('Password mismatch',
                                  style: GoogleFonts.poppins(
                                      fontSize: 12.0, color: Colors.black)),
                              // ignore: prefer_const_constructors
                              backgroundColor: (Color(0xfffcb913)),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            setState(() => _isLoading = true);
                            SharedPreferences sharedPreferences =
                                await SharedPreferences.getInstance();
                            String password = confirmpasswordController.text;

                            Response response;
                            final Dio dio = Dio();
                            response = await dio.post(
                                'http://49.248.144.235/lv/servolutions/api/resetpassword',
                                queryParameters: {
                                  'otp': sharedPreferences
                                      .getString('otp_receive'),
                                  'new_password': password,
                                  'user_id': sharedPreferences.getInt('user_id')
                                });
                            print(response.data.toString());

                            if (response.data['status'] == true) {
                              print('Success');
                              setState(() => _isLoading = false);
                              final snackBar = SnackBar(
                                content: Text(response.data['message'],
                                    style: GoogleFonts.poppins(
                                        fontSize: 12.0, color: Colors.white)),
                                backgroundColor: (const Color(0xfffcb913)),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const login()));
                            } else {
                              // _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text('Assign a GlobalKey to the Scaffold')));
                              print(response.data['message']);
                              setState(() => _isLoading = false);
                              final snackBar = SnackBar(
                                content: Text(response.data['message'],
                                    style: GoogleFonts.poppins(
                                        fontSize: 12.0, color: Colors.white)),
                                backgroundColor: (const Color(0xfffcb913)),
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
              _isLoading
                  ? Styles.spinLoader
                  : const SizedBox(),
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
}
