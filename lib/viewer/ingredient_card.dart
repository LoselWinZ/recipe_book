import 'package:flutter/material.dart';
import 'package:recipe_book/models/recipe_ingredient.dart';
import 'package:recipe_book/services/database.dart';
import 'package:recipe_book/shared/loading.dart';

import '../../models/recipe.dart';
import '../../shared/constants.dart';
import 'ingredient_tile.dart';

class IngredientCard extends StatefulWidget {
  final Recipe recipe;

  const IngredientCard({Key? key, required this.recipe}) : super(key: key);

  @override
  _IngredientCardState createState() => _IngredientCardState();
}

class _IngredientCardState extends State<IngredientCard> {
  final DatabaseService db = DatabaseService();
  int? multiplier;

  @override
  Widget build(BuildContext context) {
    final recipeIngredients = db.recipeIngredientFromRecipe(widget.recipe);
    return StreamBuilder<List<RecipeIngredient>>(
        stream: recipeIngredients,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          }
          return Column(
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
                          Text(
                            'Zutaten',
                            style: coloredText.style,
                            textScaleFactor: 1.5,
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    height: 35,
                                    child: TextButton(
                                        onPressed: () {
                                          if (multiplier == 1) return;
                                          setState(() {
                                            multiplier ??= widget.recipe.portions! - 1;
                                            multiplier = multiplier! - 1;
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: primaryColor,
                                          shape: const CircleBorder(),
                                        ),
                                        child: Icon(
                                          Icons.remove,
                                          color: textColor,
                                          size: 20,
                                        )),
                                  ),
                                  Text('${multiplier != null && multiplier != widget.recipe.portions ? multiplier : widget.recipe.portions} Portionen', style: coloredText.style),
                                  SizedBox(
                                    height: 35,
                                    child: TextButton(
                                        onPressed: () {
                                          if (multiplier == 20) return;
                                          setState(() {
                                            multiplier ??= widget.recipe.portions! + 1;
                                            multiplier = multiplier! + 1;
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: primaryColor,
                                          shape: const CircleBorder(),
                                        ),
                                        child: Icon(
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
                      const SizedBox(height: 20),
                      ListView.builder(
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                IngredientTile(
                                  recipeIngredient: snapshot.data?[index],
                                  multiplier: multiplier,
                                  portion: widget.recipe.portions,
                                ),
                                Divider(
                                  height: 10,
                                  thickness: 0.5,
                                  color: textColor.withAlpha(100),
                                ),
                              ],
                            );
                          },
                          itemCount: snapshot.data != null ? snapshot.data!.length : 0,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics())
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
