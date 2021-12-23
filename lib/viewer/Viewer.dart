import 'package:flutter/material.dart';
import 'package:recipe_book/shared/app_bar.dart';
import 'package:recipe_book/shared/constants.dart';

import '../models/recipe.dart';
import 'IngredientCard.dart';

class Viewer extends StatefulWidget {
  final Recipe recipe;

  const Viewer({Key? key, required this.recipe}) : super(key: key);

  @override
  _ViewerState createState() => _ViewerState();
}

class _ViewerState extends State<Viewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const CustomAppBar(showBackButton: false),
      body: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(widget.recipe.name!, style: coloredText.style, softWrap: true, overflow: TextOverflow.ellipsis),
                ),
                Row(
                  children: [
                    const Icon(Icons.timer, color: textColor),
                    Text(widget.recipe.cooktime!, style: coloredText.style),
                    Text(' Min.', style: coloredText.style),
                  ],
                ),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.clear, color: textColor))
              ],
            ),
            color: backgroundColorLight,
          ),
          Image.network(widget.recipe.imgLink!, width: 370),
          Flexible(child: IngredientCard(recipe: widget.recipe))
        ],
      ),
    );
  }
}
