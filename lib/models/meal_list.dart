import 'package:cloud_firestore/cloud_firestore.dart';

import 'list_item.dart';

class MealList {
  final Timestamp? created;
  final String? name;
  final String? id;
  final String? owner;
  final String? userId;
  final List<ListItem>? recipes;

  MealList({this.created, this.name, this.owner, this.userId, this.recipes, this.id});

  Map<String, Object?> toJson() {
    return {"id": id, "created": created, "name": name, "owner": owner, "userId": userId, "recipes": recipes?.map((e) => e.toJson()).toList()};
  }
}