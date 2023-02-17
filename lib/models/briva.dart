// To parse this JSON data, do
//
//     final briva = brivaFromJson(jsonString);

import 'dart:convert';

Briva brivaFromJson(String str) => Briva.fromJson(json.decode(str));

String brivaToJson(Briva data) => json.encode(data.toJson());

class Briva {
  Briva({
    required this.status,
    required this.responseDescription,
    required this.responseCode,
    required this.data,
  });

  bool status;
  String responseDescription;
  String responseCode;
  Data data;

  factory Briva.fromJson(Map<String, dynamic> json) => Briva(
        status: json["status"],
        responseDescription: json["responseDescription"],
        responseCode: json["responseCode"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "responseDescription": responseDescription,
        "responseCode": responseCode,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.institutionCode,
    required this.brivaNo,
    required this.custCode,
    required this.nama,
    required this.amount,
    required this.keterangan,
    required this.expiredDate,
  });

  String institutionCode;
  String brivaNo;
  String custCode;
  String nama;
  String amount;
  String keterangan;
  DateTime expiredDate;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        institutionCode: json["institutionCode"],
        brivaNo: json["brivaNo"],
        custCode: json["custCode"],
        nama: json["nama"],
        amount: json["amount"],
        keterangan: json["keterangan"],
        expiredDate: DateTime.parse(json["expiredDate"]),
      );

  Map<String, dynamic> toJson() => {
        "institutionCode": institutionCode,
        "brivaNo": brivaNo,
        "custCode": custCode,
        "nama": nama,
        "amount": amount,
        "keterangan": keterangan,
        "expiredDate": expiredDate.toIso8601String(),
      };
}
