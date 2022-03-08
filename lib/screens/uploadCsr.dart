import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Response/atm_listing_hsk.dart';
import 'dashboard.dart';

class uploadCsr extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _uploadCsr();
  }
}

class _uploadCsr extends State<uploadCsr> {
  late SharedPreferences sharedPreferences;

  late TicketListResponse ticketListResponse;
  final selectedIndexes = [];
  var couirerName = TextEditingController();
  var comment = TextEditingController();
  var externalpod = TextEditingController();

  late List<CheckBoxData> checkboxlist = [];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
            "Upload CSR",
            style: GoogleFonts.poppins(fontSize: 20.0, color: Colors.black),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Listing"),
              Tab(text: "CSR Upload"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            tab_hrslisting(context),
            tab_uploadcrs(context),
          ],
        ),
      ),
    );
  }

  tab_uploadcrs(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
            future: getTicketsInfo(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                    child: const Center(child: Text("Loading...")));
              } else {
                return ListView.builder(
                    physics: const PageScrollPhysics(),
                    itemCount: snapshot.data.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                          padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                          child: Card(
                              elevation: 20.0,
                              child: Column(
                                children: [
                                  CheckboxListTile(
                                    tristate: true,
                                    title: Text(
                                        ticketListResponse.data[index].atmId),
                                    value: selectedIndexes.contains(index),
                                    onChanged: (bool? value) {
                                      if (selectedIndexes.contains(index)) {
                                        selectedIndexes
                                            .remove(index); // unselect
                                      } else {
                                        selectedIndexes.add(index);
                                      }
                                      setState(() {});
                                    },
                                    controlAffinity: ListTileControlAffinity
                                        .leading, //  <-- leading Checkbox
                                  ),
                                ],
                              )));
                      ;
                    });
              }
            }),
        GestureDetector(
          onTap: () {
            _displayDialog(context);
          },
          child: Text(
            "Upload Courires Details",
            style: const TextStyle(color: Colors.red),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
          child: ElevatedButton(
            onPressed: () async {
              print(selectedIndexes);
              String jsonArray = "[";
              String id = "";
              for (int i = 0; i < selectedIndexes.length; i++) {
                checkboxlist.add(CheckBoxData(
                    ticketListResponse.data[i].id.toString(),
                    ticketListResponse.data[i].atmId.toString(),
                    ticketListResponse.data[i].fkAtmId.toString()));
                print("Json Object" + jsonEncode(checkboxlist[i].toMap()));
                jsonArray =
                    jsonArray + jsonEncode(checkboxlist[i].toMap()) + ",";
                id = ticketListResponse.data[i].id.toString();
              }
              jsonArray = jsonArray.substring(0, jsonArray.length - 1) + "]";
              print(jsonArray);

              final Dio dio = Dio();
              sharedPreferences = await SharedPreferences.getInstance();
              Map<String, dynamic> queryParameter;
              dio.options.headers['content-Type'] = 'application/json';
              dio.options.headers["Authorization"] =
                  "${sharedPreferences.getString('api_access_token')}";
              queryParameter = {
                'user_id': sharedPreferences.getInt('user_id'),
                'hskid': "" + id,
                'atmid': jsonArray,
                'courier': couirerName.text.isNotEmpty ? couirerName.text : "",
                'comment': comment.text,
                'extenalpod': externalpod.text,
              };

              print(queryParameter);
              Response response = await dio.post(
                  'http://49.248.144.235/lv/servolutions/api/store-pod-data',
                  queryParameters: queryParameter);

              // print(response.toString());
            },
            child: const Text('Generate POD'),
            style: ElevatedButton.styleFrom(
                primary: Colors.amber, shape: const StadiumBorder()),
          ),
        ),
      ],
    );
  }

  Future<List<Datum>> getTicketsInfo() async {
    late SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    Response response;
    final Dio dio = Dio();
    Map<String, dynamic> queryParameter;

    queryParameter = {
      'user_id': sharedPreferences.getInt('user_id'),
    };
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] =
        "${sharedPreferences.getString('api_access_token')}";
    response = await dio.post(
        'http://49.248.144.235/lv/servolutions/api/hsk-manual-ticket-listing',
        queryParameters: queryParameter);

    print("Ticket Response");
    ticketListResponse = ticketListResponseFromJson(response.toString());
    return ticketListResponse.data;
  }

  Future<List<Datum>> getTicketsHSKListing() async {
    late SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    Response response;
    final Dio dio = Dio();
    Map<String, dynamic> queryParameter;

    queryParameter = {
      'user_id': sharedPreferences.getInt('user_id'),
      "limit": "10",
      "offset": "0"
    };
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] =
        "${sharedPreferences.getString('api_access_token')}";
    response = await dio.post(
        'http://49.248.144.235/lv/servolutions/api/get-all-tickets-hsk',
        queryParameters: queryParameter);

    print("Ticket Response");
    ticketListResponse = ticketListResponseFromJson(response.toString());
    return ticketListResponse.data;
  }

  tab_hrslisting(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        FutureBuilder(
            future: getTicketsHSKListing(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                    child: const Center(child: const Text("Loading...")));
              } else {
                return ListView.builder(
                    physics: const PageScrollPhysics(),
                    itemCount: snapshot.data.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                          padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                          child: Card(
                              elevation: 20.0,
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // Navigator.pushReplacement(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => TicketDetail(
                                      //             text: titicketListResponse.data[index].ticketNumber)));
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0.0, 0.0, 0.0, 0.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: const <Widget>[
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    10.0, 10.0, 5.0, 0.0),
                                                child: Text(
                                                    '#'
                                                    "titicketListResponse.data[index].ticketNumber",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20.0,
                                                        color: Colors.black)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0.0, 0.0, 0.0, 0.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10.0, 5.0, 0.0, 0.0),
                                                child: Text(
                                                  ("titicketListResponse.data[index].createdAt")
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14.0,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        35.0, 5.0, 0.0, 0.0),
                                                child: Container(
                                                  width: 7,
                                                  height: 7,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color:
                                                        "titicketListResponse.data[index].statusName" ==
                                                                "Open"
                                                            ? Colors.green
                                                            : Color(0xfffcb913),
                                                  ),
                                                ),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    10.0, 5.0, 0.0, 0.0),
                                                child: Text(
                                                  "titicketListResponse.data[index].statusName",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 14.0,
                                                      color:
                                                          "titicketListResponse.data[index].statusName" ==
                                                                  "Open"
                                                              ? Colors.green
                                                              : Color(
                                                                  0xfffcb913)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0.0, 10.0, 0.0, 0.0),
                                          child: Container(
                                            height: 30.0,
                                            decoration: const BoxDecoration(
                                              color: Color(0xfffcb913),
                                              borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(15.0),
                                                bottomRight:
                                                    Radius.circular(15.0),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: const <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      30.0, 5.0, 0.0, 0.0),
                                                  child: Text(
                                                    'ATM No. ' +
                                                        "titicketListResponse.data[index].atmNo",
                                                    style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 13.0,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                VerticalDivider(
                                                  thickness: 2,
                                                  width: 20,
                                                  color: Colors.black,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0.0, 5.0, 40.0, 0.0),
                                                  child: Flexible(
                                                    child: Flexible(
                                                      child: Text(
                                                        'Site ID: ' +
                                                            "titicketListResponse.data[index].siteId",
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          fontWeight:
                                                              FontWeight.w600,
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
                                ],
                              )));
                      ;
                    });
              }
            }),
      ],
    ));
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: AlertDialog(
              title: const Text('Please fill Following Details'),
              content: Column(
                children: [
                  TextField(
                    controller: couirerName,
                    decoration: const InputDecoration(hintText: "Couirer Name"),
                  ),
                  TextField(
                    controller: comment,
                    decoration:
                        const InputDecoration(hintText: "Comment(Like 10 CSR)"),
                  ),
                  TextField(
                    controller: externalpod,
                    decoration:
                        const InputDecoration(hintText: "External POD number"),
                  )
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Save'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          );
        });
  }
}

class CheckBoxData {
  String id;
  String atm_id;
  String fk_atm_id;

  CheckBoxData(
    this.id,
    this.atm_id,
    this.fk_atm_id,
  );

  static CheckBoxData fromMap(Map map) {
    return CheckBoxData(
      map['id'].toString(),
      map['atm_id'].toString(),
      map['fk_atm_id'].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "atm_id": this.atm_id,
      "fk_atm_id": this.fk_atm_id,
    };
  }
}
