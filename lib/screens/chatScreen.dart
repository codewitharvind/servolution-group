// ignore_for_file: unnecessary_new, deprecated_member_use

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servolution/screens/ticketListPage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:servolution/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String text;
  const ChatScreen({Key? key, required this.text}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  late List<dynamic> commentData;
  late String filePath;
  final ImagePicker _picker = ImagePicker();
  /* late XFile _imageFileList; */
  late File uploadimage; //variable for choosed file
  int userId = 0;
  bool checkboxValue = false;
  @override
  void initState() {
    super.initState();
    commentData = [];
    getUserData();
    getTicketsDetail();
    getDropdownStatusData();
    print(widget.text);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future getDropdownStatusData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Response response;
    final Dio dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["authorization"] =
        "${sharedPreferences.getString('api_access_token')}";
    response = await dio
        .post('http://49.248.144.235/lv/servolutions/api/get_temp_status');

    if (response.data['status'] == true) {
      print(response.data['data'].runtimeType);
    }
  }

  Future getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userId = sharedPreferences.getInt('user_id')!;
    print(userId);
  }

  Future getTicketsDetail() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Response response;
    final Dio dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["authorization"] =
        "${sharedPreferences.getString('api_access_token')}";
    response = await dio.post(
        'http://49.248.144.235/lv/servolutions/api/get_ticket_details',
        queryParameters: {
          'ticket_id': widget.text,
        });
    if (response.data['status'] == true) {
      print(response.data['filepath']);
      setState(() {
        commentData = response.data['data']['login_user_comment'];
        filePath = response.data['filepath'];
      });
    }
  }

  /*  _imgFromGallery() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    print("Image picker file path - ${pickedFile!.path}");

    setState(() {
      _imageFileList = pickedFile;
    });
    print(_imageFileList);
  } */
  Future<void> chooseImage() async {
    final XFile? choosedimage =
        await _picker.pickImage(source: ImageSource.gallery);
    //set source: ImageSource.camera to get image from camera
    setState(() {
      uploadimage = File(choosedimage!.path);
    });

    print(uploadimage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const TicketList())),
          ),
          backgroundColor: const Color(0xfffcb913),
          iconTheme: const IconThemeData(color: Colors.black),
          title: Center(
              child: Text(
            "CHAT VIEW",
            style: GoogleFonts.poppins(fontSize: 20.0, color: Colors.black),
          )),
        ),
        body: Column(children: <Widget>[
          Expanded(
            child: ListView.builder(
                physics: const PageScrollPhysics(),
                itemCount: commentData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: const EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 0.0),
                    child: commentData[index]['fk_user_id'] != userId
                        ? Stack(
                            alignment: Alignment.topLeft,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    5.0, 5.0, 10.0, 5.0),
                                child: Text(
                                    commentData[index]['user']['name'] +
                                        ' - ' +
                                        DateFormat('dd-MMM-yy').format(
                                            DateTime.parse(commentData[index]
                                                ['created_at'])),
                                    textAlign: TextAlign.left,
                                    style: Styles.appSmallNormalText),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 20.0, 20.0, 0.0),
                                child: Container(
                                    height: 35.0,
                                    width: 100.0,
                                    decoration: BoxDecoration(
                                      color: Colors.black26,
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    child: Center(
                                        child: Text(
                                            commentData[index]['comment'],
                                            textAlign: TextAlign.center,
                                            softWrap: false,
                                            maxLines: 5,
                                            overflow: TextOverflow.ellipsis,
                                            style: Styles.appNormalChatText))),
                              )
                            ],
                          )
                        : commentData[index]['api_documents'] != null &&
                                commentData[index]['api_documents']
                                        ['file_extension'] ==
                                    'jpg'
                            ? Stack(
                                alignment: Alignment.topRight,
                                children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20.0, 5.0, 5.0, 5.0),
                                      child: Text(
                                          commentData[index]['user']['name'] +
                                              ' - ' +
                                              DateFormat('dd-MMM-yy').format(
                                                  DateTime.parse(
                                                      commentData[index]
                                                          ['created_at'])),
                                          textAlign: TextAlign.right,
                                          style: Styles.appSmallNormalText)),
                                  commentData[index]['comment'] != "no_comment"
                                      ? Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20.0, 20.0, 5.0, 5.0),
                                          child: Container(
                                            height: 30.0,
                                            width: 80.0,
                                            decoration: BoxDecoration(
                                              color: Colors.black12,
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                            ),
                                            child: Center(
                                                child: Text(
                                                    commentData[index]
                                                        ['comment'],
                                                    textAlign: TextAlign.center,
                                                    softWrap: false,
                                                    maxLines: 5,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Styles
                                                        .appNormalChatText)),
                                          ))
                                      : const SizedBox(),
                                  Padding(
                                    padding: commentData[index]['comment'] !=
                                            "no_comment"
                                        ? const EdgeInsets.fromLTRB(
                                            20.0, 55.0, 5.0, 5.0)
                                        : const EdgeInsets.fromLTRB(
                                            20.0, 25.0, 5.0, 5.0),
                                    child: Image.network(
                                        filePath +
                                            '/' +
                                            commentData[index]['api_documents']
                                                ['file_name'],
                                        fit: BoxFit.fill,
                                        height: 100,
                                        width: 150),
                                  )
                                ],
                              )
                            : commentData[index]['comment'] != "no_comment"
                                ? Stack(
                                    alignment: Alignment.topRight,
                                    children: <Widget>[
                                        Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                20.0, 5.0, 5.0, 5.0),
                                            child: Text(
                                                commentData[index]['user']
                                                        ['name'] +
                                                    ' - ' +
                                                    DateFormat('dd-MMM-yy')
                                                        .format(DateTime.parse(
                                                            commentData[index][
                                                                'created_at'])),
                                                textAlign: TextAlign.right,
                                                style:
                                                    Styles.appSmallNormalText)),
                                        Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                20.0, 20.0, 5.0, 5.0),
                                            child: Container(
                                              height: 30.0,
                                              width: 80.0,
                                              decoration: BoxDecoration(
                                                color: Colors.black12,
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                              ),
                                              child: Center(
                                                  child: Text(
                                                      commentData[index]
                                                          ['comment'],
                                                      textAlign:
                                                          TextAlign.center,
                                                      softWrap: false,
                                                      maxLines: 5,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Styles
                                                          .appNormalChatText)),
                                            )),
                                      ])
                                : const SizedBox(),
                  );
                }),
          ),
          new Expanded(
              child: new SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.fromLTRB(5.0, 100.0, 230.0, 5.0),
                  child: Text('Upload Refernce',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: 14.0,
                          color: Colors.black)),
                ),
                RaisedButton.icon(
                  onPressed: () {
                    chooseImage(); // call choose image function
                  },
                  icon: const Icon(Icons.folder_open),
                  label: const Text("CHOOSE IMAGE"),
                  color: Colors.deepOrangeAccent,
                  colorBrightness: Brightness.dark,
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(5.0, 5.0, 230.0, 5.0),
                  child: Text('Select Status',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: 14.0,
                          color: Colors.black)),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 5.0, 00.0, 0.0),
                  child: CheckboxListTile(
                    value: checkboxValue,
                    onChanged: (val) {
                      if (checkboxValue == false) {
                        setState(() {
                          checkboxValue = true;
                        });
                      } else if (checkboxValue == true) {
                        setState(() {
                          checkboxValue = false;
                        });
                      }
                    },
                    title: const Text(
                      'Temporary Close',
                      style: Styles.appNormalChatText,
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: const Color(0xfffcb913),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: TextFormField(
                    controller: messageController,
                    style: Styles.googleFontGrey,
                    cursorColor: Theme.of(context).cursorColor,
                    maxLength: 50,
                    textAlign: TextAlign.start,
                    decoration: const InputDecoration(
                      labelText: 'Message',
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
                  padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
                  child: InkWell(
                    onTap: () async {
                      if (messageController.text == '') {
                        print(checkboxValue.runtimeType);
                        final snackBar = SnackBar(
                          content: Text('Please fill any one option',
                              style: GoogleFonts.poppins(
                                  fontSize: 12.0, color: Colors.black)),
                          backgroundColor: (const Color(0xfffcb913)),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        String message = messageController.text;
                        String status = '';
                        String filepath = '';
                        if (checkboxValue == true) {
                          status = '6';
                        } else {
                          status = '';
                        }
                        // ignore: unrelated_type_equality_checks
                        if (uploadimage == '') {
                          filePath = '';
                        } else {
                          List<int> imageBytes = uploadimage.readAsBytesSync();
                          filePath = base64Encode(imageBytes);
                          print('Image : '+ filepath);
                          /* filePath = uploadimage.path; */
                        }

                        SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        Response response;
                        final Dio dio = Dio();
                        dio.options.headers['content-Type'] =
                            'application/json';
                        dio.options.headers["authorization"] =
                            "${sharedPreferences.getString('api_access_token')}";
                        response = await dio.post(
                            'http://49.248.144.235/lv/servolutions/api/save_chat_details',
                            queryParameters: {
                              'ticket_id': widget.text,
                              'documents': filepath,
                              'comment': message,
                              'status': status
                            });
                        print(response.data.toString());

                        if (response.data['status'] == true) {
                          print(response.data);
                          getTicketsDetail();
                          messageController.text = '';
                          checkboxValue = false;
                        }
                      }
                    },
                    child: Container(
                      height: 30.0,
                      width: 80.0,
                      decoration: BoxDecoration(
                        color: const Color(0xfffcb913),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: const Center(
                        child: Text(
                          'Send',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15.0,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ))
        ]));
  }
}
