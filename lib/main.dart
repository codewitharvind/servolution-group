import 'dart:async';
import 'package:flutter/material.dart';
import 'package:servolution/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:servolution/screens/dashboard.dart';
import 'package:servolution/styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<MyHomePage> {
  startTime() async {
    var _duration = const Duration(seconds: 5);
    return Timer(_duration,
        checkIsLogin); //checkIsLogin function used to check it user has login or not.
  }

  @override
  void initState() {
    super.initState();
    /*  Timer(Duration(seconds: 5), ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) => Login()
            )
        )
    ); */
    startTime();
  }

  Future<void> checkIsLogin() async {
    /* Data stored in the device memory is called here.
    Here the checkIsLogin() checks if the user login the App and closed the App but didn't logout or if the user logout before closing the App.*/
    String? userName = "";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString("name");
    print(userName);
    if (userName != "" && userName != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const dashboard()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const login()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset('assets/servolutions_logo.jpg'),
          Padding(
              padding: const EdgeInsets.fromLTRB(50, 350, 50, 0),
              child: MaterialButton(
                  onPressed: () {
                    Navigator.pop(context,
                        MaterialPageRoute(builder: (context) => const login()));
                  },
                  child: Styles.spinLoader)),
        ],
      )),
    );
  }
}
