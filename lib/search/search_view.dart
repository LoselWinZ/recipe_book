import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/shared/constants.dart';

import '../models/recipe.dart';
import '../viewer/viewer.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  @override
  Widget build(BuildContext context) {
    final recipes = Provider.of<List<Recipe>>(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Autocomplete<Recipe>(
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
                  final Recipe option = options.elementAt(index);

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
            return const Iterable<Recipe>.empty();
          }
          return recipes.where((Recipe recipe) => recipe.name!.toLowerCase().contains(value.text.toLowerCase()));
        },
        displayStringForOption: (option) => option.name!,
        onSelected: (option) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Viewer(recipe: option)),
          );
        },
      ),
    );
  }
}
