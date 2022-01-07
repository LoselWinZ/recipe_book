import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/services/parser.dart';
import 'package:recipe_book/shared/app_bar.dart';
import 'package:recipe_book/shared/constants.dart';

import '../create_recipe/creator.dart';
import '../models/recipe.dart';
import '../models/user.dart';
import 'ingredient_card.dart';

class Viewer extends StatefulWidget {
  final Recipe recipe;

  const Viewer({Key? key, required this.recipe}) : super(key: key);

  @override
  _ViewerState createState() => _ViewerState();
}

class _ViewerState extends State<Viewer> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const CustomAppBar(showBackButton: false),
      body: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 1500),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
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
                        Icon(Icons.timer, color: textColor),
                        Text(widget.recipe.cooktime!, style: coloredText.style),
                        Text(' Min.', style: coloredText.style),
                      ],
                    ),
                    IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.clear, color: textColor))
                  ],
                ),
                color: backgroundColorLight,
              ),
              Image.network(widget.recipe.imgLink!, width: 370),
              IngredientCard(recipe: widget.recipe),
              Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      Row(
                        children: [
                          Text("Zubereitung", style: coloredText.style, textScaleFactor: 1.5),
                        ],
                      ),
                      // Text(ParserService().convert(widget.recipe.preparation!), style: coloredText.style),
                      Html(data: widget.recipe.preparation!, style: {"p": Style(color: textColor), "li": Style(color: textColor),"before": Style(color: textColor)})
                    ]),
                  ),
                  color: backgroundColorLight),
              Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(
                        children: [
                          Text("Rezept", style: coloredText.style, textScaleFactor: 1.5),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text('von ${widget.recipe.author}', style: coloredText.style),
                      user != null && user.uid == widget.recipe.userId ? TextButton.icon(
                          icon: Icon(Icons.edit, color: textColor),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const RecipeCreator()),
                            );
                          },
                          label: Text('Bearbeiten', style: coloredText.style)) : Container()
                    ]),
                  ),
                  color: backgroundColorLight)
            ],
          ),
        ),
      ),
    );
  }
}
