// To parse this JSON data, do
//
//     final cat = catFromJson(jsonString);

import 'package:cat_ui/models/breed_model.dart';
import 'dart:convert';

List<Cat> catFromJson(String str) => List<Cat>.from(json.decode(str).map((x) => Cat.fromJson(x)));

String catToJson(List<Cat> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Cat {
  Cat({
   this.breeds,
   this.id,
   this.url,
   this.width,
   this.height,
  });

  List<dynamic>? breeds;
  String? id;
  String? url;
  int? width;
  int? height;

  factory Cat.fromJson(Map<String, dynamic> json) => Cat(
    breeds: List<dynamic>.from(json["breeds"].map((x) => x)),
    id: json["id"],
    url: json["url"],
    width: json["width"],
    height: json["height"],
  );

  Map<String, dynamic> toJson() => {
    "breeds": List<Breed>.from(breeds!.map((x) => x)),
    "id": id,
    "url": url,
    "width": width,
    "height": height,
  };
}