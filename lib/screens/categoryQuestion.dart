// ignore_for_file: unnecessary_const

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servolution/screens/subCategoryList.dart';
import 'package:servolution/utils/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryQuestion extends StatefulWidget {
  const CategoryQuestion({Key? key}) : super(key: key);

  @override
  State<CategoryQuestion> createState() => _CategoryQuestionState();
}

class _CategoryQuestionState extends State<CategoryQuestion> {
  late SharedPreferences sharedPreferences;
  late List<dynamic> dataList;
  int count = 0;

  @override
  void initState() {
    super.initState();
    getCategoryQuestion();
  }

  getCategoryQuestion() async {
    sharedPreferences = await SharedPreferences.getInstance();
    Response response;
    final Dio dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["authorization"] =
        "${sharedPreferences.getString('api_access_token')}";
    response = await dio.post(
        'http://49.248.144.235/lv/servolutions/api/get-categories-questions',
        queryParameters: {
          'category_id': sharedPreferences.getString('category'),
          'sub_category_id': sharedPreferences.getString('subCategory'),
          'micro_category_id': sharedPreferences.getString('microcategory'),
        });
    if (response.data['status'] == true) {
      print(response.data['data']);
      setState(() {
        dataList = response.data['data'];
        count = dataList.length;
      });
    }
  }

  submitCategoryAnswer(answer, questionId) async {
    sharedPreferences = await SharedPreferences.getInstance();
    Response response;
    final Dio dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["authorization"] =
        "${sharedPreferences.getString('api_access_token')}";
    response = await dio.post(
        'http://49.248.144.235/lv/servolutions/api/save-questions-answer',
        data: {
          'fk_ticket_id': sharedPreferences.getString('ticket'),
          'fk_service_id': sharedPreferences.getString('service'),
          'fk_category_id': sharedPreferences.getString('category'),
          'fk_sub_category_id': sharedPreferences.getString('subCategory'),
          'fk_micro_category_id': sharedPreferences.getString('microcategory'),
          'question_id ': questionId,
          'answer': answer == 'Yes' ? 1 : 0
        });
    if (response.data['status'] == true) {
      final snackBar = SnackBar(
        content: Text(response.data['message'],
            style: GoogleFonts.poppins(fontSize: 12.0, color: Colors.white)),
        backgroundColor: (const Color(0xfffcb913)),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      print(response);
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
          onPressed: () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const SubCategoryList())),
        ),
        backgroundColor: const Color(0xfffcb913),
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "CATEGORY QUESTION LIST",
          style: GoogleFonts.poppins(fontSize: 20.0, color: Colors.black),
        ),
      ),
      body: /* ListView.builder(
        physics: const PageScrollPhysics(),
        itemCount: count,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0),
            child: Card(
              elevation: 9,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 7,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                10.0, 10.0, 5.0, 10.0),
                            child: Text(dataList[index]['question'].toString(),
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14.0,
                                    color: Colors.black)),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 5.0),
                          child: InkWell(
                            onTap: () {
                              submitCategoryAnswer(
                                  'Yes', dataList[index]['question_id']);
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const <Widget>[
                                  Center(
                                    child: Text(
                                      'Yes',
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
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(5.0, 10.0, 10.0, 5.0),
                          child: InkWell(
                            onTap: () {
                              submitCategoryAnswer(
                                  'No', dataList[index]['question_id']);
                            },
                            child: Container(
                              height: 30.0,
                              width: 70.0,
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
                                      'No',
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ), */
          Container(
        padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        child: Card(
          elevation: 3,
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
                        Expanded(
                          flex: 7,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                10.0, 10.0, 5.0, 10.0),
                            child: Text(dataList[index]['question'].toString(),
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14.0,
                                    color: Colors.black)),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 5.0),
                          child: InkWell(
                            onTap: () {
                              submitCategoryAnswer(
                                  'Yes', dataList[index]['question_id']);
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const <Widget>[
                                  Center(
                                    child: Text(
                                      'Yes',
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
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(5.0, 10.0, 10.0, 5.0),
                          child: InkWell(
                            onTap: () {
                              submitCategoryAnswer(
                                  'No', dataList[index]['question_id']);
                            },
                            child: Container(
                              height: 30.0,
                              width: 70.0,
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
                                      'No',
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
