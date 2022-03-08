import 'package:flutter/material.dart';
import 'package:servolution/screens/changeETA.dart';
import 'package:servolution/screens/historyETA.dart';
import 'package:servolution/screens/ticketDetailPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ETATabbar extends StatefulWidget {
  const ETATabbar({Key? key}) : super(key: key);

  @override
  State<ETATabbar> createState() => _ETATabbarState();
}

class _ETATabbarState extends State<ETATabbar> {
  String ticketId = '';

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      ticketId = sharedPreferences.getString('ticket')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 30,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => TicketDetail(
                          text: ticketId,
                        ))),
          ),
          backgroundColor: const Color(0xfffcb913),
          automaticallyImplyLeading: true,
          bottom: const TabBar(
            tabs: [
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                child: Center(
                  child: Text('Change',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
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
    );
  }
}
