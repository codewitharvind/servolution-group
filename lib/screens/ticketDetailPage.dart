// ignore_for_file: unnecessary_const

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servolution/screens/chatScreen.dart';
import 'package:servolution/screens/ticketListPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TicketDetail extends StatefulWidget {
  final String text;
  const TicketDetail({Key? key, required this.text}) : super(key: key);

  @override
  _TicketDetailState createState() => _TicketDetailState();
}

class _TicketDetailState extends State<TicketDetail> {
  late SharedPreferences sharedPreferences;
  late List<dynamic> commentData;
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
      print(response.data['filepath'].runtimeType);
      setState(() {
        ticketNumber = response.data['data']['ticket']['ticket_number'];
        atmNumber = response.data['data']['ticket']['atm_no'];
        atmSerialNumber = response.data['data']['ticket']['atm_sr_no'];
        atmSiteId = response.data['data']['ticket']['site_id'];
        location = response.data['data']['ticket']['location'];
        executiveName = response.data['data']['ticket']['executive_name'];
        executiveNumber = response.data['data']['ticket']['executive_number'];
        status = response.data['data']['ticket']['status'];
        commentData = response.data['data']['comments_and_files'];
        filePath = response.data['filepath'];
        serviceName = response.data['data']['ticket_errors'].length != 0
            ? response.data['data']['ticket_errors'][0]['service_name']
            : '-';
        errorTypes = response.data['data']['ticket_errors'].length != 0
            ? response.data['data']['ticket_errors'][0]['error_type']
            : '-';
      });
      print(commentData.runtimeType);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const TicketList())),
        ),
        backgroundColor: const Color(0xfffcb913),
        iconTheme: const IconThemeData(color: Colors.black),
        title: Center(
            child: Text(
          "TICKET DETAIL",
          style: GoogleFonts.poppins(fontSize: 20.0, color: Colors.black),
        )),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 0.0),
        child: Column(
          children: <Widget>[
            Card(
              elevation: 9,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: InkWell(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 5.0),
                            child: Text('Ticket Number',
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                    color: Colors.black)),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                130.0, 10.0, 5.0, 5.0),
                            child: Text('#' + ticketNumber,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16.0,
                                    color: Colors.black)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 9,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: InkWell(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 5.0),
                            child: Text('ATM Number',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                    color: Colors.black)),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                145.0, 10.0, 5.0, 5.0),
                            child: Text(atmNumber,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16.0,
                                    color: Colors.black)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 9,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: InkWell(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 5.0),
                            child: const Text('ATM Serial Number',
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                    color: Colors.black)),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                105.0, 10.0, 5.0, 5.0),
                            child: Text(atmSerialNumber,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16.0,
                                    color: Colors.black)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 9,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: InkWell(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 5.0),
                            child: Text('ATM Site ID',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                    color: Colors.black)),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                160.0, 10.0, 5.0, 5.0),
                            child: Text(atmSiteId,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16.0,
                                    color: Colors.black)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 9,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: InkWell(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const Padding(
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 5.0),
                            child: const Text('Location',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                    color: Colors.black)),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                170.0, 10.0, 5.0, 5.0),
                            child: Text(location,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16.0,
                                    color: Colors.black)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 9,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: InkWell(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const Padding(
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 5.0),
                            child: const Text('Executive Name',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                    color: Colors.black)),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(85.0, 10.0, 5.0, 5.0),
                            child: Text(executiveName,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16.0,
                                    color: Colors.black)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 9,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: InkWell(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const Padding(
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 5.0),
                            child: const Text('Executive Number',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                    color: Colors.black)),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(90.0, 10.0, 5.0, 5.0),
                            child: Text(executiveNumber,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16.0,
                                    color: Colors.black)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 9,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: InkWell(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const Padding(
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 5.0),
                            child: const Text('Status',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                    color: Colors.black)),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                230.0, 10.0, 5.0, 5.0),
                            child: Text(status,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16.0,
                                    color: Colors.black)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 9,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: InkWell(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const Padding(
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 5.0),
                            child: const Text('Service Name',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                    color: Colors.black)),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                160.0, 10.0, 5.0, 5.0),
                            child: Text(serviceName,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16.0,
                                    color: Colors.black)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 9,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: InkWell(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const Padding(
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 5.0),
                            child: const Text('Error Types',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                    color: Colors.black)),
                          ),
                          errorTypes == '-'
                              ? Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      200.0, 10.0, 5.0, 5.0),
                                  child: Text(errorTypes,
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16.0,
                                          color: Colors.black)),
                                )
                              : Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      50.0, 10.0, 5.0, 5.0),
                                  child: Text(errorTypes,
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16.0,
                                          color: Colors.black)),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
              child: InkWell(
                onTap: () async {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ChatScreen(text: widget.text)));
                },
                child: Container(
                  height: 30.0,
                  decoration: BoxDecoration(
                    color: const Color(0xfffcb913),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: const Center(
                    child: Text(
                      'Chat',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15.0,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
