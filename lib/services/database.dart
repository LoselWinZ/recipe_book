import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_book/models/recipe.dart';
import 'package:recipe_book/models/recipe_ingredient.dart';
import 'package:recipe_book/models/user.dart';

import '../models/categorie.dart';

class DatabaseService {
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference recipeCollection = FirebaseFirestore.instance.collection('recipes');

  Future<void> createUserData(String displayName, String email, String uid) async {
    return await userCollection.doc(uid).set({"displayName": displayName, "email": email, "uid": uid});
  }

  Future<CustomUser> getUserData(String uid) async {
    return await userCollection
        .doc(uid)
        .snapshots()
        .map((DocumentSnapshot documentSnapshot) => CustomUser(email: documentSnapshot["email"], displayName: documentSnapshot["displayName"], uid: documentSnapshot["uid"]))
        .first;
  }

  Stream<List<Recipe>> get recipes {
    return recipeCollection.snapshots().map(_recipesFromSnapshot);
  }

  Stream<List<Recipe>> recipesByCategorie(Categorie? categorie) {
    if (categorie == null) return recipes;
    return recipeCollection.where('categorie', isEqualTo: categorie.name == Categorie.Getraenke.name ? 'Getränke' : categorie.name).snapshots().map((event) => _recipesFromSnapshot(event));
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
