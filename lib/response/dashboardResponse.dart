import 'dart:convert';

DashboardResponse dashboardResponseFromJson(String str) => DashboardResponse.fromJson(json.decode(str));

String dashboardResponseToJson(DashboardResponse data) => json.encode(data.toJson());

class DashboardResponse {
    DashboardResponse({
        required this.status,
        required this.data,
    });

    bool status;
    Data data;

    factory DashboardResponse.fromJson(Map<String, dynamic> json) => DashboardResponse(
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
        required this.total,
        required this.todays,
        required this.open,
        required this.reopen,
        required this.closed,
        required this.resolved,
        required this.active,
        required this.temporaryClose,
        required this.reassign,
    });

    String total;
    String todays;
    String open;
    String reopen;
    String closed;
    String resolved;
    String active;
    String temporaryClose;
    String reassign;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        total: json["Total"],
        todays: json["Todays"],
        open: json["Open"],
        reopen: json["Reopen"],
        closed: json["Closed"],
        resolved: json["Resolved"],
        active: json["Active"],
        temporaryClose: json["Temporary Close"],
        reassign: json["Reassign"],
    );

    Map<String, dynamic> toJson() => {
        "Total": total,
        "Todays": todays,
        "Open": open,
        "Reopen": reopen,
        "Closed": closed,
        "Resolved": resolved,
        "Active": active,
        "Temporary Close": temporaryClose,
        "Reassign": reassign,
    };
}
