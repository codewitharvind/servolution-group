import 'dart:collection';
import 'dart:convert';
import 'dart:core';
import 'dart:core';

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servolution/Response/DataFilter.dart';
import 'package:servolution/screens/dashboard.dart';
import 'package:servolution/screens/ticketDetailPage.dart';
import 'package:servolution/utils/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

import '../Response/TicketListResponse.dart';



class TicketList extends StatefulWidget {

  late String filter;
  TicketList(String filterData){
     this.filter=filterData;
  }
  @override
  _TicketListState createState() => _TicketListState(filter);
}

class _TicketListState extends State<TicketList> {
  int offSet = 0, limit = 10, count = 0;

  late String filterString;

  late String dataFilter;
  late SharedPreferences sharedPreferences;

  late TicketListResponse titicketListResponse;
  late TicketListResponse filterDataResponse;
  late TicketListResponse mainTicketResponse;

  late List<String> requestFilter;
  late List<String> requestdata;


  Map<String, String> filterMain = Map<String, String>();

  TextEditingController filter_ticket_number = TextEditingController();
  TextEditingController filter_docker_number = TextEditingController();
  TextEditingController filter_portal_docker_number = TextEditingController();
  TextEditingController filter_atmid = TextEditingController();
  TextEditingController filter_siteId = TextEditingController();
  TextEditingController filter_tat = TextEditingController();



  _TicketListState(String filterData){
    this.filterString=filterData;
  }

  @override
  void initState() {
    super.initState();
  //  getTicketsInfo(offSet, limit);
    getTicketsFilter();
  }

