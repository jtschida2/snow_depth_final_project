// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

SnowWeather snowWeatherFromJson(String str) => SnowWeather.fromJson(json.decode(str));

String welcomeToJson(SnowWeather data) => json.encode(data.toJson());

class SnowWeather {
  String apiVersion;
  int totalItems;
  List<Item> items;

  SnowWeather({
    required this.apiVersion,
    required this.totalItems,
    required this.items,
  });

  factory SnowWeather.fromJson(Map<String, dynamic> json) => SnowWeather(
    apiVersion: json["apiVersion"],
    totalItems: json["totalItems"],
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "apiVersion": apiVersion,
    "totalItems": totalItems,
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}

class Item {
  String id;
  String resortName;
  String state;
  DateTime reportDateTime;
  ResortType resortType;
  String newSnowMin;
  String newSnowMax;
  String avgBaseDepthMin;
  String avgBaseDepthMax;
  String snowLast48Hours;
  String snowComments;

  Item({
    required this.id,
    required this.resortName,
    required this.state,
    required this.reportDateTime,
    required this.resortType,
    required this.newSnowMin,
    required this.newSnowMax,
    required this.avgBaseDepthMin,
    required this.avgBaseDepthMax,
    required this.snowLast48Hours,
    required this.snowComments,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    resortName: json["resortName"],
    state: json["state"],
    reportDateTime: DateTime.parse(json["reportDateTime"]),
    resortType: resortTypeValues.map[json["resortType"]]!,
    newSnowMin: json["newSnowMin"],
    newSnowMax: json["newSnowMax"],
    avgBaseDepthMin: json["avgBaseDepthMin"],
    avgBaseDepthMax: json["avgBaseDepthMax"],
    snowLast48Hours: json["snowLast48Hours"],
    snowComments: json["snowComments"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "resortName": resortName,
    "state": state,
    "reportDateTime": reportDateTime.toIso8601String(),
    "resortType": resortTypeValues.reverse[resortType],
    "newSnowMin": newSnowMin,
    "newSnowMax": newSnowMax,
    "avgBaseDepthMin": avgBaseDepthMin,
    "avgBaseDepthMax": avgBaseDepthMax,
    "snowLast48Hours": snowLast48Hours,
    "snowComments": snowComments,
  };
}

enum ResortType {
  INTL,
  NA_ALPINE
}

final resortTypeValues = EnumValues({
  "Intl": ResortType.INTL,
  "NA_Alpine": ResortType.NA_ALPINE
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
