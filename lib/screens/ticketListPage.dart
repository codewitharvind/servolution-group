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
          title: Text(
            "TICKET LIST",
            style: GoogleFonts.poppins(fontSize: 20.0, color: Colors.black),
          ),
        ),
        body: ListView.builder(
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    10.0, 10.0, 5.0, 0.0),
                                child: Text(
                                    '#' +
                                        dataList[index]['ticket_number']
                                            .toString(),
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
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
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    10.0, 5.0, 0.0, 0.0),
                                child: Text(
                                  dataList[index]['created_at'],
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
                                    35.0, 5.0, 0.0, 0.0),
                                child: Container(
                                  width: 7,
                                  height: 7,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        dataList[index]['status_name'] == "Open"
                                            ? Colors.green
                                            : const Color(0xfffcb913),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    10.0, 5.0, 0.0, 0.0),
                                child: Text(
                                  dataList[index]['status_name'] ?? '',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14.0,
                                      color: dataList[index]['status_name'] ==
                                              "Open"
                                          ? Colors.green
                                          : const Color(0xfffcb913)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                          child: Container(
                            height: 30.0,
                            decoration: const BoxDecoration(
                              color: Color(0xfffcb913),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15.0),
                                bottomRight: Radius.circular(15.0),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      30.0, 5.0, 0.0, 0.0),
                                  child: Text(
                                    'ATM No. ' + dataList[index]['atm_no'],
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                const VerticalDivider(
                                  thickness: 2,
                                  width: 20,
                                  color: Colors.black,
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0.0, 5.0, 40.0, 0.0),
                                  child: Text(
                                    'Site ID: ' + dataList[index]['site_id'],
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
