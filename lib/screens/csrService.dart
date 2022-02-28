import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:servolution/screens/csrLabels.dart';
import 'package:servolution/screens/csrScreen.dart';
import 'package:servolution/utils/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CSRService extends StatefulWidget {
  const CSRService({Key? key}) : super(key: key);

  @override
  State<CSRService> createState() => _CSRServiceState();
}

class _CSRServiceState extends State<CSRService> {
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
        'http://49.248.144.235/lv/servolutions/api/get-user-csr-listing',
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
              MaterialPageRoute(builder: (context) => const CSRModule())),
        ),
        backgroundColor: const Color(0xfffcb913),
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "CSR SERVICE",
          style: GoogleFonts.poppins(fontSize: 20.0, color: Colors.black),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        child: ListView.builder(
          itemCount: count,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  child: Table(
                    border: TableBorder.all(color: Colors.black),
                    children: [
                      const TableRow(children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                          child: Center(
                            child:
                                Text('ATM ID', style: Styles.appNormalChatText),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                          child: Center(
                            child: Text('Assign Date',
                                style: Styles.appNormalChatText),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                          child: Center(
                            child:
                                Text('Action', style: Styles.appNormalChatText),
                          ),
                        ),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                          child: Center(
                            child: Text(
                              dataList[index]['atm_id'],
                              style: Styles.appSmallNormalText,
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                          child: Center(
                              child: Text(dataList[index]['assign_date'],
                                  style: Styles.appSmallNormalText)),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CSRLabel(
                                    text: dataList[index]['csr_id'].toString(),
                                  ),
                                ),
                              );
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
                      ])
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
