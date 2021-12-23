import 'dart:collection';

class Recipe {
  final String? id;
  final String? author;
  final String? userId;
  final String? name;
  final String? imgLink;
  final int? portions;
  final String? preparation;
  final String? description;
  final String? cooktime;
  final LinkedHashMap? searchableIndex;
  final String? categorie;

  Recipe({this.id, this.author, this.userId, this.name, this.imgLink, this.portions, this.preparation, this.description, this.cooktime, this.categorie, this.searchableIndex});
}
