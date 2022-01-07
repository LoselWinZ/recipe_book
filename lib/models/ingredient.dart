import 'dart:collection';

class Ingredient {
  String? name;
  String? id;
  LinkedHashMap? searchableIndex;

  Ingredient({this.id, this.name, this.searchableIndex});
}
