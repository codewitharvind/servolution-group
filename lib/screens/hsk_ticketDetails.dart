// ignore_for_file: unnecessary_const

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servolution/screens/categoryList.dart';
import 'package:servolution/screens/chatScreen.dart';
import 'package:servolution/screens/ticketListPage.dart';
import 'package:servolution/utils/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class hsk_TicketDetail extends StatefulWidget {
  String text;
  hsk_TicketDetail({Key? key, required this.text}) : super(key: key);

  _hsk_TicketDetailState createState() => _hsk_TicketDetailState();
}

class _hsk_TicketDetailState extends State<hsk_TicketDetail> {
  late SharedPreferences sharedPreferences;
  late List<dynamic> commentData;
  late List<dynamic> dataList;
  int count = 0;
  late String ticketNumber = '',
      atmNumber = '',
      atmSerialNumber = '',
      atmSiteId = '',
      location = '',
      executiveName = '',
      executiveNumber = '',
      status = '',
      serviceName = '',
      filePath = '',
      errorTypes = '';
  @override
  void initState() {
    super.initState();
    getTicketsDetail();
    getCategoryDetail();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getTicketsDetail() async {
    sharedPreferences = await SharedPreferences.getInstance();
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
      setState(() {
        ticketNumber = response.data['data']['ticket']['ticket_number'];
        atmNumber = response.data['data']['ticket']['atm_no'];
        atmSerialNumber = response.data['data']['ticket']['atm_sr_no'];
        atmSiteId = response.data['data']['ticket']['site_id'];
        location = response.data['data']['ticket']['location'];
        executiveName = response.data['data']['ticket']['executive_name'];
        executiveNumber = response.data['data']['ticket']['executive_number'];
        status = response.data['data']['ticket']['status_name'];
        filePath = response.data['filepath'];
        serviceName = response.data['data']['ticket_errors'].length != 0
            ? response.data['data']['ticket_errors'][0]['service_name']
            : '-';
        errorTypes = response.data['data']['ticket_errors'].length != 0
            ? response.data['data']['ticket_errors'][0]['error_type']
            : '-';
      });
    }
  }

  getCategoryDetail() async {
    print("response");
    sharedPreferences = await SharedPreferences.getInstance();
    Response response;
    final Dio dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["authorization"] = "${sharedPreferences.getString('api_access_token')}";
    response = await dio.post(
        'http://49.248.144.235/lv/servolutions/api/get-service-categories');
    print(response);
    if (response.data['status'] == true) {
      setState(() {
        dataList = response.data['data'];
        count = response.data['data'].length;
      });
      print("@@@@@@@@@@@");
      print(response.data['data']);
      print("@@@@@@@@@@@");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => TicketList(""))),
        ),
        backgroundColor: const Color(0xfffcb913),
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text(
          "TICKET DETAIL",
          style: GoogleFonts.poppins(fontSize: 20.0, color: Colors.black),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: InkWell(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                              child: Text('Ticket Number',
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                      color: Colors.black)),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  0.0, 0.0, 10.0, 0.0),
                              child: Text('#' + ticketNumber,
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
                        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                              child: Text('ATM Number',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                      color: Colors.black)),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 0.0, 10.0, 0.0),
                                child: Text(atmNumber,
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.0,
                                        color: Colors.black)),
                              ),
                            )
                          ],
                        ),
                      ),
                      Styles.appHorizontalDivider,
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                              child: const Text('ATM Serial Number',
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                      color: Colors.black)),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  0.0, 0.0, 10.0, 0.0),
                              child: Text(atmSerialNumber,
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
                        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                              child: Text('ATM Site ID',
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
                              child: Text(atmSiteId,
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
                        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 0.0, 0.0, 0.0),
                              child: const Text('Location',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                      color: Colors.black)),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 0.0, 10.0, 0.0),
                                child: Text(location,
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.0,
                                        color: Colors.black)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Styles.appHorizontalDivider,
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 0.0, 0.0, 0.0),
                              child: const Text('Executive Name',
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
                              child: Text(executiveName,
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
                        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 0.0, 0.0, 0.0),
                              child: const Text('Executive Number',
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
                              child: Text(executiveNumber,
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
                        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 0.0, 0.0, 0.0),
                              child: const Text('Status',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                      color: Colors.black)),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 0.0, 10.0, 0.0),
                                child: Text(status,
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.0,
                                        color: Colors.black)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Styles.appHorizontalDivider,
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 0.0, 0.0, 0.0),
                              child: const Text('Service Name',
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
                              child: Text(serviceName,
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
                        padding:
                        const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 0.0, 0.0, 0.0),
                              child: const Text('Error Types',
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
                              child: Text(errorTypes,
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
              Column(
                children: [
                  for (var service
                  in dataList) /* Text(service['service_name'].toString() */
                    Container(
                      padding:
                      const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0),
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
                                    builder: (context) => CategoryList(
                                        text: service['id'], service: '',)));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 0.0, 0.0, 0.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10.0, 10.0, 5.0, 0.0),
                                      child: Text( service['service_name']
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
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 20.0, 180.0, 5.0),
                child: InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ChatScreen(text: widget.text)));
                  },
                  child: Container(
                    height: 30.0,
                    width: 210.0,
                    decoration: BoxDecoration(
                      color: const Color(0xfffcb913),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const <Widget>[
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          child: Icon(Icons.chat_bubble),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                          child: Center(
                            child: Text(
                              'CHAT NOW!',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 15.0,
                                  color: Colors.black),
                            ),
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
      ),
    );
  }
}
