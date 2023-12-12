// To parse this JSON data, do
//
//     final listModel = listModelFromJson(jsonString);

import 'dart:convert';

ListModel listModelFromJson(String str) => ListModel.fromJson(json.decode(str));

String listModelToJson(ListModel data) => json.encode(data.toJson());

class ListModel {
  int? id;
  String? title;
  List<SubDatum>? subData;

  ListModel({
    this.id,
    this.title,
    this.subData,
  });

  factory ListModel.fromJson(Map<String, dynamic> json) => ListModel(
        id: json["id"],
        title: json["title"],
        subData: json["subData"] == null
            ? []
            : List<SubDatum>.from(
                json["subData"]!.map((x) => SubDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "subData": subData == null
            ? []
            : List<dynamic>.from(subData!.map((x) => x.toJson())),
      };
}

class SubDatum {
  int? id;
  String? title;

  SubDatum({
    this.id,
    this.title,
  });

  factory SubDatum.fromJson(Map<String, dynamic> json) => SubDatum(
        id: json["id"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
      };
}
