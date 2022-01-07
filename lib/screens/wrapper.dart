import 'package:flutter/material.dart';
import 'package:recipe_book/screens/recipe/recipe_widget.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<CustomUser?>(context);
    // return either recipe or authenticate
    // if (user == null) return const Authenticate();
    return const RecipeWidget();
  }
}
