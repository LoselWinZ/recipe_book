import 'package:flutter/material.dart';
import 'package:recipe_book/models/list_item.dart';
import 'package:recipe_book/models/meal_list.dart';
import 'package:recipe_book/shared/constants.dart';

import '../services/database.dart';

class MealListViewer extends StatefulWidget {
  final String? listId;
  final int? previousIndex;

  const MealListViewer({Key? key, this.listId, this.previousIndex}) : super(key: key);

  @override
  _MealListViewerState createState() => _MealListViewerState();
}

class _MealListViewerState extends State<MealListViewer> with TickerProviderStateMixin {
  List<ListItem> items = List.empty();
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String amount = '';

  @override
  Widget build(BuildContext context) {
    final DatabaseService db = DatabaseService();
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _amountController = TextEditingController();

    return StreamBuilder<MealList?>(
        stream: db.getMealList(widget.listId!),
        builder: (context, snapshot) {
          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Gerichte - ${snapshot.data != null ? snapshot.data!.name : ''}",
                      style: coloredText.style,
                      textScaleFactor: 1.2,
                    ),
                    IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.clear, color: textColor))
                  ],
                ),
                Text(
                  snapshot.data != null && snapshot.data!.recipes!.isNotEmpty
                      ? "${snapshot.data!.recipes!.where((element) => element.checked!).length} von ${snapshot.data!.recipes!.length} Gerichte"
                      : "Keine Gerichte",
                  style: coloredText.style,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data != null ? snapshot.data!.recipes!.length : 0,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key(snapshot.data!.recipes![index].name!),
                        background: Container(color: Colors.red),
                        onDismissed: (direction) {
                          snapshot.data!.recipes!.removeAt(index);
                          db.saveMealListZutat(widget.listId!, snapshot.data!);
                        },
                        child: GestureDetector(
                          onLongPress: () {
                            _nameController.text = snapshot.data!.recipes![index].name!;
                            name = snapshot.data!.recipes![index].name!;
                            _amountController.text = snapshot.data!.recipes![index].amount!;
                            amount = snapshot.data!.recipes![index].amount!;
                            openModal(context, _nameController, snapshot, db, _amountController, true, snapshot.data!.recipes![index]);
                          },
                          child: Material(
                            child: CheckboxListTile(
                                title: Text(
                                  snapshot.data!.recipes![index].amount! + ' ' + snapshot.data!.recipes![index].name!,
                                  style: snapshot.data!.recipes![index].checked! ? coloredText.style?.copyWith(decoration: TextDecoration.lineThrough) : coloredText.style,
                                ),
                                checkColor: Colors.white,
                                tileColor: snapshot.data!.recipes![index].checked! ? backgroundColorLight : backgroundColor,
                                activeColor: primaryColor,
                                selectedTileColor: primaryColor,
                                value: snapshot.data!.recipes![index].checked,
                                onChanged: (bool? value) {
                                  snapshot.data!.recipes![index].checked = value!;
                                  db.saveMealListZutat(widget.listId!, snapshot.data!);
                                },
                                controlAffinity: ListTileControlAffinity.leading),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                openModal(context, _nameController, snapshot, db, _amountController, false);
              },
              backgroundColor: primaryColor,
              child: const Icon(Icons.style),
            ),
            backgroundColor: backgroundColor,
          );
        });
  }

  void openModal(BuildContext context, TextEditingController _controller, AsyncSnapshot<MealList?> snapshot, DatabaseService db, TextEditingController _amountController, bool edit, [ListItem? item]) {
    showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
            builder: (context) {
              debugPrint(amount);
              return Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Form(
                  key: _formKey,
                  child: Wrap(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              'Gericht Hinzufügen',
                              style: coloredText.style,
                              textScaleFactor: 1.2,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              autofocus: true,
                              onChanged: (val) => setState(() => name = val),
                              validator: (val) => val!.isEmpty ? 'Bitte ausfüllen' : null,
                              style: coloredText.style,
                              decoration: textInputDecoration.copyWith(hintText: 'Name', prefixIcon: Icon(Icons.text_snippet_outlined, color: textColor)),
                              controller: _controller,
                              onFieldSubmitted: (value) {
                                if (!edit) saveItem(snapshot, db);
                                if (edit) updateItem(snapshot, db, item!);
                                _controller.clear();
                              },
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: primaryColor, width: 2)))),
                                onPressed: () async {
                                  if (!edit) saveItem(snapshot, db);
                                  if (edit) updateItem(snapshot, db, item!);
                                  _amountController.clear();
                                  _controller.clear();
                                },
                                child: Text(edit ? 'Übernehmen' : 'Erstellen', style: coloredText.style)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            backgroundColor: backgroundColor)
        .whenComplete(() {
      _controller.clear();
      _amountController.clear();
    });
  }

  void saveItem(AsyncSnapshot<MealList?> snapshot, DatabaseService db) {
    ListItem item = ListItem(amount: amount, checked: false, name: name);
    if (snapshot.data!.recipes!.where((element) => element.name == item.name).isEmpty) {
      snapshot.data!.recipes!.add(item);
    } else {
      int indexWhere = snapshot.data!.recipes!.indexWhere((element) => element.name == item.name);
      snapshot.data!.recipes![indexWhere].amount =
          ((snapshot.data!.recipes![indexWhere].amount!.isEmpty ? 1 : int.parse(snapshot.data!.recipes![indexWhere].amount!)) + (item.amount!.isEmpty ? 1 : int.parse(item.amount!))).toString();
    }
    db.saveMealListZutat(widget.listId!, snapshot.data!);
    amount = '';
    name = '';
  }

  void updateItem(AsyncSnapshot<MealList?> snapshot, DatabaseService db, ListItem providedItem) {
    ListItem item = ListItem(amount: providedItem.amount, checked: providedItem.checked, name: providedItem.name);
    item.amount = amount;
    item.name = name;
    var position = snapshot.data!.recipes!.indexOf(providedItem);
    snapshot.data!.recipes!.removeAt(position);
    snapshot.data!.recipes!.insert(position, item);
    db.saveMealListZutat(widget.listId!, snapshot.data!);
    amount = '';
    name = '';
  }
}
