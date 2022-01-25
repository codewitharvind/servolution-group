import 'dart:convert';

Counts countsFromJson(String str) => Counts.fromJson(json.decode(str));

String countsToJson(Counts data) => json.encode(data.toJson());

class Counts {
  Counts({
    required this.status,
    required this.data,
  });

  bool status;
  List<Datum> data;

  factory Counts.fromJson(Map<String, dynamic> json) => Counts(
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
    required this.name,
    required this.count,
  });

  String name;
  int count;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    name: json["name"],
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "count": count,
  };

}
