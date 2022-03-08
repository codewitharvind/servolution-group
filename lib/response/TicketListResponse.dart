// To parse required this JSON data, do
//
//     final ticketListResponse = ticketListResponseFromJson(jsonString);

import 'dart:convert';

TicketListResponse ticketListResponseFromJson(String str) => TicketListResponse.fromJson(json.decode(str));

String ticketListResponseToJson(TicketListResponse data) => json.encode(data.toJson());

class TicketListResponse {
  TicketListResponse({
    required this.status,
    required this.data,
  });

  bool status;
  List<Datum> data;

  factory TicketListResponse.fromJson(Map<String, dynamic> json) => TicketListResponse(
    status: json["status"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required this.ticketNumber,
    required this.atmNo,
    required this.siteId,
    required this.createdAt,
    required this.statusName,
    required this.cityName,
    required this.stateName,
    required this.name,
    required this.serviceName,
  });

  String ticketNumber;
  String atmNo;
  String siteId;
  DateTime createdAt;
  String statusName;
  String cityName;
  String stateName;
  String name;
  String serviceName;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    ticketNumber: json["ticket_number"],
    atmNo: json["atm_no"],
    siteId: json["site_id"],
    createdAt: DateTime.parse(json["created_at"]),
    statusName:json["status_name"],
    cityName: json["city_name"],
    stateName: json["state_name"],
    name: json["name"],
    serviceName: json["service_name"],
  );

  Map<String, dynamic> toJson() => {
    "ticket_number": ticketNumber,
    "atm_no": atmNo,
    "site_id": siteId,
    "created_at": createdAt.toIso8601String(),
    "status_name":statusName,
    "city_name": cityName,
    "state_name": stateName,
    "name": name,
    "service_name": serviceName,
  };
}


