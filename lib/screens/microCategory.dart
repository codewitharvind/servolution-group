import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servolution/screens/categoryQuestion.dart';
import 'package:servolution/screens/subCategorylist.dart';
import 'package:servolution/utils/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MicroCategory extends StatefulWidget {
  const MicroCategory({Key? key}) : super(key: key);

  @override
  State<MicroCategory> createState() => _MicroCategoryState();
}

class _MicroCategoryState extends State<MicroCategory> {
  late SharedPreferences sharedPreferences;
  late List<dynamic> dataList;
  int count = 0;

  @override
  void initState() {
    super.initState();
    getMicroCategory();
  }

  getMicroCategory() async {
    sharedPreferences = await SharedPreferences.getInstance();
    Response response;
    final Dio dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["authorization"] =
        "${sharedPreferences.getString('api_access_token')}";
    response = await dio.post(
        'http://49.248.144.235/lv/servolutions/api/get-micro-categories',
        queryParameters: {
          'sub_category_id': sharedPreferences.getString('subCategory'),
        });
    if (response.data['status'] == true) {
      print(response.data['data']);
      print(sharedPreferences.getString('subCategory'));
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
                    builder: (context) => const SubCategoryList()))),
        backgroundColor: const Color(0xfffcb913),
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "MICRO CATEGORY LIST",
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
                        await sharedPreferences.setString('microcategory',
                            dataList[index]['micro_category_id'].toString());
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const CategoryQuestion()));
                      },
                      child: Text(
                        dataList[index]['micro_category_name'].toString(),
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
