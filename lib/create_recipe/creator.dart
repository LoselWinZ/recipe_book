import 'package:flutter/material.dart';
import 'package:recipe_book/models/ingredient.dart';
import 'package:recipe_book/models/recipe.dart';
import 'package:recipe_book/services/database.dart';
import 'package:recipe_book/shared/app_bar.dart';
import 'package:recipe_book/shared/constants.dart';

import '../models/categorie.dart';

class RecipeCreator extends StatefulWidget {
  const RecipeCreator({Key? key}) : super(key: key);

  @override
  _RecipeCreatorState createState() => _RecipeCreatorState();
}

class _RecipeCreatorState extends State<RecipeCreator> {
  final DatabaseService db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    Recipe recipe = Recipe();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const CustomAppBar(text: "Gericht erstellen", showBackButton: true),
      body: PageView(
        controller: controller,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Informationen",
                    style: coloredText.style,
                    textScaleFactor: 2,
                  ),
                  TextFormField(
                      onChanged: (val) => setState(() => recipe.name = val),
                      validator: (val) => val!.isEmpty ? 'Bitte ausfüllen' : null,
                      style: coloredText.style,
                      decoration: textInputDecoration.copyWith(hintText: 'Name', prefixIcon: Icon(Icons.restaurant_menu, color: textColor))),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: TextFormField(
                            keyboardType: TextInputType.number,
                            onChanged: (val) => setState(() => recipe.cooktime = val),
                            validator: (val) => val!.isEmpty ? 'Bitte ausfüllen' : null,
                            style: coloredText.style,
                            decoration: textInputDecoration.copyWith(hintText: 'Zubereitungszeit', prefixIcon: Icon(Icons.access_time, color: textColor))),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                            keyboardType: TextInputType.number,
                            onChanged: (val) => setState(() => recipe.portions = int.parse(val)),
                            validator: (val) => val!.isEmpty ? 'Bitte ausfüllen' : null,
                            style: coloredText.style,
                            decoration: textInputDecoration.copyWith(hintText: 'Portionen', prefixIcon: Icon(Icons.pie_chart, color: textColor))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField(
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
                        recipe.categorie = value as String;
                      });
                    },
                    dropdownColor: backgroundColorLight,
                    hint: Text('Kategorie', style: coloredText.style),
                    decoration: textInputDecoration,
                    icon: Icon(Icons.arrow_drop_down_outlined, color: textColor),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      onChanged: (val) => setState(() => recipe.description = val),
                      validator: (val) => val!.isEmpty ? 'Bitte ausfüllen' : null,
                      style: coloredText.style,
                      decoration: textInputDecoration.copyWith(hintText: 'Beschreibung', prefixIcon: Icon(Icons.pie_chart, color: textColor))),
                  const Expanded(child: SizedBox(height: 0)),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: primaryColor, width: 2)))),
                            onPressed: () async {
                              controller.animateTo(MediaQuery.of(context).size.width, duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
                            },
                            child: Text('Weiter', style: coloredText.style)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Autocomplete<Ingredient>(
            fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
              return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  style: coloredText.style,
                  decoration: textInputDecoration.copyWith(
                      hintText: 'Suche...',
                      prefixIcon: Icon(Icons.search, color: textColor),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear, color: textColor),
                        onPressed: () {
                          textEditingController.clear();
                        },
                        splashRadius: 1,
                      )));
            },
            optionsViewBuilder: (context, onSelected, options) {
              return Material(
                child: Container(
                  color: backgroundColor,
                  child: ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Ingredient option = options.elementAt(index);

                      return GestureDetector(
                        onTap: () {
                          onSelected(option);
                        },
                        child: ListTile(
                          title: Text(option.name!, style: coloredText.style),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
            optionsBuilder: (TextEditingValue value) {
              if (value.text == '') {
                return const Iterable<Ingredient>.empty();
              }
              return Iterable<Ingredient>.empty();
            },
            displayStringForOption: (option) => option.name!,
            onSelected: (option) {
            },
          ),
          Center(
            child: Text('Third Page'),
          )
        ],
      ),
    );
  }
}
