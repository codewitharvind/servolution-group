// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servolution/Response/Counts.dart';
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
  String _date1 = "Select Date";
  String _date2 = "Select Date";
  String mainProfilePic =
      "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500";
  String otherProfilePic =
      "https://img.rawpixel.com/s3fs-private/rawpixel_images/website_content/368-mj-2516-02.jpg?w=800&dpr=1&fit=default&crop=default&q=65&vib=3&con=3&usm=15&bg=F4F4F3&ixlib=js-2.2.1&s=9f3d0ad657bbca1c0f2db36ad7deb323";

  int total = 0,
      todays = 0,
      open = 0,
      reOpen = 0,
      closed = 0,
      resolved = 0,
      active = 0,
      tempClosed = 0;

  Map<String, double> dataMap = {"Total Call": 3, "Open": 1, "Closed": 1};
  @override
  void initState() {
    super.initState();
    getTicketsstatus();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: todo
    // TODO: implement build

    /* getTicketsstatus();  */

    return DefaultTabController(
        length: 1,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xfffcb913),
            iconTheme: const IconThemeData(color: Colors.black),
            title: Center(
                child: Text(
              "M - AUDIT",
              style: GoogleFonts.poppins(fontSize: 20.0, color: Colors.black),
            )),
            actions: <Widget>[
              IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    //  showSearch(context: context, delegate: DataSearch(listWords));
                  })
            ],
            /*  bottom: TabBar(
              tabs: [
                Tab(text: "Total $total"),
                Tab(text: "Pending"),
                Tab(text: "Completed")
              ],
            ), */
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 00.0, 0.0),
                      child: RichText(
                        text: const TextSpan(
                          text: 'From Date',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Colors.black),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 0.0, 10),
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 00.0),
                      child: IconButton(
                        icon: const Icon(Icons.calendar_today),
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
                                DateFormat('dd-MM-yyyy').format(date);
                            setState(() {
                              _date1 = selectedFirstDate;
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
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 00.0, 0.0),
                      child: RichText(
                        text: const TextSpan(
                          text: 'End Date',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Colors.black),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 0.0, 10),
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
                      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 00.0),
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
                                DateFormat('dd-MM-yyyy').format(date);
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
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 20.0),
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
                    } else {
                      SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                      Response response;
                      final Dio dio = Dio();
                      dio.options.headers['content-Type'] = 'application/json';
                      dio.options.headers["authorization"] =
                          "${sharedPreferences.getString('api_access_token')}";
                      response = await dio.post(
                          'http://49.248.144.235/lv/servolutions/api/tickets_data_of_user_by_daterange',
                          queryParameters: {
                            'user_id': sharedPreferences.getInt('user_id'),
                            'start_date': _date1,
                            'end_date': _date2
                          });
                      if (response.data['status'] == true) {
                        Map<String, dynamic> data = Map<String, dynamic>.from(
                            response.data as Map<Object?, Object?>);
                        print(data.runtimeType);
                      }
                    }
                  },
                  child: Container(
                    height: 40.0,
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
            ],
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
                  leading: const Icon(Icons.insert_drive_file_outlined, size: 35.0),
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
          /*  drawer: Drawer(
              child: ListView(
            children: <Widget>[
              ListTile(
                title: Text("Profile",
                    style: GoogleFonts.poppins(
                        fontSize: 15.0, color: Colors.black)),
                trailing: const Icon(Icons.person),
                onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage())),
              ),
              const Divider(
                thickness: 1.0,
              ),
              ListTile(
                title: Text("Tickets",
                    style: GoogleFonts.poppins(
                        fontSize: 15.0, color: Colors.black)),
                trailing: const Icon(Icons.insert_drive_file_rounded),
                onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TicketList())),
              ),
              const Divider(
                thickness: 1.0,
              ),
              ListTile(
                  title: Text(
                    "Logout",
                    style: GoogleFonts.poppins(
                        fontSize: 15.0, color: Colors.black),
                  ),
                  trailing: const Icon(Icons.logout),
                  onTap: () async {
                    
                  }),
            ],
          )), */
        ));
  }

  Future getDateRange() async {
    print(_date1);
    print(_date2);
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

  Future getTicketsstatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    Response response;
    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["authorization"] =
        "${sharedPreferences.getString('api_access_token')}";
    response = await dio.post(
        'http://49.248.144.235/lv/servolutions/api/get_tickets_dashboard_data_of_user',
        queryParameters: {'user_id': sharedPreferences.getInt('user_id')});
    print(response.data['data'].runtimeType);
    var counts = countsFromJson(response.toString());

    for (int i = 0; i < counts.data.length; i++) {
      if (counts.data[i].name == 'Total') {
        setState(() {
          total = counts.data[i].count;
        });
      }
    }
  }
}
