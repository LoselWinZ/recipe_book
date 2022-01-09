import 'package:flutter/material.dart';

import '../models/list_item.dart';
import '../models/list_model.dart';
import '../services/database.dart';

bool dark = true;

InputDecoration textInputDecoration = InputDecoration(
    hintStyle: TextStyle(color: textColor),
    fillColor: const Color.fromARGB(255, 35, 38, 39),
    filled: true,
    enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: primaryColor, width: 2)),
    focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: primaryColor, width: 2)));

const coloredText = Text("", style: TextStyle(color: Color.fromARGB(255, 198, 193, 185)));

Color backgroundColorDark = dark ? const Color.fromARGB(255, 14, 15, 15) : const Color.fromARGB(255, 226, 226, 226);

Color textColor = dark ? const Color.fromARGB(255, 198, 193, 185) : const Color.fromARGB(255, 44, 44, 44);

Color backgroundColor = dark ? const Color.fromARGB(255, 24, 26, 27) : const Color.fromARGB(255, 226, 226, 226);

Color backgroundColorLight = dark ? const Color.fromARGB(255, 35, 38, 39) : Colors.white;

const primaryColor = Color.fromARGB(255, 67, 160, 71);

DatabaseService db = DatabaseService();

void saveItem(AsyncSnapshot<ListModel?> snapshot, String name, String amount) {
  ListItem item = ListItem(amount: amount, checked: false, name: name);
  if (snapshot.data!.zutaten!.where((element) => element.name == item.name).isEmpty) {
    snapshot.data!.zutaten!.add(item);
  } else {
    int indexWhere = snapshot.data!.zutaten!.indexWhere((element) => element.name == item.name);
    snapshot.data!.zutaten![indexWhere].amount =
        ((snapshot.data!.zutaten![indexWhere].amount!.isEmpty ? 1 : int.parse(snapshot.data!.zutaten![indexWhere].amount!)) + (item.amount!.isEmpty ? 1 : int.parse(item.amount!))).toString();
  }
  db.saveListZutat(snapshot.data!);
}

void updateItem(AsyncSnapshot<ListModel?> snapshot, ListItem providedItem, String name, String amount) {
  ListItem item = ListItem(amount: providedItem.amount, checked: providedItem.checked, name: providedItem.name);
  item.amount = amount;
  item.name = name;
  var position = snapshot.data!.zutaten!.indexOf(providedItem);
  snapshot.data!.zutaten!.removeAt(position);
  snapshot.data!.zutaten!.insert(position, item);
  db.saveListZutat(snapshot.data!);
}
