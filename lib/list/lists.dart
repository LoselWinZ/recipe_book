import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/list/list_tile.dart';
import 'package:recipe_book/models/list_model.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:recipe_book/shared/constants.dart';

class Lists extends StatefulWidget {
  const Lists({Key? key}) : super(key: key);

  @override
  _ListsState createState() => _ListsState();
}

class _ListsState extends State<Lists> {
  String getGroupHeader(int month) {
    if (month == DateTime.now().month) {
      return "Dieser Monat";
    }
    var dateTime = DateTime.now();
    DateTime(dateTime.year, month);
    return DateFormat("MMMM").format(DateTime(dateTime.year, month));
  }

  @override
  Widget build(BuildContext context) {
    final lists = Provider.of<List<ListModel>>(context);
    return GroupedListView<ListModel, int>(
      elements: lists,
      groupBy: (ListModel element) => element.created!.toDate().month,
      groupSeparatorBuilder: (int groupByValue) => Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Center(
          child: Text(
            getGroupHeader(groupByValue),
            style: coloredText.style,
            textScaleFactor: 1.4,
          ),
        ),
      ),
      order: GroupedListOrder.DESC,
      itemBuilder: (context, index) {
        return ListModelTile(model: index);
      },
    );
  }
}
