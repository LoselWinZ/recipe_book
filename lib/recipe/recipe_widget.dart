import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/authenticate/authenticate.dart';
import 'package:recipe_book/create_recipe/creator.dart';
import 'package:recipe_book/models/categorie.dart';
import 'package:recipe_book/models/user.dart';
import 'package:recipe_book/recipe/recipe_list.dart';
import 'package:recipe_book/services/database.dart';
import '../../models/recipe.dart';
import '../../shared/constants.dart';

class RecipeWidget extends StatefulWidget {
  final Function? setIndex;
  const RecipeWidget({Key? key, this.setIndex}) : super(key: key);

  @override
  State<RecipeWidget> createState() => _RecipeWidgetState();
}

class _RecipeWidgetState extends State<RecipeWidget> {
  Categorie? _categorie = Categorie.Hauptgerichte;

  @override
  Widget build(BuildContext context) {
    final CustomUser? user = Provider.of<CustomUser?>(context);
    return StreamProvider<List<Recipe>>.value(
      value: DatabaseService().recipesByCategorie(_categorie),
      initialData: const [],
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
                builder: (context) {
                  return Wrap(
                    children: [
                      Padding(
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
                              value: _categorie,
                              items: Categorie.values
                                  .map((categorie) => DropdownMenuItem(
                                      child: Text(
                                        categorie.name,
                                        style: coloredText.style,
                                      ),
                                      value: categorie))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _categorie = value as Categorie?;
                                });
                                Navigator.pop(context);
                              },
                              dropdownColor: backgroundColorLight,
                              hint: Text('Kategorie', style: coloredText.style),
                              decoration: textInputDecoration,
                              icon: Icon(Icons.arrow_drop_down_outlined, color: textColor),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Rezept erstellen',
                              style: coloredText.style,
                              textScaleFactor: 1.2,
                            ),
                            const SizedBox(height: 20),
                            user != null ? ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: primaryColor, width: 2)))),
                                onPressed: () async {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const RecipeCreator()),
                                  );
                                },
                                child: Text('Neues Rezept erstellen', style: coloredText.style)) : Text("Bitte anmelden", style: coloredText.style,),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  );
                },
                backgroundColor: backgroundColor,
                constraints: const BoxConstraints(maxHeight: 300));
          },
          backgroundColor: primaryColor,
          child: const Icon(Icons.menu),
        ),
        backgroundColor: backgroundColor,
        body: const RecipeList(),
      ),
    );
  }
}
