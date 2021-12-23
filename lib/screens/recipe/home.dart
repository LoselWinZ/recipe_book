import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/screens/recipe/recipe_list.dart';
import 'package:recipe_book/services/database.dart';
import 'package:recipe_book/shared/app_bar.dart';
import '../../models/recipe.dart';
import '../../shared/constants.dart';

class RecipeWidget extends StatelessWidget {
  const RecipeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Recipe>>.value(
      value: DatabaseService().recipes,
      initialData: [],
      child: const Scaffold(
        backgroundColor: backgroundColor,
        appBar: CustomAppBar(),
        body: RecipeList(),
      ),
    );
  }

  RelativeRect buttonMenuPosition(BuildContext context, GlobalKey<State<StatefulWidget>> key) {
    final RenderBox bar = key.currentContext!.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(key.currentContext!)?.context.findRenderObject() as RenderBox;
    const Offset offset = Offset.zero;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        bar.localToGlobal(bar.size.bottomRight(offset), ancestor: overlay),
        bar.localToGlobal(bar.size.bottomRight(offset), ancestor: overlay),
      ),
      offset & overlay.size,
    );
    return position;
  }
}
