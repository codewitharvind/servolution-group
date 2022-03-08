import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servolution/screens/notificationInfo.dart';
import 'package:servolution/screens/subCategorylist.dart';
import 'package:servolution/screens/ticketDetailPage.dart';
import 'package:servolution/utils/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryList extends StatefulWidget {
  final String text;
  final String service;
  const CategoryList({Key? key, required this.service, required this.text})
      : super(key: key);

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  late SharedPreferences sharedPreferences;
  late List<dynamic> dataList;
  int count = 0;

  @override
  void initState() {
    super.initState();
    getCategory();
  }

  getCategory() async {
    sharedPreferences = await SharedPreferences.getInstance();
    Response response;
    final Dio dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["authorization"] =
        "${sharedPreferences.getString('api_access_token')}";
    response = await dio.post(
        'http://49.248.144.235/lv/servolutions/api/get-service-categories',
        queryParameters: {
          'service_id': widget.service,
        });
    if (response.data['status'] == true) {
      print(response.data['data']);
      setState(() {
        dataList = response.data['data'];
        count = dataList.length;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => TicketDetail(
                        text: widget.text,
                      ))),
        ),
        backgroundColor: const Color(0xfffcb913),
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "CATEGORY LIST",
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
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 5.0),
                    child: InkWell(
                      onTap: () async {
                        sharedPreferences =
                            await SharedPreferences.getInstance();
                        await sharedPreferences.setString('category',
                            dataList[index]['category_id'].toString());
                        await sharedPreferences.setString(
                            'service', widget.service);
                        await sharedPreferences.setString(
                            'ticket', widget.text);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SubCategoryList()));
                      },
                      child: Text(
                        dataList[index]['category_name'].toString(),
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 15.0,
                            color: Colors.black),
                      ),
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
