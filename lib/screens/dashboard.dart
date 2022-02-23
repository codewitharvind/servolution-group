// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servolution/response/dashboardResponse.dart';
import 'package:servolution/response/daterangeResponse.dart';
import 'package:servolution/screens/ProfilePage.dart';
import 'package:servolution/screens/login.dart';
import 'package:servolution/screens/ticketListPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';

// ignore: camel_case_types
class dashboard extends StatefulWidget {
  const dashboard({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // ignore: todo
    // TODO: implement createState
    return _dashboard();
  }
}

// ignore: camel_case_types
class _dashboard extends State<dashboard> {
  Map<String, double> dataMap = {
    "Total": 0,
    "Todays": 0,
    "Open": 0,
    "Reopen": 0,
    "Closed": 0,
    "Resolved": 0,
    "Active": 0,
    "Temporary Close": 0,
    "Reassign": 0
  };
  Map<String, double> serviceMap = {
    "Total": 0,
    "SRM": 0,
    "FLM": 0,
    "HSK": 0,
    "QRT": 0,
    "CCTV": 0
  };
  String _date1 = "Select From Date";
  String _date2 = "Select End Date";
  String formattedDate = '';

  @override
  void initState() {
    super.initState();
    getTicketsstatus();
    getServiceDateRangeData();
    final now = DateTime.now();
    formattedDate = DateFormat('MM/dd/yyyy').format(now);
    print(formattedDate);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 1,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xfffcb913),
            iconTheme: const IconThemeData(color: Colors.black),
            centerTitle: true,
            title: Text(
              "M - AUDIT",
              style: GoogleFonts.poppins(fontSize: 20.0, color: Colors.black),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(20.0, 20.0, 00.0, 0.0),
                        child: RichText(
                          text: const TextSpan(
                            text: 'From',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 0.0),
                  child: Container(
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 0.0, 10),
                            child: Text(
                              _date1,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.normal,
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                150.0, 0.0, 0.0, 00.0),
                            child: IconButton(
                              icon: const Icon(Icons.calendar_today),
                              alignment: Alignment.centerRight,
                              onPressed: () {
                                DatePicker.showDatePicker(context,
                                    theme: const DatePickerTheme(
                                      containerHeight: 210.0,
                                    ),
                                    showTitleActions: true,
                                    maxTime: DateTime(2025, 12, 31),
                                    onConfirm: (date) {
                                  print('confirm $date');

                                  var selectedFirstDate =
                                      DateFormat('MM/dd/yyyy').format(date);
                                  setState(() {
                                    _date1 = selectedFirstDate;
                                  });
                                },
                                    currentTime: DateTime.now(),
                                    locale: LocaleType.en);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(20.0, 20.0, 00.0, 0.0),
                        child: RichText(
                          text: const TextSpan(
                            text: 'To',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 0.0),
                  child: Container(
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 0.0, 10),
                          child: Text(
                            _date2,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.normal,
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(160.0, 0.0, 0.0, 00.0),
                          child: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () {
                              DatePicker.showDatePicker(context,
                                  theme: const DatePickerTheme(
                                    containerHeight: 210.0,
                                  ),
                                  showTitleActions: true,
                                  minTime: DateTime.now(),
                                  maxTime: DateTime(2025, 12, 31),
                                  onConfirm: (date) {
                                print('confirm $date');

                                var selectedEndDate =
                                    DateFormat('MM/dd/yyyy').format(date);
                                setState(() {
                                  _date2 = selectedEndDate;
                                });
                              },
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.en);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 30.0, 0.0, 10.0),
                  child: InkWell(
                    onTap: () async {
                      if (_date1 == 'Select Date') {
                        print("date1 empty");
                        final snackBar = SnackBar(
                          content: Text('From Date not selected',
                              style: GoogleFonts.poppins(
                                  fontSize: 12.0, color: Colors.black)),
                          backgroundColor: (const Color(0xfffcb913)),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else if (_date2 == 'Select Date') {
                        print("date2 empty");
                        final snackBar = SnackBar(
                          content: Text('End Date not selected',
                              style: GoogleFonts.poppins(
                                  fontSize: 12.0, color: Colors.black)),
                          backgroundColor: (const Color(0xfffcb913)),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        getTicketsstatus();
                        getServiceDateRangeData();
                      }
                    },
                    child: Container(
                      height: 40.0,
                      width: 180.0,
                      decoration: BoxDecoration(
                        color: const Color(0xfffcb913),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: const Center(
                        child: Text(
                          'CONFIRM AND SUBMIT',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15.0,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 00.0, 0.0),
                  child: RichText(
                    text: const TextSpan(
                      text: 'User Data',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Colors.black),
                    ),
                  ),
                ),
                PieChart(
                  dataMap: dataMap,
                  animationDuration: const Duration(milliseconds: 800),
                  chartLegendSpacing: 16,
                  chartRadius: MediaQuery.of(context).size.width / 1.5,
                  initialAngleInDegree: 0,
                  chartType: ChartType.disc,
                  ringStrokeWidth: 32,
                  centerText: "",
                  legendOptions: const LegendOptions(
                    showLegendsInRow: true,
                    legendPosition: LegendPosition.bottom,
                    showLegends: true,
                    legendTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  chartValuesOptions: const ChartValuesOptions(
                    showChartValueBackground: true,
                    showChartValues: true,
                    showChartValuesInPercentage: true,
                    showChartValuesOutside: false,
                    decimalPlaces: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 00.0, 0.0),
                  child: RichText(
                    text: const TextSpan(
                      text: 'Service Data',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Colors.black),
                    ),
                  ),
                ),
                PieChart(
                  dataMap: serviceMap,
                  animationDuration: const Duration(milliseconds: 800),
                  chartLegendSpacing: 16,
                  chartRadius: MediaQuery.of(context).size.width / 1.5,
                  initialAngleInDegree: 0,
                  chartType: ChartType.disc,
                  ringStrokeWidth: 32,
                  centerText: "",
                  legendOptions: const LegendOptions(
                    showLegendsInRow: true,
                    legendPosition: LegendPosition.bottom,
                    showLegends: true,
                    legendTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  chartValuesOptions: const ChartValuesOptions(
                    showChartValueBackground: true,
                    showChartValues: true,
                    showChartValuesInPercentage: true,
                    showChartValuesOutside: false,
                    decimalPlaces: 1,
                  ),
                ),
              ],
            ),
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Image.asset(
                    'assets/servolutions_logo.jpg',
                    width: 100.0,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person_outline, size: 35.0),
                  title: Text(
                    'Profile',
                    style: GoogleFonts.poppins(
                        fontSize: 15.0, color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfilePage()));
                  },
                ),
                const Divider(
                  thickness: 1.0,
                ),
                ListTile(
                  leading:
                      const Icon(Icons.insert_drive_file_outlined, size: 35.0),
                  title: Text(
                    'Tickets',
                    style: GoogleFonts.poppins(
                        fontSize: 15.0, color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TicketList()));
                  },
                ),
                const Divider(
                  thickness: 1.0,
                ),
                ListTile(
                  leading: const Icon(Icons.power_settings_new, size: 35.0),
                  title: Text(
                    'Logout',
                    style: GoogleFonts.poppins(
                        fontSize: 15.0, color: Colors.black),
                  ),
                  onTap: () {
                    logout();
                    Navigator.pop(
                        context); // Logout() called to clear the data stored in the shared perferences of People Manager.
                  },
                ),
              ],
            ),
          ),
        ));
  }

  logout() async {
    String apiAccessToken;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    apiAccessToken = sharedPreferences.getString('api_access_token')!;

    Response response;
    final Dio dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["authorization"] = "token $apiAccessToken";
    response = await dio.post(
        'http://49.248.144.235/lv/servolutions/api/logout',
        queryParameters: {});
    print(response.data.toString());

    if (response.data['status'] == true) {
      print('Success');
      final snackBar = SnackBar(
        content: Text("Logout successfully",
            style: GoogleFonts.poppins(fontSize: 12.0, color: Colors.white)),
        backgroundColor: (const Color(0xfffcb913)),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // navigate user to dashboard screen on API success response
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const login()));
    } else {
      final snackBar = SnackBar(
        content: Text(response.data['message'],
            style: GoogleFonts.poppins(fontSize: 12.0, color: Colors.white)),
        backgroundColor: (const Color(0xfffcb913)),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  getTicketsstatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Response response;
    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["authorization"] =
        "${sharedPreferences.getString('api_access_token')}";
    response = await dio.post(
        'http://49.248.144.235/lv/servolutions/api/get_tickets_dashboard_data_of_user',
        queryParameters: {
          'user_id': sharedPreferences.getInt('user_id'),
          'start_date': _date1 == 'Select From Date' ? formattedDate : _date1,
          'end_date': _date2 == 'Select End Date' ? formattedDate : _date2
        });
    print(response);
    final dashboardResponse = dashboardResponseFromJson(response.toString());
    setState(() {
      dataMap = {
        "Total": double.parse(dashboardResponse.data.total),
        "Todays": double.parse(dashboardResponse.data.todays),
        "Open": double.parse(dashboardResponse.data.open),
        "Reopen": double.parse(dashboardResponse.data.reopen),
        "Closed": double.parse(dashboardResponse.data.closed),
        "Resolved": double.parse(dashboardResponse.data.resolved),
        "Active": double.parse(dashboardResponse.data.active),
        "Temporary Close": double.parse(dashboardResponse.data.temporaryClose),
        "Reassign": double.parse(dashboardResponse.data.reassign)
      };
    });
  }

  getServiceDateRangeData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Response response;
    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["authorization"] =
        "${sharedPreferences.getString('api_access_token')}";
    response = await dio.post(
        'http://49.248.144.235/lv/servolutions/api/services_data_of_user_by_daterange',
        queryParameters: {
          'user_id': sharedPreferences.getInt('user_id'),
          'start_date': _date1 == 'Select From Date' ? formattedDate : _date1,
          'end_date': _date2 == 'Select End Date' ? formattedDate : _date2
        });
    print(response);
    final daterangeResponse = dateRangeResponseFromJson(response.toString());
    setState(() {
      serviceMap = {
        "Total": double.parse(daterangeResponse.data.total),
        "SRM": double.parse(daterangeResponse.data.srm),
        "FLM": double.parse(daterangeResponse.data.flm),
        "HSK": double.parse(daterangeResponse.data.hsk),
        "QRT": double.parse(daterangeResponse.data.qrt),
        "CCTV": double.parse(daterangeResponse.data.cctv),
      };
      _date1 = "Select From Date";
      _date2 = "Select End Date";
    });
  }
}
