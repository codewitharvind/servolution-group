// ignore_for_file: deprecated_member_use, unnecessary_const

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servolution/screens/dashboard.dart';
import 'package:servolution/screens/forgotPassword.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:servolution/utils/styles.dart';

bool _isLoading = true;

// ignore: camel_case_types
class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  _loginState createState() => _loginState();
}

// ignore: camel_case_types
class _loginState extends State<login> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: todo
    // TODO: implement build
    return WillPopScope(
        onWillPop: () async {
          bool willLeave = false;
          // show the confirm dialog
          await showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: const Text('Close App'),
                    content: const Text('Do you want to exit Servolution ?'),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            willLeave = true;
                            Navigator.of(context).pop();
                          },
                          child: const Text('Yes'),
                          style: ElevatedButton.styleFrom(
                            primary: const Color(0xfffcb913),
                          )),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('No',
                            style: TextStyle(color: const Color(0xff939298))),
                      )
                    ],
                  ));
          return willLeave;
        },
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
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
                        "Sign In",
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
                        maxLength: 50,
                        textAlign: TextAlign.start,
                        decoration: const InputDecoration(
                          labelText: 'Username',
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
                        controller: passwordController,
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
                    SizedBox(
                      height: 60.0,
                      child: RaisedButton(
                        onPressed: _isLoading
                            ? null
                            : () async {
                                if (usernameController.text == '') {
                                  // ignore: avoid_print
                                  print("username empty");
                                  final snackBar = SnackBar(
                                    content: Text(
                                        'Username Should Not Be Empty',
                                        style: GoogleFonts.poppins(
                                            fontSize: 12.0,
                                            color: Colors.black)),
                                    backgroundColor: (const Color(0xfffcb913)),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } else if (passwordController.text == '') {
                                  // ignore: avoid_print
                                  print("password empty");
                                  final snackBar = SnackBar(
                                    content: Text(
                                        'Password Should Not Be Empty',
                                        style: GoogleFonts.poppins(
                                            fontSize: 12.0,
                                            color: Colors.black)),
                                    // ignore: prefer_const_constructors
                                    backgroundColor: (Color(0xfffcb913)),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } else if (usernameController.text == '' &&
                                    passwordController.text == '') {
                                  final snackBar = SnackBar(
                                    content: Text(
                                        'Username And Password Required',
                                        style: GoogleFonts.poppins(
                                            fontSize: 12.0,
                                            color: Colors.black)),
                                    backgroundColor: (const Color(0xfffcb913)),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } else {
                                  setState(() => _isLoading = true);
                                  String username = usernameController.text;
                                  String password = passwordController.text;

                                  Response response;
                                  final Dio dio = Dio();
                                  response = await dio.post(
                                      'http://49.248.144.235/lv/servolutions/api/login',
                                      queryParameters: {
                                        'email': username,
                                        'password': password
                                      });
                                  print(response.data.toString());

                                  if (response.data['status'] == true) {
                                    print('Success');

                                    int userId, status;

                                    String name,
                                        email,
                                        contactNumber,
                                        altContactNumber,
                                        dateOfJoining,
                                        apiAccessToken;

                                    // integer data response
                                    userId = response.data['data']['id'];
                                    status = response.data['data']['status'];

                                    // string data response
                                    name = response.data['data']['name'];
                                    email = response.data['data']['email'];
                                    contactNumber =
                                        response.data['data']['contact_number'];
                                    altContactNumber = response.data['data']
                                        ['alt_contact_number'];
                                    dateOfJoining = response.data['data']
                                        ['date_of_joining'];

                                    apiAccessToken =
                                        response.data['api_access_token'];
                                    print(apiAccessToken);

                                    SharedPreferences sharedPreferences =
                                        await SharedPreferences.getInstance();
                                    await sharedPreferences.setInt(
                                        'user_id', userId);
                                    await sharedPreferences.setInt(
                                        'status', status);
                                    await sharedPreferences.setString(
                                        'name', name);
                                    await sharedPreferences.setString(
                                        'email', email);
                                    await sharedPreferences.setString(
                                        'contact_number', contactNumber);
                                    await sharedPreferences.setString(
                                        'alt_contact_number', altContactNumber);
                                    await sharedPreferences.setString(
                                        'date_of_joining', dateOfJoining);
                                    await sharedPreferences.setString(
                                        'api_access_token', apiAccessToken);

                                    print('printing-from-sharedpreferences');
                                    print(sharedPreferences.get('user_id'));
                                    setState(() => _isLoading = false);
                                    // navigate user to dashboard screen on API success response
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const dashboard()));
                                    final snackBar = SnackBar(
                                      content: Text('Welcome to Servolutions',
                                          style: GoogleFonts.poppins(
                                              fontSize: 12.0,
                                              color: Colors.white)),
                                      backgroundColor:
                                          (const Color(0xfffcb913)),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
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
                              "Log in",
                              textAlign: TextAlign.center,
                              style: Styles.googleFontBlack,
                            ),
                          ),
                        ),
                      ),
                    ),
                    _isLoading ? Styles.spinLoader : const SizedBox(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 50, 5, 5),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPassword()));
                        },
                        child: Text(
                          "Forgot Password?",
                          style: Styles.googleFontGrey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }

  String? validatePassword(String value) {
    String patttern = r'(^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$)';
    RegExp regExp = RegExp(patttern);
    if (value.isEmpty) {
      return "New Password is required";
    } else if (!regExp.hasMatch(value)) {
      return "Password not in proper format";
    }
    return null;
  }
}
