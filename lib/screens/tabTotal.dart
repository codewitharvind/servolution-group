import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:servolution/Response/Counts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class tabTotal extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _tabTotal();
  }
}

class _tabTotal extends State<tabTotal> {
  // late int total, todays, open, reOpen, closed, resolved, active, tempClosed;

  Map<String, double> dataMap = {"Total Call": 1,
    "Open": 1,
    "Closed": 1};

  var arr = [];
  int total = 0,
      todays = 0,
      open = 0,
      reOpen = 0,
      closed = 0,
      resolved = 0,
      active = 0,
      tempClosed = 0;
  @override
  Widget build(BuildContext context) {
    // ignore: todo
    // TODO: implement build

    getTicketsstatus();

    /*Map<String, double> dataMap = {
      "Total Call": total.toDouble(),
      "Open": open.toDouble(),
      "Closed": closed.toDouble(),
    };*/

    return SizedBox(
        child: PieChart(
      dataMap: dataMap,
      animationDuration: const Duration(milliseconds: 800),
      chartLegendSpacing: 32,
      chartRadius: MediaQuery.of(context).size.width / 1.5,
      initialAngleInDegree: 0,
      chartType: ChartType.disc,
      ringStrokeWidth: 32,
      centerText: "",
      legendOptions: const LegendOptions(
        showLegendsInRow: false,
        legendPosition: LegendPosition.right,
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
    ));
  }

  Future<void> getTicketsstatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    Response response;
    final Dio dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["authorization"] =
        "token ${sharedPreferences.getString('api_access_token')}";
    response = await dio.post(
        'http://49.248.144.235/lv/servolutions/api/get_tickets_dashboard_data_of_user',
        queryParameters: {'user_id': sharedPreferences.getInt('user_id')});
   var counts = countsFromJson(response.toString());

    for(int i = 0; i < counts.data.length; i++) {
      if(counts.data[i].name == 'Total') {
        setState(() {
          total = counts.data[i].count;
        });
      }
    }

    /*if (response.data['status'] == true) {
      // integer data response
      total = response.data['data']['Total'];
      todays = response.data['data']['Todays'];
      open = response.data['data']['Open'];
      reOpen = response.data['data']['Reopen'];
      closed = response.data['data']['Closed'];
      resolved = response.data['data']['Resolved'];
      active = response.data['data']['Active'];
      tempClosed = response.data['data']['Temporary Close'];

      */ /*var usrMap = {"name": "Tom", 'Email': 'tom@xyz.com'};
      usrMap.forEach((k,v) => print('${k}: ${v}'));*/ /*

    } else {
      print(response.data['message']);
    }*/
  }
}
