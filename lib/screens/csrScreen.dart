// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servolution/screens/dashboard.dart';
import 'package:image_picker/image_picker.dart';

class CSRModule extends StatefulWidget {
  const CSRModule({Key? key}) : super(key: key);

  @override
  State<CSRModule> createState() => _CSRModuleState();
}

class _CSRModuleState extends State<CSRModule> {
  late File uploadimage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void chooseATMFront() async {
    final XFile? choosedimage =
        await _picker.pickImage(source: ImageSource.camera);
    //set source: ImageSource.camera to get image from camera
    setState(() {
      uploadimage = File(choosedimage!.path);
    });
    print('**********************************');
    print(choosedimage!.path);
    print('**********************************');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const dashboard())),
        ),
        backgroundColor: const Color(0xfffcb913),
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "CSR",
          style: GoogleFonts.poppins(fontSize: 20.0, color: Colors.black),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.fromLTRB(5.0, 10.0, 30.0, 5.0),
                      child: Text('ATM Front',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              fontSize: 14.0,
                              color: Colors.black)),
                    ),
                    RaisedButton.icon(
                      onPressed: () {
                        chooseATMFront(); // call choose image function
                      },
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: const Text("UPLOAD IMAGE"),
                      color: const Color(0xfffcb913),
                      colorBrightness: Brightness.dark,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.fromLTRB(5.0, 10.0, 30.0, 5.0),
                      child: Text('Selfie',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              fontSize: 14.0,
                              color: Colors.black)),
                    ),
                    RaisedButton.icon(
                      onPressed: () {
                        chooseATMFront(); // call choose image function
                      },
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: const Text("UPLOAD IMAGE"),
                      color: const Color(0xfffcb913),
                      colorBrightness: Brightness.dark,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.fromLTRB(5.0, 10.0, 30.0, 5.0),
                      child: Text('Back Photo',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              fontSize: 14.0,
                              color: Colors.black)),
                    ),
                    RaisedButton.icon(
                      onPressed: () {
                        chooseATMFront(); // call choose image function
                      },
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: const Text("UPLOAD IMAGE"),
                      color: const Color(0xfffcb913),
                      colorBrightness: Brightness.dark,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.fromLTRB(5.0, 10.0, 30.0, 5.0),
                      child: Text('Top Photo',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              fontSize: 14.0,
                              color: Colors.black)),
                    ),
                    RaisedButton.icon(
                      onPressed: () {
                        chooseATMFront(); // call choose image function
                      },
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: const Text("UPLOAD IMAGE"),
                      color: const Color(0xfffcb913),
                      colorBrightness: Brightness.dark,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