  @override
  void dispose() {
    super.dispose();
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
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
                 Padding(padding: EdgeInsets.fromLTRB(5,5,20,5),
                     child:Row(
                       mainAxisAlignment: MainAxisAlignment.end,
                       children: [
                           ElevatedButton.icon(
                               icon: Icon(
                                 Icons.filter_alt_outlined,
                                 color: Colors.white,
                                 size: 30.0,
                               ),
                                onPressed: (){
                                   showDialog(
                                    context: context,
                                    builder: (context) {
                                        return  AlertDialog(
                                            title: const Text('Filters'),
                                            content: openBottomFilter(context,dataFilter),
                                            actions: <Widget>[
                                              TextButton(
                                            onPressed: () {
                                                Navigator.pop(context, 'Reset Filter');
                                                Navigator.push(
                                                  context,
                                                         MaterialPageRoute(builder: (context) => TicketList("")),
                                                  );
                                                // getTicketsInfo(offSet, limit,<String>["ABV","PQR"],<String>["ABV","PQR"]);
                                              },
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context, 'Search');
                                                  String usreid=sharedPreferences.getInt('user_id').toString();
                                                  filterMain.update("user_id", (v) => usreid, ifAbsent: () => usreid);

                                                  if(filter_ticket_number.text!=""){
                                                    filterMain.update("ticket_number", (v) => filter_ticket_number.text, ifAbsent: () => filter_ticket_number.text);
                                                  }
                                                  if(filter_docker_number.text.isNotEmpty){
                                                    filterMain.update("docket_number", (v) => filter_docker_number.text, ifAbsent: () => filter_docker_number.text);
                                                  }
                                                  if(filter_portal_docker_number.text.isNotEmpty){
                                                    filterMain.update("portal_number", (v) => filter_portal_docker_number.text, ifAbsent: () => filter_portal_docker_number.text);
                                                  }
                                                  if(filter_atmid.text.isNotEmpty){
                                                    filterMain.update("atm_no", (v) => filter_atmid.text, ifAbsent: () => filter_atmid.text);
                                                  }
                                                  if(filter_siteId.text.isNotEmpty){
                                                    filterMain.update("site_id", (v) => filter_siteId.text, ifAbsent: () => filter_siteId.text);
                                                  }
                                                  if(filter_tat.text.isNotEmpty){
                                                    filterMain.update("tat", (v) => filter_tat.text, ifAbsent: () => filter_tat.text);
                                                  }

                                                  print("Filter Data JSON"+json.encode(filterMain));
                                                    Navigator.push(
                                                      context,
                                                         MaterialPageRoute(builder: (context) =>
                                                             TicketList(json.encode(filterMain)),
                                                    ));
                                                  },
                                                child: const Text('Search'),
                                              ),
                                            ],
                                        );
                                      }
                                    );
                              },
                             label: Text('Filters'),
                             style: ElevatedButton.styleFrom(
                               primary: Colors.black,
                               shape: new RoundedRectangleBorder(
                                 borderRadius: new BorderRadius.circular(20.0),
                               ),
                             ),

                           ),
                         ],
                       ),
                ),
                 FutureBuilder(
                    future: getTicketsInfo(offSet, limit,filterString),
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
                                                   text: titicketListResponse.data[index].ticketNumber)));
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
                               );
                             });
                      }
                    })
            ],
          ),
        )
    );
  }


  Future<List<Datum>> getTicketsInfo(int offSet, int limit,String filterdata) async {
    sharedPreferences = await SharedPreferences.getInstance();
    Response response;
    final Dio dio = Dio();
    Map<String, dynamic> queryParameter;
    if(filterdata.isEmpty){
      queryParameter={
        'user_id': sharedPreferences.getInt('user_id'),
        "limit": limit,
        "offset": offSet
      };
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["Authorization"] =
      "${sharedPreferences.getString('api_access_token')}";
      response = await dio.post(
          'http://49.248.144.235/lv/servolutions/api/get_assigned_tickets',
          queryParameters: queryParameter);

      print("Ticket Response");
      print(response.toString());
    }
    else{
      print("Data in API"+filterdata);
      queryParameter=jsonDecode(filterdata) ;

      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["Authorization"] =
      "${sharedPreferences.getString('api_access_token')}";
      response = await dio.post(
          'http://49.248.144.235/lv/servolutions/api/get_assigned_tickets',
          queryParameters: queryParameter);

      print("Ticket Response");
      print(response.toString());

    }

    // print("QUERY PARAMETER"+queryParameter.toString());
    //
    // dio.options.headers['content-Type'] = 'application/json';
    // dio.options.headers["Authorization"] =
    // "${sharedPreferences.getString('api_access_token')}";
    // response = await dio.post(
    //     'http://49.248.144.235/lv/servolutions/api/get_assigned_tickets',
    //     queryParameters: queryParameter);
    //
    // print("Ticket Response");
    // print(response.toString());

    titicketListResponse = ticketListResponseFromJson(response.toString());
    return titicketListResponse.data;
  }

  getTicketsFilter() async {
    sharedPreferences = await SharedPreferences.getInstance();
    Response response;
    final Dio dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] =
    "${sharedPreferences.getString('api_access_token')}";
    response = await dio.post(
      config.BASE_URL+"get-all-filters",);

    // dataFilter = dataFilterFromJson(response.toString());
    dataFilter=response.toString();
    // developer.log('FilterDataTest', name: dataFilter.data.bankListing[0].name);
    // print(dataFilter.data.bankListing[0].name);
  }

  Widget openBottomFilter(BuildContext context,String rawData) {
    var dataFilter = dataFilterFromJson(rawData);
    List<String> bankinglist=<String>[];
    List<String> statuslist=<String>[];
    List<String> citylist=<String>['Select City'];
    List<String> statelist=<String>[];
    List<String> servicelist=<String>[];
    for(int i=0;i<dataFilter.data.bankListing.length;i++){
      bankinglist.add(dataFilter.data.bankListing[i].name);
    }
    for(int i=0;i<dataFilter.data.serviceListing.length;i++){
      servicelist.add(dataFilter.data.serviceListing[i].serviceName);
    }
    for(int i=0;i<dataFilter.data.stateListing.length;i++){
      statelist.add(dataFilter.data.stateListing[i].stateName);
    }
    for(int i=0;i<dataFilter.data.statusListing.length;i++){
      statuslist.add(dataFilter.data.statusListing[i].statusName);
    }
    // for(int i=0;i<dataFilter.data.bankListing.length;i++){
    //   banking.add(dataFilter.data.bankListing[i].name);
    // }

    return SingleChildScrollView(child:
           Column(
                mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                          Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child:  DropdownSearch<String>(
                                mode: Mode.MENU,
                                showSearchBox: true,
                                //list of dropdown items
                                items: bankinglist,
                                label: "Select Bank",
                                onChanged:(String? data) {
                                  // print(data);
                                  //firstWhere((book) => book.id == id)
                                  print(dataFilter.data.bankListing.firstWhere((bankListing) => bankListing.name == data).bankId);
                                  String id=dataFilter.data.bankListing.firstWhere((bankListing) => bankListing.name == data).bankId.toString();
                                  filterMain.update("bank", (v) => id, ifAbsent: () => id);
                                  updateTicketResponse('bankName',data!);
                                },
                                //show selected item
                                selectedItem: bankinglist[0],
                           ),
                        ),
                          Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child:  DropdownSearch<String>(
                            mode: Mode.MENU,
                            showSearchBox: true,
                            //list of dropdown items
                            items: statelist,
                            label: "Select State",
                            onChanged: (String? data){
                              citylist.clear();
                              String id=dataFilter.data.stateListing.firstWhere((stateListing) => stateListing.stateName == data).stateId.toString();
                              filterMain.update("state_name", (v) => id, ifAbsent: () => id);


                              for(int i=0;i<dataFilter.data.cityListing.length;i++){
                                if(dataFilter.data.cityListing[i].state_name==data){
                                  citylist.add(dataFilter.data.cityListing[i].cityName);
                                  //print("CITY IN $data is "+dataFilter.data.cityListing[i].cityName);
                                }
                              }
                            },
                            //show selected item
                            selectedItem: statelist[0],
                          ),
                        ),
                          Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child:  DropdownSearch<String>(
                            mode: Mode.MENU,
                            showSearchBox: true,
                            //list of dropdown items
                            items: citylist,
                            label: "Select City",
                            onChanged: (String? data){
                              String id=dataFilter.data.cityListing.firstWhere((cityListing) => cityListing.cityName == data).cityId.toString();
                              filterMain.update("city_id", (v) => id, ifAbsent: () => id);
                            },
                            //show selected item
                            selectedItem: citylist[0],
                          ),
                        ),
                          Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child:  DropdownSearch<String>(
                            mode: Mode.MENU,
                            showSearchBox: true,
                            //list of dropdown items
                            items: servicelist,
                            label: "Service Type",
                            onChanged: (String? data){
                              String id=dataFilter.data.serviceListing.firstWhere((serviceListing) => serviceListing.serviceName == data).id.toString();
                              filterMain.update("service_name", (v) => id, ifAbsent: () => id);
                            },
                            //show selected item
                            selectedItem: servicelist[0],
                          ),
                        ),
                          Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child:  TextFormField(
                            controller: filter_ticket_number,
                            decoration: InputDecoration(
                              labelText: 'Ticket Number',
                               hintText: 'Ticket Number',
                              border: OutlineInputBorder(),

                            ),
                          ),
                        ),
                          Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child:  TextFormField(
                                controller: filter_docker_number,
                                decoration: InputDecoration(
                                  labelText: 'Docket Number',
                                  hintText: 'Docket Number',
                                  border: OutlineInputBorder(),

                                ),
                              ),
                            ),
                          Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child:  TextFormField(
                                controller: filter_portal_docker_number,
                                decoration: InputDecoration(
                                  labelText: 'Portal Docket Number',
                                  hintText: 'Portal Docket Number',
                                  border: OutlineInputBorder(),

                                ),
                              ),
                            ),
                          Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child:  TextFormField(
                              controller: filter_atmid,
                              decoration: InputDecoration(
                                labelText: 'ATM ID',
                                hintText: 'ATM ID',
                                border: OutlineInputBorder(),

                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child:  TextFormField(
                              controller: filter_siteId,
                              decoration: InputDecoration(
                                labelText: 'Site ID',
                                hintText: 'Site ID',
                                border: OutlineInputBorder(),

                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child:  TextFormField(
                              controller: filter_tat,
                              decoration: InputDecoration(
                                labelText: 'TAT',
                                hintText: 'TAT',
                                border: OutlineInputBorder(),

                              ),
                            ),

                    ),
                          Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child:  DropdownSearch<String>(
                                  mode: Mode.MENU,
                                  showSearchBox: true,
                                  //list of dropdown items
                                  items: statuslist,
                                  label: "Status",
                                  onChanged: (String? data){
                                    String id=dataFilter.data.statusListing.firstWhere((statusListing) => statusListing.statusName == data).id.toString();
                                    filterMain.update("status_id", (v) => id, ifAbsent: () => id);
                                  },
                                  //show selected item
                                  selectedItem: statuslist[0],
                                ),
                              ),
                 ],
    )
    );
  }

  void updateTicketResponse(String filterType,String filtername){
    // late TicketListResponse titicketListResponse;
      TicketListResponse filterDataResponse;
      for(int i=0;i<titicketListResponse.data.length;i++){
        if(titicketListResponse.data[i].name=="HDFC Bank"){
          Datum datum=new Datum(ticketNumber: titicketListResponse.data[i].ticketNumber,
              atmNo: titicketListResponse.data[i].atmNo,
              siteId: titicketListResponse.data[i].siteId,
              createdAt: titicketListResponse.data[i].createdAt,
              statusName: titicketListResponse.data[i].statusName,
              cityName: titicketListResponse.data[i].cityName,
              stateName: titicketListResponse.data[i].statusName,
              name: titicketListResponse.data[i].name,
              serviceName: titicketListResponse.data[i].serviceName);
        }
      }
    // late TicketListResponse mainTicketResponse;
  }

}
