// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:servolution/screens/csrScreen.dart';
import 'package:servolution/utils/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class CSRLabel extends StatefulWidget {
  final String text;
  const CSRLabel({Key? key, required this.text}) : super(key: key);

  @override
  State<CSRLabel> createState() => _CSRLabelState();
}

class _CSRLabelState extends State<CSRLabel> {
  late SharedPreferences sharedPreferences;
  late List<dynamic> dataList;
  int count = 0;
  late String selectedFilePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    getCSRLabel();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getCSRLabel() async {
    sharedPreferences = await SharedPreferences.getInstance();
    Response response;
    final Dio dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["authorization"] =
        "${sharedPreferences.getString('api_access_token')}";
    response = await dio.post(
        'http://49.248.144.235/lv/servolutions/api/get-service-csr-labels',
        queryParameters: {
          'fk_service_id': sharedPreferences.getString('csrservice'),
        });
    if (response.data['status'] == true) {
      setState(() {
        dataList = response.data['data'];
        count = dataList.length;
      });
    }
  }

  chooseATMFront(labelId) async {
    print(labelId);
    final XFile? choosedimage =
        await _picker.pickImage(source: ImageSource.camera);
    //set source: ImageSource.camera to get image from camera
    // getting a directory path for saving
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

// copy the file to a new path
    final File newImage =
        await File(choosedimage!.path).copy('$appDocPath/image1.png');
    setState(() {
      selectedFilePath = newImage.path;
    });
    print('**********************************');
    print(choosedimage!.path);
    print(selectedFilePath);
    print('**********************************');
    if (choosedimage != null) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final Dio dio = Dio();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] =
          "${sharedPreferences.getString('api_access_token')}";
      var formData = FormData.fromMap({
        'fk_label_id': labelId,
        'csr_id': widget.text,
        'documents': await MultipartFile.fromFile(selectedFilePath.toString(),
            filename: selectedFilePath.toString().split('/').last)
      });
      final response = await dio.post(
        'http://49.248.144.235/lv/servolutions/api/upload-csr-labels-document',
        data: formData,
        options: Options(
          followRedirects: false,
          // will not throw errors
          validateStatus: (status) => true,
          headers: {
            'content-Type': 'application/json',
            'authorization':
                "${sharedPreferences.getString('api_access_token')}"
          },
        ),
      );
      print(response);
      /* if (response.data['status'] == true) {
        print(response);
      } */
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
              MaterialPageRoute(builder: (context) => const CSRModule())),
        ),
        backgroundColor: const Color(0xfffcb913),
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "CSR LABEL",
          style: GoogleFonts.poppins(fontSize: 20.0, color: Colors.black),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListView.builder(
            itemCount: count,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
                          child: Text(dataList[index]['name'].toString(),
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.0,
                                  color: Colors.black)),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                          child: RaisedButton.icon(
                            onPressed: () {
                              chooseATMFront(dataList[index][
                                  'fk_service_id']); // call choose image function
                            },
                            icon: const Icon(Icons.camera_alt_outlined),
                            label: const Text("UPLOAD IMAGE"),
                            color: const Color(0xfffcb913),
                            colorBrightness: Brightness.dark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Styles.appHorizontalDivider,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
