import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/models/recipe.dart';
import 'package:recipe_book/search/search_view.dart';
import 'package:recipe_book/shared/constants.dart';

import '../services/database.dart';

class SearchProvider extends StatefulWidget {
  const SearchProvider({Key? key}) : super(key: key);

  @override
  _SearchProviderState createState() => _SearchProviderState();
}

class _SearchProviderState extends State<SearchProvider> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Recipe>>.value(
      value: DatabaseService().recipes,
      initialData: const [],
      child: Scaffold(backgroundColor: backgroundColor, body: const SearchView()),
    );
  }
}
