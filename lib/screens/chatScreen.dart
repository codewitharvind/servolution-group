import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servolution/screens/chatImage.dart';
import 'package:servolution/screens/fileDownload.dart';
import 'package:servolution/screens/ticketListPage.dart';
import 'package:servolution/utils/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class ChatScreen extends StatefulWidget {
  final String text;
  const ChatScreen({Key? key, required this.text}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  List<dynamic>? commentData;
  String? filePath, selectedFilePath;
  int userId = 0;
  bool checkboxValue = false;
  File? selectedfile;
  FormData? formdata;

  @override
  void initState() {
    super.initState();
    commentData = [];
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
      print(response.data['data']['login_user_comment']);
      setState(() {
        commentData = response.data['data']['login_user_comment'];
        filePath = response.data['filepath'];
      });
    }
  }

  getFileChoosen() async {
    FilePickerResult? selectedfile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc'],
    );
    if (selectedfile != null) {
      print('*************');
      print(selectedfile.files.single.path);
      print('*************');
      setState(() {
        selectedFilePath = selectedfile.files.single.path;
      });
    }
  }

  getFileDownload(fileUrl) async {
    final taskId = await FlutterDownloader.enqueue(
      url: fileUrl,
      savedDir: '/storage/emulated/0/',
      showNotification: true,
      openFileFromNotification: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) =>  TicketList(""))),
        ),
        backgroundColor: const Color(0xfffcb913),
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text(
          "CHAT VIEW",
          style: GoogleFonts.poppins(fontSize: 20.0, color: Colors.black),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              physics: const PageScrollPhysics(),
              itemCount: commentData?.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: const EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 0.0),
                  child: commentData![index]['fk_user_id'] != userId &&
                          commentData![index]['comment'] != ''
                      ? Stack(
                          alignment: Alignment.topLeft,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  5.0, 5.0, 10.0, 5.0),
                              child: Text(commentData![index]['user']['name'],
                                  textAlign: TextAlign.left,
                                  style: Styles.appSmallBoldText),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  5.0, 20.0, 10.0, 5.0),
                              child: Text(
                                  DateFormat('dd MMM yyyy - hh:mm a').format(
                                      DateTime.parse(
                                          commentData![index]['created_at'])),
                                  textAlign: TextAlign.left,
                                  style: Styles.appSmallText),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  0.0, 35.0, 0.0, 0.0),
                              child: BubbleNormal(
                                text: commentData![index]['comment'],
                                isSender: false,
                                color: const Color(0xfffcb913),
                                tail: true,
                                textStyle: Styles.appNormalChatText,
                              ),
                            ),
                          ],
                        )
                      : commentData![index]['api_documents'] != null &&
                              commentData![index]['comment'] != ''
                          ? Stack(
                              alignment: Alignment.topRight,
                              children: <Widget>[
                                Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20.0, 5.0, 5.0, 5.0),
                                    child: Text(
                                        commentData![index]['user']['name'],
                                        textAlign: TextAlign.right,
                                        style: Styles.appSmallBoldText)),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      20.0, 20.0, 5.0, 5.0),
                                  child: Text(
                                      DateFormat('dd MMM yyyy - hh:mm a')
                                          .format(DateTime.parse(
                                              commentData![index]
                                                  ['created_at'])),
                                      textAlign: TextAlign.right,
                                      style: Styles.appSmallText),
                                ),
                                commentData![index]['comment'] != "no_comment"
                                    ? Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20.0, 35.0, 5.0, 5.0),
                                        child: BubbleNormal(
                                          text: commentData![index]['comment'],
                                          isSender: true,
                                          color: Colors.black26,
                                          tail: true,
                                          textStyle: Styles.appNormalChatText,
                                        ),
                                      )
                                    : const SizedBox(),
                                commentData![index]['api_documents']
                                            ['file_extension'] ==
                                        'jpg'
                                    ? Padding(
                                        padding: commentData![index]
                                                    ['comment'] !=
                                                "no_comment"
                                            ? const EdgeInsets.fromLTRB(
                                                20.0, 70.0, 5.0, 5.0)
                                            : const EdgeInsets.fromLTRB(
                                                20.0, 35.0, 5.0, 5.0),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ChatImage(
                                                    text: filePath! +
                                                        '/' +
                                                        commentData![index][
                                                                'api_documents']
                                                            ['file_name'],
                                                    id: widget.text),
                                              ),
                                            );
                                          },
                                          child: Image.network(
                                              filePath! +
                                                  '/' +
                                                  commentData![index]
                                                          ['api_documents']
                                                      ['file_name'],
                                              fit: BoxFit.fill,
                                              height: 100,
                                              width: 150),
                                        ),
                                      )
                                    : Padding(
                                        padding: commentData![index]
                                                    ['comment'] !=
                                                "no_comment"
                                            ? const EdgeInsets.fromLTRB(
                                                20.0, 70.0, 5.0, 5.0)
                                            : const EdgeInsets.fromLTRB(
                                                20.0, 35.0, 5.0, 5.0),
                                        child: InkWell(
                                          onTap: () async {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => FileDownload(
                                                    text: filePath! +
                                                        '/' +
                                                        commentData![index][
                                                                'api_documents']
                                                            ['file_name'],
                                                    id: widget.text),
                                              ),
                                            );
                                          },
                                          child: BubbleNormal(
                                            text: commentData![index]
                                                ['api_documents']['file_name'],
                                            isSender: true,
                                            color: Colors.black26,
                                            tail: true,
                                            textStyle: Styles.appNormalChatText,
                                          ),
                                        ),
                                      ),
                              ],
                            )
                          : commentData![index]['comment'] != "no_comment" &&
                                  commentData![index]['comment'] != ''
                              ? Stack(
                                  alignment: Alignment.topRight,
                                  children: <Widget>[
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20.0, 5.0, 5.0, 5.0),
                                        child: Text(
                                            commentData![index]['user']['name'],
                                            textAlign: TextAlign.right,
                                            style: Styles.appSmallBoldText)),
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20.0, 20.0, 5.0, 5.0),
                                        child: Text(
                                            DateFormat('dd MMM yyyy - hh:mm a')
                                                .format(
                                              DateTime.parse(commentData![index]
                                                  ['created_at']),
                                            ),
                                            textAlign: TextAlign.right,
                                            style: Styles.appSmallText)),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          00.0, 35.0, 0.0, 5.0),
                                      child: BubbleNormal(
                                        text: commentData![index]['comment'],
                                        isSender: true,
                                        color: Colors.black26,
                                        tail: true,
                                        textStyle: Styles.appNormalChatText,
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                );
              },
            ),
          ),
          Stack(
            alignment: Alignment.bottomLeft,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.fromLTRB(10.0, 50.0, 0.0, 60.0),
                child: Text(
                  'Select Status : ',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      fontSize: 14.0,
                      color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(80.0, 5.0, 00.0, 40.0),
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
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Container(
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: TextField(
                            controller: messageController,
                            style: Styles.googleFontGrey,
                            // ignore: deprecated_member_use
                            cursorColor: Theme.of(context).cursorColor,
                            decoration: const InputDecoration(
                              hintText: 'Type a message',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            getFileChoosen();
                          },
                          child: Icon(Icons.attach_file,
                              size: 30.0, color: Theme.of(context).hintColor),
                        ),
                        const SizedBox(width: 8.0),
                        GestureDetector(
                          onTap: () async {
                            if (messageController.text != '') {
                              String message = messageController.text;
                              String status = '';
                              String filepath = '';
                              if (checkboxValue == true) {
                                status = '6';
                              } else {
                                status = '';
                              }
                              SharedPreferences sharedPreferences =
                                  await SharedPreferences.getInstance();
                              final Dio dio = Dio();
                              dio.options.headers['content-Type'] =
                                  'application/json';
                              dio.options.headers["authorization"] =
                                  "${sharedPreferences.getString('api_access_token')}";
                              var formData = FormData.fromMap({
                                'ticket_id': widget.text,
                                'comment': messageController.text,
                                'status': status,
                                'documents': await MultipartFile.fromFile(
                                    selectedFilePath.toString(),
                                    filename: selectedFilePath
                                        .toString()
                                        .split('/')
                                        .last)
                              });
                              final response = await dio.post(
                                'http://49.248.144.235/lv/servolutions/api/save_chat_details',
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
                              if (response.data['status'] == true) {
                                print(response);
                                getTicketsDetail();
                                setState(() {
                                  messageController.text = '';
                                  selectedFilePath = '';
                                });
                                final snackBar = SnackBar(
                                  content: Text('Data Uploaded',
                                      style: GoogleFonts.poppins(
                                          fontSize: 12.0, color: Colors.white)),
                                  backgroundColor: (const Color(0xfffcb913)),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            } else {
                              final snackBar = SnackBar(
                                content: Text('Please fill any one option',
                                    style: GoogleFonts.poppins(
                                        fontSize: 12.0, color: Colors.black)),
                                backgroundColor: (const Color(0xfffcb913)),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                          child: const CircleAvatar(
                            child: Icon(Icons.send,
                            color: Colors.black,),
                            backgroundColor: Color(0xfffcb913),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
