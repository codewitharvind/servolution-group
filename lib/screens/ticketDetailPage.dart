// ignore_for_file: unnecessary_const, unnecessary_new, deprecated_member_use

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servolution/screens/categoryList.dart';
import 'package:servolution/screens/chatScreen.dart';
import 'package:servolution/screens/etaTabbar.dart';
import 'package:servolution/screens/ticketListPage.dart';
import 'package:servolution/utils/styles.dart';
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
  late List<dynamic> dataList;
  int count = 0;
  late String ticketNumber = '',
      atmNumber = '',
      atmSerialNumber = '',
      atmSiteId = '',
      location = '',
      docketNumber = '',
      portalDocketNumber = '',
      status = '',
      serviceName = '',
      filePath = '',
      errorTypes = '',
      serviceId = '',
      ticketId = '',
      comment = '',
      tat = '';
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
      setState(() {
        ticketId = response.data['data']['ticket']['id'].toString();
        ticketNumber = response.data['data']['ticket']['ticket_number'];
        serviceId =
            response.data['data']['ticket']['fk_service_type'].toString();
        atmNumber = response.data['data']['ticket']['atm_no'];
        atmSerialNumber = response.data['data']['ticket']['atm_sr_no'];
        atmSiteId = response.data['data']['ticket']['site_id'];
        location = response.data['data']['ticket']['location'];
        docketNumber = response.data['data']['ticket']['docket_number'];
        portalDocketNumber =
            response.data['data']['ticket']['portal_docket_number'] ?? '-';
        status = response.data['data']['ticket']['status_name'];
        filePath = response.data['filepath'];
        serviceName = response.data['data']['ticket']['service_name'];
        comment = response.data['data']['ticket']['comment'] ?? '-';
        tat = response.data['data']['ticket']['tat'] ?? '-';
      });
      await sharedPreferences.setString(
                            'ticket', ticketId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => TicketList(""))),
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
                              child: const Text('Docket Number',
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
                              child: Text(docketNumber,
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
                              child: const Text('Portal Docket Number',
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
                              child: Text(portalDocketNumber,
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
                              child: const Text('Comment',
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
                              child: Text(comment,
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
                              child: Text('TAT',
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
                              child: Text(tat,
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
                        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                              child: Text('Revised ETA',
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                      color: Colors.black)),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 0.0, 10.0, 10.0),
                              child: InkWell(
                                onTap: () {
                                 /*  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _buildPopupDialog(context),
                                  ); */
                                   Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ETATabbar()));
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: const <Widget>[
                                      Center(
                                        child: Text(
                                          'Modify',
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Stack(
                children: <Widget>[
                  (serviceName == 'FLM' || serviceName == 'QRT')
                      ? const SizedBox()
                      : Padding(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 5.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CategoryList(
                                          service: serviceId, text: ticketId)));
                            },
                            child: Container(
                              height: 30.0,
                              width: 240.0,
                              decoration: BoxDecoration(
                                color: const Color(0xfffcb913),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0.0, 0.0, 0.0, 0.0),
                                    child: Icon(Icons.comment_sharp),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10.0, 0.0, 10.0, 0.0),
                                    child: Center(
                                      child: Text(
                                        'QUESTIONNAIRE',
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 20.0),
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
                        width: 240.0,
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
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 0.0, 10.0, 0.0),
                              child: Center(
                                child: Text(
                                  'COMMENT AND STATUS',
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
            ],
          ),
        ),
      ),
    );
  }

  /* Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Popup example'),
      content: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 10,
            backgroundColor: const Color(0xfffcb913),
            automaticallyImplyLeading: false,
            bottom: const TabBar(
              tabs: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                  child: Center(
                    child: Text('Change',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                  child: Center(
                    child: Text('History',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              ChangeETA(),
              HistoryETA(),
            ],
          ),
        ),
      ),
    );
  } */
}
