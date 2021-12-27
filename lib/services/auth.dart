import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:recipe_book/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_book/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final DatabaseService db = DatabaseService();

  Stream<CustomUser?> get user {
    // return _auth.authStateChanges().map((User? user) => _createCustomCustom(user));
    return _auth.authStateChanges().map(_createCustomCustom);
  }

  Future login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      CustomUser? user = _createCustomCustom(userCredential.user);
      return user;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future logout() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  CustomUser? _createCustomCustom(User? user) {
    if (user != null) {
      return CustomUser(email: user.email, uid: user.uid, displayName: user.displayName);
    }
    return null;
  }

  Future register(String email, String password, String username) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user == null) return null;
      var customCustom = CustomUser(displayName: username, uid: userCredential.user!.uid, email: email);
      await db.createUserData(username, email, customCustom.uid!);
      return customCustom;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
