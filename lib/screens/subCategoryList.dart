import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servolution/screens/categoryList.dart';
import 'package:servolution/screens/categoryQuestion.dart';
import 'package:servolution/screens/microCategory.dart';
import 'package:servolution/utils/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubCategoryList extends StatefulWidget {
  const SubCategoryList({
    Key? key,
  }) : super(key: key);

  @override
  State<SubCategoryList> createState() => _SubCategoryListState();
}

class _SubCategoryListState extends State<SubCategoryList> {
  late SharedPreferences sharedPreferences;
  late List<dynamic> dataList;
  int count = 0;
  int flag = 0;

  @override
  void initState() {
    super.initState();
    getSubCategory();
  }

  getSubCategory() async {
    sharedPreferences = await SharedPreferences.getInstance();
    Response response;
    final Dio dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["authorization"] =
        "${sharedPreferences.getString('api_access_token')}";
    response = await dio.post(
        'http://49.248.144.235/lv/servolutions/api/get-sub-categories',
        queryParameters: {
          'category_id': sharedPreferences.getString('category'),
        });
    if (response.data['status'] == true) {
      print(response.data['data']);
      setState(() {
        dataList = response.data['data'];
        count = dataList.length;
        flag = response.data['flag'];
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
            onPressed: () async => {
                  sharedPreferences = await SharedPreferences.getInstance(),
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CategoryList(
                              text: sharedPreferences
                                  .getString('ticket')
                                  .toString(),
                              service: sharedPreferences
                                  .getString('service')
                                  .toString()))),
                }),
        backgroundColor: const Color(0xfffcb913),
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "SUB-CATEGORY LIST",
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
                      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 5.0),
                      child: InkWell(
                        onTap: () async {
                          sharedPreferences =
                              await SharedPreferences.getInstance();
                          await sharedPreferences.setString('subCategory',
                              dataList[index]['sub_category_id'].toString());
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => flag == 1
                                      ? const MicroCategory()
                                      : const CategoryQuestion()));
                        },
                        child: Text(
                          dataList[index]['sub_category_name'].toString(),
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
            )),
      ),
    );
  }
}
