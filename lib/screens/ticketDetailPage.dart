import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servolution/screens/ticketListPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TicketDetail extends StatefulWidget {
  final String text;
  const TicketDetail({Key? key, required this.text}) : super(key: key);

  @override
  _TicketDetailState createState() => _TicketDetailState();
}

class _TicketDetailState extends State<TicketDetail> {
  late Map<String, dynamic> dataList;
  late SharedPreferences sharedPreferences;
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
      print(response.data['data']);
      print(response.data['data'].runtimeType);
      setState(() {
        dataList = response.data['data'];
      });
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
          padding: const EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 0.0),
          child: Card(
            elevation: 9,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: InkWell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Expanded(
                          child: Center(
                            child: Text("Docket Number : ",
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                    color: Colors.black)),
                          ),
                        ),
                        VerticalDivider(width: 1.0),
                        Expanded(
                          child: Center(
                            child: Text(
                              'Abc',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.normal,
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    thickness: 1.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Expanded(
                          child: Center(
                            child: Text("Docket Number : ",
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                    color: Colors.black)),
                          ),
                        ),
                        VerticalDivider(width: 1.0),
                        Expanded(
                          child: Center(
                            child: Text(
                              'ACB',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.normal,
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    thickness: 1.0,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
