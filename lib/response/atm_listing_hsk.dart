// To parse this JSON data, do
//
//     final ticketListResponse = ticketListResponseFromJson(jsonString);

import 'dart:convert';

TicketListResponse ticketListResponseFromJson(String str) => TicketListResponse.fromJson(json.decode(str));

String ticketListResponseToJson(TicketListResponse data) => json.encode(data.toJson());

class TicketListResponse {
  TicketListResponse({
    required this.status,
    required this.data,
    required this.filepath,
  });

  bool status;
  List<Datum> data;
  String filepath;

  factory TicketListResponse.fromJson(Map<String, dynamic> json) => TicketListResponse(
    status: json["status"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    filepath: json["filepath"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "filepath": filepath,
  };
}

class Datum {
  Datum({
    required this.id,
    required this.siteId,
    required this.scopeOfWork,
    required this.username,
    required this.date,
    required  this.atmId,
    required this.fkAtmId,
  });

  int id;
  String siteId;
  String scopeOfWork;
  String username;
  DateTime date;
  String atmId;
  String fkAtmId;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    siteId: json["site_id"],
    scopeOfWork: json["scope_of_work"],
    username: json["username"],
    date: DateTime.parse(json["date"]),
    atmId: json["atm_id"],
    fkAtmId: json["fk_atm_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "site_id": siteId,
    "scope_of_work": scopeOfWork,
    "username": username,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "atm_id": atmId,
    "fk_atm_id": fkAtmId,
  };
}
