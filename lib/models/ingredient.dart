import 'dart:collection';

class Ingredient {
  String? name;
  String? id;
  LinkedHashMap? searchableIndex;

  Ingredient({this.id, this.name, this.searchableIndex});

  static Ingredient fromJson(Map<String, dynamic> json) {
    return Ingredient(name: json['name'], id: json['objectID']);
  }
}
