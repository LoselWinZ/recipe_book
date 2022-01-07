import 'package:flutter/material.dart';
import 'package:recipe_book/models/recipe.dart';

import '../../viewer/viewer.dart';

class RecipeTile extends StatelessWidget {
  final Recipe recipe;

  const RecipeTile({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Card(
        color: const Color.fromARGB(255, 35, 38, 39),
        shadowColor: Colors.black,
        elevation: 10,
        margin: const EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Viewer(recipe: recipe)),
            );
          },
          contentPadding: const EdgeInsets.only(top: 0),
          leading: Image.network(
            recipe.imgLink!,
            width: 50,
            fit: BoxFit.cover,
          ),
          title: Text(recipe.name!, style: const TextStyle(color: Color.fromARGB(255, 198, 193, 185))),
          subtitle: Text(recipe.description!, style: const TextStyle(color: Color.fromARGB(255, 198, 193, 185))),
          isThreeLine: true,
          trailing: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(recipe.cooktime! + " Minuten", style: const TextStyle(color: Color.fromARGB(255, 198, 193, 185))),
          ),
        ),
      ),
    );
  }
}
