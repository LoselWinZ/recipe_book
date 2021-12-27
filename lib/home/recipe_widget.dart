import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/models/categorie.dart';
import 'package:recipe_book/screens/recipe/recipe_list.dart';
import 'package:recipe_book/services/database.dart';
import '../models/recipe.dart';
import '../shared/constants.dart';

class RecipeWidget extends StatefulWidget {
  const RecipeWidget({Key? key}) : super(key: key);

  @override
  State<RecipeWidget> createState() => _RecipeWidgetState();
}

class _RecipeWidgetState extends State<RecipeWidget> {
  Categorie? _categorie = Categorie.Hauptgerichte;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Recipe>>.value(
      value: DatabaseService().recipesByCategorie(_categorie),
      initialData: const [],
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          'Kategorie auswählen',
                          style: coloredText.style,
                          textScaleFactor: 1.2,
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField(
                          items: Categorie.values.map((categorie) => DropdownMenuItem(child: Text(categorie.name, style: coloredText.style,), value: categorie)).toList(),
                          onChanged: (value) {
                            setState(() {
                              _categorie = value as Categorie?;
                            });
                          },
                          dropdownColor: backgroundColorLight,
                          hint: Text('Kategorie', style: coloredText.style),
                          decoration: textInputDecoration,
                          icon: Icon(Icons.arrow_drop_down_outlined, color: textColor),
                        )
                      ],
                    ),
                  );
                },
                backgroundColor: backgroundColor, constraints: const BoxConstraints(maxHeight: 150));
          },
          backgroundColor: primaryColor,
          child: const Icon(Icons.category),
        ),
        backgroundColor: backgroundColor,
        body: const RecipeList(),
      ),
    );
  }
}
