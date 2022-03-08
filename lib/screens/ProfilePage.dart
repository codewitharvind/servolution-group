// ignore_for_file: deprecated_member_use, unnecessary_const

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servolution/response/Counts.dart';
import 'package:servolution/screens/dashboard.dart';
import 'package:servolution/screens/login.dart';
import 'package:servolution/utils/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  late String pass, oldPassword, newPassword, confirmPassword = '';
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool _status = true;
  bool _passwordStatus = false;
  final FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    fetchInfo();
  }

  fetchInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    usernameController.text = sharedPreferences.getString('name')!;
    emailController.text = sharedPreferences.getString('email')!;
    mobileController.text = sharedPreferences.getString('contact_number')!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const dashboard())),
          ),
          backgroundColor: const Color(0xfffcb913),
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: true,
          title: Text(
            "PROFILE",
            style: GoogleFonts.poppins(fontSize: 20.0, color: Colors.black),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    color: const Color(0xffFFFFFF),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: const <Widget>[
                                      Text(
                                        'Parsonal Information',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      _status ? _getEditIcon() : Container(),
                                    ],
                                  )
                                ],
                              )),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: const <Widget>[
                                      Text(
                                        'Name',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Flexible(
                                    child: TextField(
                                      controller: usernameController,
                                      decoration: const InputDecoration(
                                        hintText: "Enter Your Name",
                                      ),
                                      enabled: !_status,
                                      autofocus: !_status,
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: const <Widget>[
                                      Text(
                                        'Email ID',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Flexible(
                                    child: TextField(
                                      controller: emailController,
                                      readOnly: true,
                                      decoration: const InputDecoration(
                                          hintText: "Enter Email ID"),
                                      enabled: !_status,
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: const <Widget>[
                                      Text(
                                        'Mobile',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Flexible(
                                    child: TextField(
                                      controller: mobileController,
                                      decoration: const InputDecoration(
                                          hintText: "Enter Mobile Number"),
                                      enabled: !_status,
                                    ),
                                  ),
                                ],
                              )),
                          !_status ? _getActionButtons() : Container(),
                        ],
                      ),
                    ),
                  ),
                  _passwordStatus == false
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(
                              10.0, 10.0, 190.0, 10.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _passwordStatus = true;
                              });
                            },
                            child: Container(
                              height: 40.0,
                              width: 150.0,
                              decoration: BoxDecoration(
                                color: const Color(0xfffcb913),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const <Widget>[
                                  Center(
                                    child: Text(
                                      'Change Password',
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
                        )
                      : Padding(
                          padding: const EdgeInsets.fromLTRB(
                              290.0, 10.0, 10.0, 10.0),
                          child: GestureDetector(
                            child: const CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: 14.0,
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16.0,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _passwordStatus = false;
                              });
                            },
                          ),
                        ),
                  _passwordStatus == true
                      ?  Padding(
                    padding: const EdgeInsets.fromLTRB(05.0, 10.0, 05.0, 0.0),
                    child: Card(
                      color: Colors.black12,
                      child: InkWell(
                        splashColor: Colors.lightBlueAccent.withAlpha(30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const <Widget>[
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
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
                  ): const SizedBox(),
                  _passwordStatus == true
                      ? Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: const <Widget>[
                                          Text(
                                            'Current Password',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Flexible(
                                        child: TextFormField(
                                          keyboardType: TextInputType.text,
                                          obscureText: true,
                                          controller: oldPasswordController,
                                          decoration: const InputDecoration(
                                            hintText: "Enter Current Password",
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: const <Widget>[
                                          Text(
                                            'New Pasword',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Flexible(
                                        child: TextFormField(
                                          controller: newPasswordController,
                                          validator: validatePassword,
                                          decoration: const InputDecoration(
                                              hintText: "Enter New Password"),
                                        ),
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: const <Widget>[
                                          Text(
                                            'Confirm Password',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Flexible(
                                      child: TextFormField(
                                        controller: confirmPasswordController,
                                        validator: comparePassword,
                                        decoration: const InputDecoration(
                                            hintText: "Enter Confirm Password"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              _getPasswordActionButtons(),
                            ],
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
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

  Widget _getPasswordActionButtons() {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: RaisedButton(
                child: const Text("Save"),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                    Response response;
                    final Dio dio = Dio();
                    dio.options.headers['content-Type'] = 'application/json';
                    dio.options.headers["authorization"] =
                        "${sharedPreferences.getString('api_access_token')}";
                    response = await dio.post(
                        'http://49.248.144.235/lv/servolutions/api/change-password',
                        queryParameters: {
                          'id': sharedPreferences.getInt('user_id'),
                          'old_password': oldPasswordController.text,
                          'new_password': newPasswordController.text,
                          'confirm_password': confirmPasswordController.text
                        });
                    print(response);
                    if (response.data['status'] == true) {
                      print(response.data);
                      SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                      sharedPreferences.remove('user_id');
                      sharedPreferences.remove('status');
                      sharedPreferences.remove('name');
                      sharedPreferences.remove('email');
                      sharedPreferences.remove('contact_number');
                      sharedPreferences.remove('alt_contact_number');
                      sharedPreferences.remove('date_of_joining');
                      sharedPreferences.remove('api_access_token');
                      sharedPreferences.remove('category');
                      sharedPreferences.remove('subCategory');
                      sharedPreferences.remove('microcategory');
                      sharedPreferences.remove('service');
                      sharedPreferences.remove('ticket');
                      sharedPreferences.remove('csrservice');
                      setState(() {
                        _status = true;
                        FocusScope.of(context).requestFocus(FocusNode());
                      });
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const login()));
                      final snackBar = SnackBar(
                        content: Text(
                            response.data['message'] +
                                '. Please relogin with new password',
                            style: GoogleFonts.poppins(
                                fontSize: 12.0, color: Colors.white)),
                        backgroundColor: (const Color(0xfffcb913)),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      final snackBar = SnackBar(
                        content: Text(response.data['message'],
                            style: GoogleFonts.poppins(
                                fontSize: 12.0, color: Colors.white)),
                        backgroundColor: (const Color(0xfffcb913)),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  }
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: RaisedButton(
                child: const Text("Cancel"),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    _passwordStatus = false;
                    FocusScope.of(context).requestFocus(FocusNode());
                  });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getActionButtons() {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: RaisedButton(
                child: const Text("Save"),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () async {
                  SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                  Response response;
                  final Dio dio = Dio();
                  dio.options.headers['content-Type'] = 'application/json';
                  dio.options.headers["authorization"] =
                      "${sharedPreferences.getString('api_access_token')}";
                  response = await dio.post(
                      'http://49.248.144.235/lv/servolutions/api/get_update_user_profile',
                      queryParameters: {
                        'user_id': sharedPreferences.getInt('user_id'),
                        'name': usernameController.text,
                        'contact_number': mobileController.text
                      });
                  if (response.data['status'] == true) {
                    print(response.data);
                    setState(() {
                      _status = true;
                      FocusScope.of(context).requestFocus(FocusNode());
                    });
                    await sharedPreferences.setString(
                        'name', usernameController.text);
                    await sharedPreferences.setString(
                        'contact_number', mobileController.text);
                    final snackBar = SnackBar(
                      content: Text(response.data['message'],
                          style: GoogleFonts.poppins(
                              fontSize: 12.0, color: Colors.white)),
                      backgroundColor: (const Color(0xfffcb913)),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    final snackBar = SnackBar(
                      content: Text(response.data['message'],
                          style: GoogleFonts.poppins(
                              fontSize: 12.0, color: Colors.white)),
                      backgroundColor: (const Color(0xfffcb913)),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: RaisedButton(
                child: const Text("Cancel"),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(FocusNode());
                  });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return GestureDetector(
      child: const CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}
