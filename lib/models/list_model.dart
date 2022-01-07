import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_book/models/list_item.dart';

class ListModel {
  final Timestamp? created;
  final String? id;
  final String? name;
  final String? owner;
  final String? userId;
  final List<ListItem>? zutaten;

  ListModel({this.created, this.id, this.name, this.owner, this.userId, this.zutaten});


  Map<String, Object?> toJson() {
    return {"id": id, "created": created, "name": name, "owner": owner, "userId": userId, "zutaten": zutaten?.map((e) => e.toJson()).toList()};
  }

}
