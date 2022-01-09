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
  String getGroupHeader(DateTime date) {
    if (date.month == DateTime.now().month) {
      return "Dieser Monat";
    }
    var dateTime = DateTime.now();
    DateTime(dateTime.year, date.month);
    return DateFormat("MMMM").format(DateTime(dateTime.year, date.month));
  }

  @override
  Widget build(BuildContext context) {
    final lists = Provider.of<List<ListModel>>(context);
    return GroupedListView<ListModel, DateTime>(
      elements: lists,
      groupBy: (ListModel element) => DateTime(element.created!.toDate().year, element.created!.toDate().month),
      groupSeparatorBuilder: (DateTime groupByValue) => Padding(
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
      itemComparator: (item1, item2) => item1.created!.compareTo(item2.created!),
      itemBuilder: (context, index) {
        return ListModelTile(model: index);
      },
    );
  }
}
