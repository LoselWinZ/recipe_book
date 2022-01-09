import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';
import 'package:recipe_book/shared/constants.dart';

import '../models/recipe.dart';
import '../services/algolia.dart';
import '../viewer/viewer.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {

  AlgoliaAPI algoliaAPI = AlgoliaAPI();
  List<Recipe> _hitsList = [];

  Future<void> _getSearchResult(String query) async {
    if (query.isEmpty) {
      return Future.value('');
    }
    List<AlgoliaObjectSnapshot>? response = await algoliaAPI.search(query, 'recipes');
    var hitsList = response!.map((json) {
      return Recipe(
          id: json.objectID,
          name: json.data["name"],
          userId: json.data["userId"],
          preparation: json.data["preparation"],
          portions: json.data["portions"],
          imgLink: json.data["imgLink"],
          description: json.data["description"],
          cooktime: json.data["cooktime"],
          categorie: json.data["categorie"],
          author: json.data["author"]);
    }).toList();
    setState(() {
      _hitsList = hitsList;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        optionsBuilder: (TextEditingValue value) async {
          if (value.text == '') {
            return const Iterable<Recipe>.empty();
          }
          await _getSearchResult(value.text);
          return _hitsList;
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
