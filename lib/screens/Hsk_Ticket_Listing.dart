import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servolution/screens/hsk_ticketDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Response/TicketListResponse.dart';
import 'dashboard.dart';

class Hsk_Ticket_Listing extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _Hsk_Ticket_Listing();
  }
}

class _Hsk_Ticket_Listing extends State<Hsk_Ticket_Listing>{
  @override
  late SharedPreferences sharedPreferences;
  late TicketListResponse titicketListResponse;
  late TicketListResponse filterDataResponse;
  late TicketListResponse mainTicketResponse;

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
          "HSK Ticket List",
          style: GoogleFonts.poppins(fontSize: 20.0, color: Colors.black),
        ),
      ),
      body:SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
                future: getTicketsInfo(1, 10,"filterString"),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Container(
                        child: Center(
                            child: Text("Loading...")
                        )
                    );
                  }else{
                    return ListView.builder(
                        physics: const PageScrollPhysics(),
                        itemCount: snapshot.data.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                            return Container(
                            padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0),
                               child: GestureDetector(
                                 onTap: () {
                                   print("Navigation Data");
                                   // Navigator.pushReplacement(
                                   //     context,
                                   //     MaterialPageRoute(
                                   //         builder: (context) => hsk_TicketDetail(
                                   //             text: ""+titicketListResponse.data[index].ticketNumber)));


                                 },
                                 child:  Card(
                                   elevation: 9,
                                   shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(15.0),
                                   ),
                                   child: InkWell(
                                     onTap: () {
                                       print("Navigation Data"+titicketListResponse.data[index].ticketNumber);
                                       Navigator.pushReplacement(
                                           context,
                                           MaterialPageRoute(
                                               builder: (context) => hsk_TicketDetail(
                                                   text: ""+titicketListResponse.data[index].ticketNumber)));
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
                                                         titicketListResponse.data[index].ticketNumber,
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
                                                   (titicketListResponse.data[index].createdAt).toString(),
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
                                                     titicketListResponse.data[index].statusName == "Open"
                                                         ? Colors.green
                                                         : const Color(0xfffcb913),
                                                   ),
                                                 ),
                                               ),
                                               Padding(
                                                 padding: const EdgeInsets.fromLTRB(
                                                     10.0, 5.0, 0.0, 0.0),
                                                 child: Text(
                                                   titicketListResponse.data[index].statusName,
                                                   textAlign: TextAlign.center,
                                                   style: TextStyle(
                                                       fontFamily: 'Poppins',
                                                       fontSize: 14.0,
                                                       color: titicketListResponse.data[index].statusName ==
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
                                                     'ATM No. ' + titicketListResponse.data[index].atmNo,
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
                                                   child: Flexible(
                                                     child: Flexible(
                                                       child: Text(
                                                         'Site ID: ' + titicketListResponse.data[index].siteId,
                                                         textAlign: TextAlign.right,
                                                         style: const TextStyle(
                                                           fontFamily: 'Poppins',
                                                           fontWeight: FontWeight.w600,
                                                           fontSize: 10.0,
                                                           color: Colors.black,
                                                         ),
                                                       ),
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
                               )
                          );
                        });
                  }
                })
          ],
        ),
      ),
    );
  }

  Future<List<Datum>> getTicketsInfo(int offSet, int limit,String filterdata) async {
    sharedPreferences = await SharedPreferences.getInstance();

    Response response;
    final Dio dio = Dio();
    Map<String, dynamic> queryParameter;
    // if(filterdata.isEmpty){


    queryParameter={
      'user_id': sharedPreferences.getInt('user_id'),
      "limit": limit,
      "offset": offSet
    };
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] =
    "${sharedPreferences.getString('api_access_token')}";
    response = await dio.post(
        'http://49.248.144.235/lv/servolutions/api/get-all-tickets-hsk',
        queryParameters: queryParameter);

    print("Ticket Response");
    print(response.toString());


    //   }
    // else{
    //   print("Data in API"+filterdata);
    //   queryParameter=jsonDecode(filterdata) ;
    //
    //   dio.options.headers['content-Type'] = 'application/json';
    //   dio.options.headers["Authorization"] =
    //   "${sharedPreferences.getString('api_access_token')}";
    //   response = await dio.post(
    //       'http://49.248.144.235/lv/servolutions/api/get_assigned_tickets',
    //       queryParameters: queryParameter);
    //
    //   print("Ticket Response");
    //   print(response.toString());
    //
    // }

    titicketListResponse = ticketListResponseFromJson(response.toString());
    return titicketListResponse.data;
  }

}
