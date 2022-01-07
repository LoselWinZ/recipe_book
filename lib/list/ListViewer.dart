import 'package:flutter/material.dart';
import 'package:recipe_book/models/list_item.dart';
import 'package:recipe_book/models/list_model.dart';
import 'package:recipe_book/models/meal_list.dart';
import 'package:recipe_book/shared/app_bar.dart';
import 'package:recipe_book/shared/constants.dart';

import '../services/database.dart';
import 'meal_list_viewer.dart';

class ListViewer extends StatefulWidget {
  final String? uid;

  const ListViewer({Key? key, this.uid}) : super(key: key);

  @override
  _ListViewerState createState() => _ListViewerState();
}

class _ListViewerState extends State<ListViewer> with TickerProviderStateMixin {
  TabController? tabController;
  List<ListItem> items = List.empty();
  final _formKey = GlobalKey<FormState>();
  GlobalKey<_ListViewerState> globalKey = GlobalKey();

  String name = '';
  String amount = '';

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseService db = DatabaseService();
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _amountController = TextEditingController();

    String clearList(ListModel listmodel) {
      listmodel.zutaten!.clear();
      db.saveListZutat(listmodel);
      return '';
    }

    return StreamBuilder<ListModel?>(
        stream: db.getList(widget.uid!),
        builder: (context, snapshot) {
          return Scaffold(
            appBar: CustomAppBar(showBackButton: false, isList: true, removeAll: clearList, listModel: snapshot.hasData ? snapshot.data! : ListModel()),
            backgroundColor: backgroundColor,
            body: Column(
              children: [
                TabBar(
                  controller: tabController,
                  indicatorColor: primaryColor,
                  tabs: const <Widget>[
                    Tab(
                      text: 'Liste',
                      // icon: Icon(Icons.list),
                    ),
                    Tab(
                      text: 'Gerichte',
                      // icon: Icon(Icons.beach_access_sharp),
                    )
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Einkausliste - ${snapshot.data != null ? snapshot.data!.name : ''}",
                                style: coloredText.style,
                                textScaleFactor: 1.2,
                              ),
                              IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.clear, color: textColor))
                            ],
                          ),
                          Text(
                            snapshot.data != null && snapshot.data!.zutaten!.isNotEmpty
                                ? "${snapshot.data!.zutaten!.where((element) => element.checked!).length} von ${snapshot.data!.zutaten!.length} Zutaten"
                                : "Keine Zutaten",
                            style: coloredText.style,
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: ListView.builder(
                              itemCount: snapshot.data != null ? snapshot.data!.zutaten!.length : 0,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                return Dismissible(
                                  key: Key(snapshot.data!.zutaten![index].name!),
                                  background: Container(color: Colors.red),
                                  onDismissed: (direction) {
                                    snapshot.data!.zutaten!.removeAt(index);
                                    db.saveListZutat(snapshot.data!);
                                  },
                                  child: GestureDetector(
                                    onLongPress: () {
                                      _nameController.text = snapshot.data!.zutaten![index].name!;
                                      name = snapshot.data!.zutaten![index].name!;
                                      _amountController.text = snapshot.data!.zutaten![index].amount!;
                                      amount = snapshot.data!.zutaten![index].amount!;
                                      openModal(context, _nameController, snapshot, db, _amountController, true, snapshot.data!.zutaten![index]);
                                    },
                                    child: Material(
                                      child: CheckboxListTile(
                                          title: Text(
                                            snapshot.data!.zutaten![index].amount! + ' ' + snapshot.data!.zutaten![index].name!,
                                            style: snapshot.data!.zutaten![index].checked! ? coloredText.style?.copyWith(decoration: TextDecoration.lineThrough) : coloredText.style,
                                          ),
                                          checkColor: Colors.white,
                                          tileColor: snapshot.data!.zutaten![index].checked! ? backgroundColorLight : backgroundColor,
                                          activeColor: primaryColor,
                                          selectedTileColor: primaryColor,
                                          value: snapshot.data!.zutaten![index].checked,
                                          onChanged: (bool? value) {
                                            snapshot.data!.zutaten![index].checked = value!;
                                            db.saveListZutat(snapshot.data!);
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
                      MealListViewer(listId: snapshot.data!.id!, key: globalKey)
                    ],
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                openModal(context, _nameController, snapshot, db, _amountController, false);
              },
              backgroundColor: primaryColor,
              child: const Icon(Icons.add),
            ),
          );
        });
  }

  void openModal(BuildContext context, TextEditingController _controller, AsyncSnapshot<ListModel?> snapshot, DatabaseService db, TextEditingController _amountController, bool edit,
      [ListItem? item]) {
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
                              tabController!.previousIndex == 1 ? 'Zutat hinzufügen' : 'Gericht Hinzufügen',
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
                            tabController!.previousIndex == 1 ? const SizedBox(height: 20) : const SizedBox(height: 0),
                            tabController!.previousIndex == 1
                                ? TextFormField(
                                    onChanged: (val) => setState(() => amount = val),
                                    validator: (val) => val!.isEmpty ? 'Bitte ausfüllen' : null,
                                    style: coloredText.style,
                                    decoration: textInputDecoration.copyWith(hintText: 'Menge', prefixIcon: Icon(Icons.pie_chart, color: textColor)),
                                    controller: _amountController,
                                    onFieldSubmitted: (value) {
                                      if (!edit) saveItem(snapshot, db);
                                      if (edit) updateItem(snapshot, db, item!);
                                      _amountController.clear();
                                    },
                                  )
                                : const SizedBox(height: 0),
                            tabController!.previousIndex == 1 ? const SizedBox(height: 20) : const SizedBox(height: 0),
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

  void saveItem(AsyncSnapshot<ListModel?> snapshot, DatabaseService db) {
    ListItem item = ListItem(amount: amount, checked: false, name: name);
    if (snapshot.data!.zutaten!.where((element) => element.name == item.name).isEmpty) {
      snapshot.data!.zutaten!.add(item);
    } else {
      int indexWhere = snapshot.data!.zutaten!.indexWhere((element) => element.name == item.name);
      snapshot.data!.zutaten![indexWhere].amount =
          ((snapshot.data!.zutaten![indexWhere].amount!.isEmpty ? 1 : int.parse(snapshot.data!.zutaten![indexWhere].amount!)) + (item.amount!.isEmpty ? 1 : int.parse(item.amount!))).toString();
    }
    db.saveListZutat(snapshot.data!);
    db.saveListZutat(snapshot.data!);
    amount = '';
    name = '';
  }

  void updateItem(AsyncSnapshot<ListModel?> snapshot, DatabaseService db, ListItem providedItem) {
    ListItem item = ListItem(amount: providedItem.amount, checked: providedItem.checked, name: providedItem.name);
    item.amount = amount;
    item.name = name;
    var position = snapshot.data!.zutaten!.indexOf(providedItem);
    snapshot.data!.zutaten!.removeAt(position);
    snapshot.data!.zutaten!.insert(position, item);
    db.saveListZutat(snapshot.data!);
    amount = '';
    name = '';
  }
}
