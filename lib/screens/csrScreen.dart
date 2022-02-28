// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servolution/screens/csrLabels.dart';
import 'package:servolution/screens/csrService.dart';
import 'package:servolution/screens/dashboard.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CSRModule extends StatefulWidget {
  const CSRModule({Key? key}) : super(key: key);

  @override
  State<CSRModule> createState() => _CSRModuleState();
}

class _CSRModuleState extends State<CSRModule> {
  late SharedPreferences sharedPreferences;
  late List<dynamic> dataList;
  int count = 0;

  @override
  void initState() {
    super.initState();
    getCSRService();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getCSRService() async {
    sharedPreferences = await SharedPreferences.getInstance();
    Response response;
    final Dio dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["authorization"] =
        "${sharedPreferences.getString('api_access_token')}";
    response = await dio.post(
        'http://49.248.144.235/lv/servolutions/api/get-user-services',
        queryParameters: {
          'user_id': sharedPreferences.getInt('user_id'),
        });
    if (response.data['status'] == true) {
      setState(() {
        dataList = response.data['data'];
        count = dataList.length;
      });
    }
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
        body: ListView.builder(
            physics: const PageScrollPhysics(),
            itemCount: count,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 80,
                padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0),
                child: Card(
                  color: Colors.amber.shade300,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: InkWell(
                    onTap: () async {
                      sharedPreferences = await SharedPreferences.getInstance();
                      await sharedPreferences.setString('csrservice',
                          dataList[index]['fk_service_type'].toString());
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CSRService()));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                child: Text(
                                  dataList[index]['service_name'].toString(),
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                      color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }) /* Container(
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
      ), */
        );
  }
}
