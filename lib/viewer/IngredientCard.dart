import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/models/recipe_ingredient.dart';
import 'package:recipe_book/services/database.dart';
import 'package:recipe_book/shared/loading.dart';

import '../../models/recipe.dart';
import '../../shared/constants.dart';
import 'IngredientTile.dart';

class IngredientCard extends StatefulWidget {
  final Recipe recipe;

  const IngredientCard({Key? key, required this.recipe}) : super(key: key);

  @override
  _IngredientCardState createState() => _IngredientCardState();
}

class _IngredientCardState extends State<IngredientCard> {
  final DatabaseService db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    final recipeIngredients = db.recipeIngredientFromRecipe(widget.recipe);
    return StreamBuilder<List<RecipeIngredient>>(
        stream: recipeIngredients,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          }
          return ListView(
            children: [
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('Zutaten', style: coloredText.style),
                              Row(
                                children: [
                                  SizedBox(
                                    height: 35,
                                    child: TextButton(
                                        onPressed: () {},
                                        style: TextButton.styleFrom(
                                          backgroundColor: primaryColor,
                                          shape: const CircleBorder(),
                                        ),
                                        child: const Icon(
                                          Icons.remove,
                                          color: textColor,
                                          size: 20,
                                        )),
                                  ),
                                  Text('${widget.recipe.portions} Portionen', style: coloredText.style),
                                  SizedBox(
                                    height: 35,
                                    child: TextButton(
                                        onPressed: () {},
                                        style: TextButton.styleFrom(
                                          backgroundColor: primaryColor,
                                          shape: const CircleBorder(),
                                        ),
                                        child: const Icon(
                                          Icons.add,
                                          color: textColor,
                                          size: 20,
                                        )),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                      ListView.builder(
                          itemBuilder: (context, index) => IngredientTile(recipeIngredient: snapshot.data?[index]),
                          itemCount: snapshot.data != null ? snapshot.data!.length : 0,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true)
                    ],
                  ),
                ),
                color: backgroundColorLight,
              )
            ],
          );
        });
  }
}
