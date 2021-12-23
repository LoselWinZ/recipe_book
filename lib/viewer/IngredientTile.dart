import 'package:flutter/material.dart';
import 'package:recipe_book/models/recipe_ingredient.dart';

class IngredientTile extends StatefulWidget {
  final RecipeIngredient? recipeIngredient;

  const IngredientTile({Key? key, this.recipeIngredient}) : super(key: key);

  @override
  _IngredientTileState createState() => _IngredientTileState();
}

class _IngredientTileState extends State<IngredientTile> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(widget.recipeIngredient!.name!),
        const Divider(
          height: 20,
          thickness: 5,
          indent: 20,
          endIndent: 0,
          color: Colors.black,
        ),
      ],
    );
  }
}
