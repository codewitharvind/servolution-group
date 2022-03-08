
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeETA extends StatefulWidget {
  const ChangeETA({Key? key}) : super(key: key);

  @override
  State<ChangeETA> createState() => _ChangeETAState();
}

class _ChangeETAState extends State<ChangeETA> {
  TextEditingController commentController = TextEditingController();
  String etaTime = "Select Time";
  String _chosenValue = '';
  int selectedReason = 0;
  final _formKey = GlobalKey<FormState>();
  late List<dynamic> reasonList = [];
  List<String> reasonData = <String>[];

  @override
  void initState() {
    super.initState();
    getETAReasons();
  }

  getETAReasons() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Response response;
    final Dio dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["authorization"] =
        "${sharedPreferences.getString('api_access_token')}";
    response = await dio
        .post('http://49.248.144.235/lv/servolutions/api/get_tickets_reasons');
    if (response.data['status'] == true) {
      print(response.data['data']);
      setState(() {
        reasonList = response.data['data'];
        for (int i = 0; i < reasonList.length; i++) {
          reasonData.add(reasonList[i]['reasons']);
        }
        print('************');
        print(reasonData);
        print('*********');
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, .0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
                  child: Text('ETA Hours',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: Colors.black)),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 0.0, 0.0),
                  child: Text(
                    etaTime,
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
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.5, 00.0),
                  child: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () {
                      DatePicker.showTimePicker(context,
                          theme: const DatePickerTheme(
                            containerHeight: 210.0,
                          ),
                          showTitleActions: true, onConfirm: (time) {
                        print('confirm $time');
                        var selectedTime = DateFormat('hh:mm a').format(time);
                        setState(() {
                          etaTime = selectedTime;
                        });
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, .0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
                  child: Text('ETA Reasons',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: Colors.black)),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 15.0, 0.0),
                  child: DropdownButton(
                    hint: const Text('Select reason'),
                    value: _chosenValue != '' ? _chosenValue : null,
                    items: reasonList.map((item) {
                      return DropdownMenuItem<String>(
                        child:
                            Text(item['reasons'], textAlign: TextAlign.center),
                        value: item['reasons'],
                      );
                    }).toList(),
                    onChanged: (selected) => setState(() {
                      _chosenValue = selected.toString();
                      final foundPeople = reasonList
                          .where((element) => element['reasons'] == selected);

                      if (foundPeople.isNotEmpty) {
                        setState(() {
                          selectedReason = foundPeople.first['id'];
                        });
                      }
                      print(selectedReason);
                    }),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(10.0, 20.0, 0.0, 0.0),
            child: Text('ETA Comment',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                    color: Colors.black)),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 0.5, 15.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Flexible(
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      controller: commentController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: "Enter Comment",
                      ),
                    ),
                  ),
                ],
              )),
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
            child: InkWell(
              onTap: () async {
                SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();
                print(sharedPreferences.getString('ticket'));
                Response response;
                final Dio dio = Dio();
                dio.options.headers['content-Type'] = 'application/json';
                dio.options.headers["authorization"] =
                    "${sharedPreferences.getString('api_access_token')}";
                response = await dio.post(
                    'http://49.248.144.235/lv/servolutions/api/save-ticket-details',
                    queryParameters: {
                      'ticket_id': sharedPreferences.getString('ticket'),
                      'ticket_eat': etaTime,
                      'reason_id': selectedReason,
                      'description': commentController.text
                    });
                print(response);
                if (response.data['status'] == true) {
                  final snackBar = SnackBar(
                    content: Text(response.data['message'],
                        style: GoogleFonts.poppins(
                            fontSize: 12.0, color: Colors.white)),
                    backgroundColor: (const Color(0xfffcb913)),
                  );
                } else {
                  final snackBar = SnackBar(
                    content: Text(response.data['message'],
                        style: GoogleFonts.poppins(
                            fontSize: 12.0, color: Colors.white)),
                    backgroundColor: (const Color(0xfffcb913)),
                  );
                }
              },
              child: Center(
                child: Container(
                  height: 40.0,
                  width: 80.0,
                  decoration: BoxDecoration(
                    color: const Color(0xfffcb913),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const <Widget>[
                      Center(
                        child: Text(
                          'Submit',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14.0,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
