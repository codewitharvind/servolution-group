import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servolution/screens/dashboard.dart';
import 'package:servolution/screens/ticketDetailPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TicketList extends StatefulWidget {
  const TicketList({Key? key}) : super(key: key);

  @override
  _TicketListState createState() => _TicketListState();
}

class _TicketListState extends State<TicketList> {
  int offSet = 0, limit = 10, count = 0;
  late List<dynamic> dataList;
  late SharedPreferences sharedPreferences;
  @override
  void initState() {
    super.initState();
    getTicketsInfo(offSet, limit);
  }

  @override
  void dispose() {
    super.dispose();
  }

  getTicketsInfo(int offSet, int limit) async {
    sharedPreferences = await SharedPreferences.getInstance();
    Response response;
    final Dio dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["authorization"] =
        "${sharedPreferences.getString('api_access_token')}";
    response = await dio.post(
        'http://49.248.144.235/lv/servolutions/api/get_assigned_tickets',
        queryParameters: {
          'user_id': sharedPreferences.getInt('user_id'),
          "limit": limit,
          "offset": offSet
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
          title: Center(
              child: Text(
            "TICKET LIST",
            style: GoogleFonts.poppins(fontSize: 20.0, color: Colors.black),
          )),
        ),
        body: ListView.builder(
            physics: const PageScrollPhysics(),
            itemCount: count,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: const EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 0.0),
                child: Card(
                  elevation: 9,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TicketDetail(
                                  text: dataList[index]['ticket_number'])));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    10.0, 10.0, 5.0, 5.0),
                                child: Text(
                                    '#' +
                                        dataList[index]['ticket_number']
                                            .toString(),
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w900,
                                        fontSize: 18.0,
                                        color: Colors.black)),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Padding(
                                padding:
                                    EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 0.0),
                                child: Text(
                                  'ATM No. / Site ID',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.0,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    140.0, 0.0, 0.0, 0.0),
                                child: Container(
                                  height: 35.0,
                                  width: 80.0,
                                  decoration: BoxDecoration(
                                    color: const Color(0xfffcb913),
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      dataList[index]['status_name'] ?? '',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 12.0,
                                          color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    10.0, 5.0, 0.0, 10.0),
                                child: Text(
                                  dataList[index]['atm_no'] +
                                      ' / ' +
                                      dataList[index]['site_id'],
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.0,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    100.0, 5.0, 0.0, 10.0),
                                child: Text(
                                  dataList[index]['created_at'],
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 12.0,
                                    color: Colors.grey,
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
            }));
  }
}
