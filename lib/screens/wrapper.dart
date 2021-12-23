import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/models/user.dart';
import 'package:recipe_book/screens/authenticate/authenticate.dart';
import 'package:recipe_book/screens/recipe/home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);
    // return either recipe or authenticate
    // if (user == null) return const Authenticate();
    return const RecipeWidget();
  }
}
