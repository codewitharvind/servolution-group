import 'dart:convert';

DateRangeResponse dateRangeResponseFromJson(String str) =>
    DateRangeResponse.fromJson(json.decode(str));

String dateRangeResponseToJson(DateRangeResponse data) =>
    json.encode(data.toJson());

class DateRangeResponse {
  DateRangeResponse({
    required this.status,
    required this.data,
  });

  bool status;
  Data data;

  factory DateRangeResponse.fromJson(Map<String, dynamic> json) =>
      DateRangeResponse(
        status: json["status"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class Data {
  Data(
      {required this.total,
      required this.srm,
      required this.flm,
      required this.hsk,
      required this.qrt,
      required this.cctv});

  String total;
  String srm;
  String flm;
  String hsk;
  String qrt;
  String cctv;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
      total: json["Total"],
      srm: json["SRM"],
      flm: json["FLM"],
      hsk: json["HSK"],
      qrt: json["QRT"],
      cctv: json["CCTV"]);

  Map<String, dynamic> toJson() => {
        "Total": total,
        "SRM": srm,
        "FLM": flm,
        "HSK": hsk,
        "QRT": qrt,
        "CCTV": cctv,
      };
}
