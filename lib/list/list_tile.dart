import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recipe_book/models/list_model.dart';

import 'ListViewer.dart';

class ListModelTile extends StatelessWidget {
  final ListModel? model;

  const ListModelTile({Key? key, this.model}) : super(key: key);

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
              MaterialPageRoute(builder: (context) => ListViewer(uid: model!.id)),
            );
          },
          contentPadding: const EdgeInsets.only(top: 0),
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(model!.name!, style: const TextStyle(color: Color.fromARGB(255, 198, 193, 185))),
          ),
          // subtitle: Text(model!.created!.toString(), style: const TextStyle(color: Color.fromARGB(255, 198, 193, 185))),
          // isThreeLine: true,
          trailing: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(DateFormat("dd.MM.yyyy").format(model!.created!.toDate()), style: const TextStyle(color: Color.fromARGB(255, 198, 193, 185))),
          ),
          onLongPress: () {},
        ),
      ),
    );
  }
}
