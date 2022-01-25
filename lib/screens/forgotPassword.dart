// ignore_for_file: deprecated_member_use, unnecessary_const

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servolution/screens/login.dart';
import 'package:servolution/screens/resetPassword.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool _isLoading = true;

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController usernameController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
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
                child: Text(
                  "M - AUDIT",
                  style: GoogleFonts.poppins(
                      fontSize: 30.0, color: const Color(0xff3c4250)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                child: Text(
                  "Forgot Password",
                  style: GoogleFonts.poppins(
                      fontSize: 15.0, color: const Color(0xff3c4250)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                child: TextFormField(
                  controller: usernameController,
                  style: GoogleFonts.poppins(
                      fontSize: 15.0, color: const Color(0xff6b6c6e)),
                  cursorColor: Theme.of(context).cursorColor,
                  // initialValue: '',
                  maxLength: 50,
                  textAlign: TextAlign.start,
                  decoration: const InputDecoration(
                    labelText: 'Username',
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

                          if (usernameController.text == '') {
                            // ignore: avoid_print
                            print("username empty");
                            final snackBar = SnackBar(
                              content: Text('Username Should Not Be Empty',
                                  style: GoogleFonts.poppins(
                                      fontSize: 12.0, color: Colors.black)),
                              // ignore: prefer_const_constructors
                              backgroundColor: (Color(0xfffcb913)),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            setState(() => _isLoading = true);
                            String username = usernameController.text;

                            Response response;
                            final Dio dio = Dio();
                            response = await dio.post(
                                'http://49.248.144.235/lv/servolutions/api/forgotpassword',
                                queryParameters: {
                                  'email': username,
                                });
                            print(response.data.toString());

                            if (response.data['status'] == true) {
                              print('Success');

                              int userId;
                              String otpReceived;

                              // integer data response
                              userId = response.data['user_id'];
                              otpReceived = response.data['otp'];

                              SharedPreferences sharedPreferences =
                                  await SharedPreferences.getInstance();
                              await sharedPreferences.setInt('user_id', userId);
                              await sharedPreferences.setString(
                                  'otp_receive', otpReceived);

                              print(sharedPreferences.get('user_id'));
                              setState(() => _isLoading = false);
                              // navigate user to dashboard screen on API success response
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ResetPassword()));
                            } else {
                              // _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text('Assign a GlobalKey to the Scaffold')));
                              print(response.data['message']);
                              setState(() => _isLoading = false);
                              final snackBar = SnackBar(
                                content: Text(response.data['message'],
                                    style: GoogleFonts.poppins(
                                        fontSize: 12.0, color: Colors.black)),
                                // ignore: prefer_const_constructors
                                backgroundColor: (Color(0xfffcb913)),
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
                        style: GoogleFonts.poppins(
                            fontSize: 15.0, color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
              _isLoading
                  ? const SpinKitThreeBounce(
                      color: Color(0xfffcb913),
                      size: 30.0,
                    )
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
                    style: GoogleFonts.poppins(
                        fontSize: 15.0, color: const Color(0xff939298)),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
