// ignore_for_file: deprecated_member_use

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servolution/screens/ticketListPage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  final String text;
  const ChatScreen({Key? key, required this.text}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late XFile _imageFileList;
  late List<dynamic> commentData;
  final ImagePicker _picker = ImagePicker();
  int userId = 0;
  @override
  void initState() {
    super.initState();
    getUserData();
    getTicketsDetail();
    print(widget.text);
  }

  @override
  void dispose() {
    super.dispose();
  }

  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userId = sharedPreferences.getInt('user_id')!;
    print(userId);
  }

  getTicketsDetail() async {
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
        commentData = response.data['data']['comments_and_files'];
      });
    }
  }

  _imgFromGallery() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    print("Image picker file path - ${pickedFile!.path}");

    // getting a directory path for saving

// copy the file to a new path

    setState(() {
      _imageFileList = pickedFile;
    });
    print(_imageFileList);
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
      body: /* Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            OutlineButton(
              onPressed: _imgFromGallery,
              child: const Text('Choose Image'),
            ),
            const SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ), */
          ListView.builder(
              physics: const PageScrollPhysics(),
              itemCount: commentData.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: const EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            commentData[index]['fk_user_id'] != userId
                                ? Expanded(
                                    child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10.0, 10.0, 80.0, 5.0),
                                    child: Text(
                                        '#' +
                                            commentData[index]['comment']
                                                .toString(),
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w900,
                                            fontSize: 18.0,
                                            color: Colors.black)),
                                  ))
                                : Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        300.0, 10.0, 5.0, 5.0),
                                    child: Text(
                                        commentData[index]['comment']
                                            .toString(),
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w900,
                                            fontSize: 18.0,
                                            color: Colors.black)),
                                  ),
                            /*  Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    300.0, 10.0, 5.0, 5.0),
                                child: Image.network(
                                    'https://images.unsplash.com/photo-1453728013993-6d66e9c9123a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8dmlld3xlbnwwfHwwfHw%3D&w=1000&q=80'),
                              ), */
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
    );
  }
}
