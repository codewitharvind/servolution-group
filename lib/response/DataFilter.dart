// To parse required this JSON data, do
//
//     final dataFilter = dataFilterFromJson(jsonString);

import 'dart:convert';

DataFilter dataFilterFromJson(String str) => DataFilter.fromJson(json.decode(str));

String dataFilterToJson(DataFilter data) => json.encode(data.toJson());

class DataFilter {
  DataFilter({
    required this.status,
    required this.data,
  });

  bool status;
  Data data;

  factory DataFilter.fromJson(Map<String, dynamic> json) => DataFilter(
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    required this.statusListing,
    required this.bankListing,
    required this.cityListing,
    required this.stateListing,
    required this.serviceListing,
  });

  List<StatusListing> statusListing;
  List<BankListing> bankListing;
  List<CityListing> cityListing;
  List<StateListing> stateListing;
  List<ServiceListing> serviceListing;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    statusListing: List<StatusListing>.from(json["status_listing"].map((x) => StatusListing.fromJson(x))),
    bankListing: List<BankListing>.from(json["bank_listing"].map((x) => BankListing.fromJson(x))),
    cityListing: List<CityListing>.from(json["city_listing"].map((x) => CityListing.fromJson(x))),
    stateListing: List<StateListing>.from(json["state_listing"].map((x) => StateListing.fromJson(x))),
    serviceListing: List<ServiceListing>.from(json["service_listing"].map((x) => ServiceListing.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status_listing": List<dynamic>.from(statusListing.map((x) => x.toJson())),
    "bank_listing": List<dynamic>.from(bankListing.map((x) => x.toJson())),
    "city_listing": List<dynamic>.from(cityListing.map((x) => x.toJson())),
    "state_listing": List<dynamic>.from(stateListing.map((x) => x.toJson())),
    "service_listing": List<dynamic>.from(serviceListing.map((x) => x.toJson())),
  };
}

class BankListing {
  BankListing({
    required this.bankId,
    required this.name,
  });

  int bankId;
  String name;

  factory BankListing.fromJson(Map<String, dynamic> json) => BankListing(
    bankId: json["bank_id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "bank_id": bankId,
    "name": name,
  };
}

class CityListing {
  CityListing({
    required this.cityId,
    required this.cityName,
    required this.stateId,
    required this.state_name,
  });

  int cityId;
  String cityName;
  int stateId;
  String state_name;

  factory CityListing.fromJson(Map<String, dynamic> json) => CityListing(
    cityId: json["city_id"],
    cityName: json["city_name"],
    stateId: json["state_id"],
      state_name:json['state_name']
  );

  Map<String, dynamic> toJson() => {
    "city_id": cityId,
    "city_name": cityName,
    "state_id": stateId,
    "state_name":state_name
  };
}

class ServiceListing {
  ServiceListing({
    required this.serviceName,
    required this.id,
  });

  String serviceName;
  int id;

  factory ServiceListing.fromJson(Map<String, dynamic> json) => ServiceListing(
    serviceName: json["service_name"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "service_name": serviceName,
    "id": id,
  };
}

class StateListing {
  StateListing({
    required this.stateId,
    required this.stateName,
  });

  int stateId;
  String stateName;

  factory StateListing.fromJson(Map<String, dynamic> json) => StateListing(
    stateId: json["state_id"],
    stateName: json["state_name"],
  );

  Map<String, dynamic> toJson() => {
    "state_id": stateId,
    "state_name": stateName,
  };
}

class StatusListing {
  StatusListing({
    required this.statusName,
    required this.id,
  });

  String statusName;
  int id;

  factory StatusListing.fromJson(Map<String, dynamic> json) => StatusListing(
    statusName: json["status_name"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "status_name": statusName,
    "id": id,
  };
}
