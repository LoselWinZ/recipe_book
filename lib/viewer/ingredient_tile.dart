import 'package:flutter/material.dart';
import 'package:recipe_book/models/recipe_ingredient.dart';
import 'package:recipe_book/shared/constants.dart';

class IngredientTile extends StatefulWidget {
  final RecipeIngredient? recipeIngredient;
  final int? multiplier;
  final int? portion;

  const IngredientTile({Key? key, this.recipeIngredient, this.multiplier, this.portion}) : super(key: key);

  @override
  _IngredientTileState createState() => _IngredientTileState();

}

class _IngredientTileState extends State<IngredientTile> {
  String _calcAmount(String amount) {
    if(widget.portion == null || widget.multiplier == null) return amount;
    int intAmount = amount != '' ? int.parse(amount): 0;
    int newAmount = ((intAmount / widget.portion!) * widget.multiplier!).toInt();
    return newAmount == 0 ? '' : newAmount.toString();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: GridView.count(crossAxisCount: 2, primary: false, physics: const NeverScrollableScrollPhysics() ,children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _calcAmount(widget.recipeIngredient!.amount!),
              style: coloredText.style,
            ),
            Text(
              widget.recipeIngredient!.einheit!,
              style: coloredText.style,
            ),
          ],
        ),
        Text(
          widget.recipeIngredient!.name!,
          style: coloredText.style,
        )
      ]),
    );
  }
}
