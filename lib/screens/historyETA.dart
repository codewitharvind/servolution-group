import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:servolution/utils/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryETA extends StatefulWidget {
  const HistoryETA({Key? key}) : super(key: key);

  @override
  State<HistoryETA> createState() => _HistoryETAState();
}

class _HistoryETAState extends State<HistoryETA> {
  late SharedPreferences sharedPreferences;
  late List<dynamic> dataList;
  int count = 0;

  @override
  void initState() {
    super.initState();
    getHistoryData();
  }

  getHistoryData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    Response response;
    final Dio dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["authorization"] =
        "${sharedPreferences.getString('api_access_token')}";
    response = await dio.post(
        'http://49.248.144.235/lv/servolutions/api/ticket-eta-history',
        queryParameters: {
          'ticket_id': sharedPreferences.getString('ticket'),
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
    return ListView.builder(
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
                          children:  <Widget>[
                            const Padding(
                              padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                              child: Text('ETA Hours',
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
                              child: Text(dataList[index]['eat'].toString() ,
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
                          children:  <Widget>[
                            const Padding(
                              padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                              child: Text('ETA Reason',
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
                              child: Text(dataList[index]['reasons'].toString() ,
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
                        padding: const EdgeInsets.fromLTRB(15.0, 20.0, 10.0, 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              child: Text('ETA Comment',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                      color: Colors.black)),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  0.0, 0.0, 0.0, 0.0),
                              child: Text(dataList[index]['description'].toString() ,
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
                        padding: const EdgeInsets.fromLTRB(15.0, 20.0, 10.0, 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:  <Widget>[
                            const Padding(
                              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              child: Text('Created At',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                      color: Colors.black)),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  0.0, 0.0, 5.0, 0.0),
                              child: Text(dataList[index]['created_at'].toString() ,
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
                  ],
                ),
              ),
            ),
          );
        });
  }
}
