import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servolution/screens/dashboard.dart';
import 'package:servolution/screens/notificationInfo.dart';
import 'package:servolution/utils/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';

class HSK_House_keeping extends StatefulWidget {
  const HSK_House_keeping({Key? key}) : super(key: key);

  @override
  State<HSK_House_keeping> createState() => _HSK_House_keepingState();
}

class _HSK_House_keepingState extends State<HSK_House_keeping> {
  late SharedPreferences sharedPreferences;
  late List<dynamic> dataList;
  int count = 0;

  @override
  void initState() {
    super.initState();
    getHSKList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getFileChoosen(hskID) async {
    FilePickerResult? selectedfile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
    );
    if (selectedfile != null) {
      List<File> files =
          selectedfile.paths.map((path) => File(path.toString())).toList();
      print('*************');
      print(files);
      print('*************');
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final Dio dio = Dio();
      dio.options.headers['content-Type'] = 'application/json';
      var formData = FormData.fromMap({
        'hsk_id': hskID,
        'documents': [
          for (var file in files)
            {
              await MultipartFile.fromFile(file.path,
                  filename: file.path.toString().split('/').last)
            }.toList()
        ]
      });
      final response = await dio.post(
        'http://49.248.144.235/lv/servolutions/api/upload-hsk-document',
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
      if (response.data['status'] == true) {
        final snackBar = SnackBar(
          content: Text(response.data['message'],
              style: GoogleFonts.poppins(fontSize: 12.0, color: Colors.white)),
          backgroundColor: (const Color(0xfffcb913)),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        final snackBar = SnackBar(
          content: Text(response.data['message'],
              style: GoogleFonts.poppins(fontSize: 12.0, color: Colors.white)),
          backgroundColor: (const Color(0xfffcb913)),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  getHSKList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    Response response;
    final Dio dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["authorization"] =
        "${sharedPreferences.getString('api_access_token')}";
    response = await dio.post(
        'http://49.248.144.235/lv/servolutions/api/hsk-manual-ticket-listing',
        queryParameters: {
          'user_id': sharedPreferences.getInt('user_id'),
        });
    print(response);
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
          "HOUSE KEEPING",
          style: GoogleFonts.poppins(fontSize: 20.0, color: Colors.black),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationInfo()));
            },
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        child: ListView.builder(
          physics: const PageScrollPhysics(),
          itemCount: count,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0),
              child: Card(
                elevation: 9,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: InkWell(
                  onTap: () {
                    /* Navigator.pushReplacement(
                                           context,
                                           MaterialPageRoute(
                                               builder: (context) => TicketDetail(
                                                   text: titicketListResponse.data[index].ticketNumber))); */
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                              child: Text('ATM ID',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                      color: Colors.black)),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  0.0, 0.0, 10.0, 0.0),
                              child: Text(dataList[index]['atm_id'].toString(),
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.0,
                                      color: Colors.black)),
                            ),
                          ],
                        ),
                      ),
                      Styles.appHorizontalDivider,
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                              child: Text('Scope of work',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                      color: Colors.black)),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  0.0, 0.0, 10.0, 0.0),
                              child: Text(
                                  dataList[index]['scope_of_work'].toString(),
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.0,
                                      color: Colors.black)),
                            ),
                          ],
                        ),
                      ),
                      Styles.appHorizontalDivider,
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                              child: Text('Assign Date',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                      color: Colors.black)),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  0.0, 0.0, 10.0, 0.0),
                              child: Text(dataList[index]['date'].toString(),
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.0,
                                      color: Colors.black)),
                            ),
                          ],
                        ),
                      ),
                      Styles.appHorizontalDivider,
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                              child: Text('HSK Image',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                      color: Colors.black)),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 0.0, 10.0, 10.0),
                              child: InkWell(
                                onTap: () {
                                  getFileChoosen(dataList[index]['id']);
                                },
                                child: Container(
                                  height: 30.0,
                                  width: 60.0,
                                  decoration: BoxDecoration(
                                    color: const Color(0xfffcb913),
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: const <Widget>[
                                      Center(
                                        child: Text(
                                          'Upload',
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 12.0,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 0.0, 10.0, 10.0),
                              child: InkWell(
                                onTap: () {
                                  getFileChoosen(dataList[index]['id']);
                                },
                                child: Container(
                                  height: 30.0,
                                  width: 60.0,
                                  decoration: BoxDecoration(
                                    color: const Color(0xfffcb913),
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: const <Widget>[
                                      Center(
                                        child: Text(
                                          'View',
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 12.0,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
          },
        ),
      ),
    );
  }
}
