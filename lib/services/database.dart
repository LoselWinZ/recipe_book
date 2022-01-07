import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:recipe_book/models/list_item.dart';
import 'package:recipe_book/models/list_model.dart';
import 'package:recipe_book/models/meal_list.dart';
import 'package:recipe_book/models/recipe.dart';
import 'package:recipe_book/models/recipe_ingredient.dart';
import 'package:recipe_book/models/user.dart';

import '../models/categorie.dart';

class DatabaseService {
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference recipeCollection = FirebaseFirestore.instance.collection('recipes');
  final CollectionReference listCollection = FirebaseFirestore.instance.collection('lists');

  Future<void> createUserData(String displayName, String email, String uid) async {
    return await userCollection.doc(uid).set({"displayName": displayName, "email": email, "uid": uid});
  }

  void saveListZutat(ListModel model) {
    listCollection.doc(model.id).update(model.toJson());
  }

  void saveMealListZutat(String listId, MealList model) {
    listCollection.doc(listId).collection('mealList').doc(model.id).update(model.toJson());
  }

  Future<CustomUser> getUserData(String uid) async {
    return await userCollection
        .doc(uid)
        .snapshots()
        .map((DocumentSnapshot documentSnapshot) => CustomUser(email: documentSnapshot["email"], displayName: documentSnapshot["displayName"], uid: documentSnapshot["uid"]))
        .first;
  }

  Stream<ListModel> getList(String id) {
    return listCollection.doc(id).snapshots().map((DocumentSnapshot documentSnapshot) {
      var dynList = documentSnapshot["zutaten"] as List<dynamic>;
      return ListModel(
          name: documentSnapshot["name"],
          id: documentSnapshot["id"],
          userId: documentSnapshot["userId"],
          created: documentSnapshot["created"],
          owner: documentSnapshot["owner"],
          zutaten: dynList.map((e) => ListItem(name: e["name"], checked: e["checked"], amount: e["amount"])).toList());
    });
  }

  Stream<MealList> getMealList(String id) {
    return listCollection.doc(id).collection('mealList').snapshots().map((QuerySnapshot querySnapshot) {
      return querySnapshot.docs.map((QueryDocumentSnapshot documentSnapshot) {
        var dynList = documentSnapshot["recipes"] as List<dynamic>;
        return MealList(
            name: documentSnapshot["name"],
            id: documentSnapshot["id"],
            userId: documentSnapshot["userId"],
            created: documentSnapshot["created"],
            owner: documentSnapshot["owner"],
            recipes: dynList.map((e) => ListItem(name: e["name"], checked: e["checked"], amount: e["amount"])).toList());
      }).toList().first;
    });
  }

  Stream<List<Recipe>> get recipes {
    return recipeCollection.snapshots().map(_recipesFromSnapshot);
  }

  Stream<List<Recipe>> recipesByCategorie(Categorie? categorie) {
    if (categorie == null) return recipes;
    return recipeCollection.where('categorie', isEqualTo: categorie.name == Categorie.Getraenke.name ? 'Getränke' : categorie.name).snapshots().map((event) => _recipesFromSnapshot(event));
  }

  Stream<List<ListModel>> listsByUserId(String? uid) {
    return listCollection.orderBy("created", descending: true).where('userId', isEqualTo: uid).snapshots().map(_listsFromSnapshot);
  }

  Stream<List<MealList>> mealListsByUserId(String? uid) {
    return listCollection.doc(uid).collection('mealList').where('userId', isEqualTo: uid).snapshots().map(_mealListsFromSnapshot);
  }

  List<MealList> _mealListsFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((QueryDocumentSnapshot documentSnapshot) {
      var dynList = documentSnapshot["recipes"] as List<dynamic>;
      return MealList(
          id: documentSnapshot.id,
          name: documentSnapshot["name"],
          recipes: dynList.map((e) => ListItem(name: e["name"], checked: e["checked"], amount: e["amount"])).toList(),
          owner: documentSnapshot["owner"],
          created: documentSnapshot["created"],
          userId: documentSnapshot["userId"]);
    }).toList();
  }

  List<ListModel> _listsFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((QueryDocumentSnapshot documentSnapshot) {
      var dynList = documentSnapshot["zutaten"] as List<dynamic>;
      return ListModel(
          name: documentSnapshot["name"],
          zutaten: dynList.map((e) => ListItem(name: e["name"], checked: e["checked"], amount: e["amount"])).toList(),
          owner: documentSnapshot["owner"],
          id: documentSnapshot["id"],
          created: documentSnapshot["created"],
          userId: documentSnapshot["userId"]);
    }).toList();
  }

  List<Recipe> _recipesFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((QueryDocumentSnapshot documentSnapshot) {
      return Recipe(
          author: documentSnapshot["author"],
          categorie: documentSnapshot["categorie"],
          cooktime: documentSnapshot["cooktime"],
          description: documentSnapshot["description"],
          id: documentSnapshot["id"],
          imgLink: documentSnapshot["imgLink"],
          name: documentSnapshot["name"],
          portions: documentSnapshot["portions"],
          preparation: documentSnapshot["preparation"],
          searchableIndex: documentSnapshot["searchableIndex"],
          userId: documentSnapshot["userId"]);
    }).toList();
  }

  Stream<List<RecipeIngredient>> recipeIngredientFromRecipe(Recipe recipe) {
    return recipeCollection
        .doc(recipe.id)
        .collection('recipeIngredients')
        .orderBy('amount', descending: true)
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs.map((QueryDocumentSnapshot documentSnapshot) {
              return RecipeIngredient(
                  name: documentSnapshot["name"], id: documentSnapshot.id, amount: documentSnapshot["amount"], einheit: documentSnapshot["einheit"], ingredientId: documentSnapshot["ingredientId"]);
            }).toList());
  }
}
