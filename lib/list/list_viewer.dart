import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:recipe_book/models/recipe_ingredient.dart';

import '../models/list_item.dart';
import '../models/list_model.dart';
import '../models/recipe.dart';
import '../services/algolia.dart';
import '../shared/constants.dart';

class ListViewer extends StatefulWidget {
  final String? uid;

  const ListViewer({Key? key, this.uid}) : super(key: key);

  @override
  _ListViewerState createState() => _ListViewerState();
}

class _ListViewerState extends State<ListViewer> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String amount = '';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final PageController _pageController = PageController();

  String _searchText = "";
  List<Recipe> _hitsList = [];
  TextEditingController _textFieldController = TextEditingController();
  AlgoliaAPI algoliaAPI = AlgoliaAPI();

  Future<void> _getSearchResult(String query) async {
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

  Recipe _selectedRecipe = Recipe();
  List<RecipeIngredient> _recipeIngredients = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ListModel?>(
        stream: widget.uid != null ? db.getList(widget.uid!) : const Stream.empty(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: backgroundColor,
            body: Column(
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
                            openModal(context, _nameController, snapshot, _amountController, true, snapshot.data!.zutaten![index]);
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
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                openModal(context, _nameController, snapshot, _amountController, false);
                amount = '';
                name = '';
              },
              backgroundColor: primaryColor,
              child: const Icon(Icons.add),
            ),
          );
        });
  }

  void openModal(BuildContext context, TextEditingController _controller, AsyncSnapshot<ListModel?> providedSnapshot, TextEditingController _amountController, bool edit, [ListItem? item]) {
    showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(35.0))),
            builder: (context) {
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollBehavior: const ScrollBehavior().copyWith(overscroll: false),
                      padEnds: false,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: Column(
                            children: [
                              ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: primaryColor, width: 2)))),
                                  onPressed: () async {
                                    _pageController.animateTo(MediaQuery.of(context).size.width * 2, duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
                                  },
                                  child: Text('Aus Rezept', style: coloredText.style)),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: primaryColor, width: 2)))),
                                  onPressed: () async {
                                    _pageController.animateTo(MediaQuery.of(context).size.width, duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
                                  },
                                  child: Text('Neue Zutat', style: coloredText.style))
                            ],
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: Wrap(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              _pageController.animateTo(-MediaQuery.of(context).size.width, duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
                                            },
                                            icon: Icon(Icons.arrow_back_sharp, color: textColor)),
                                        const SizedBox(width: 80),
                                        Text(
                                          'Zutat hinzufügen',
                                          style: coloredText.style,
                                          textScaleFactor: 1.2,
                                        ),
                                      ],
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
                                        if (!edit) saveItem(providedSnapshot, name, amount);
                                        if (edit) updateItem(providedSnapshot, item!, name, amount);
                                        _controller.clear();
                                        clearFields();
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    TextFormField(
                                      onChanged: (val) => setState(() => amount = val),
                                      validator: (val) => val!.isEmpty ? 'Bitte ausfüllen' : null,
                                      style: coloredText.style,
                                      decoration: textInputDecoration.copyWith(hintText: 'Menge', prefixIcon: Icon(Icons.pie_chart, color: textColor)),
                                      controller: _amountController,
                                      onFieldSubmitted: (value) {
                                        if (!edit) saveItem(providedSnapshot, name, amount);
                                        if (edit) updateItem(providedSnapshot, item!, name, amount);
                                        _amountController.clear();
                                        clearFields();
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: primaryColor, width: 2)))),
                                        onPressed: () async {
                                          if (!edit) saveItem(providedSnapshot, name, amount);
                                          if (edit) updateItem(providedSnapshot, item!, name, amount);
                                          _amountController.clear();
                                          _controller.clear();
                                          clearFields();
                                          Navigator.pop(context);
                                        },
                                        child: Text(edit ? 'Übernehmen' : 'Erstellen', style: coloredText.style)),
                                    const SizedBox(height: 20)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      _pageController.animateTo(-MediaQuery.of(context).size.width, duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
                                    },
                                    icon: Icon(Icons.arrow_back_sharp, color: textColor)),
                                const SizedBox(width: 80),
                                Text(
                                  'Zutat aus Gericht',
                                  style: coloredText.style,
                                  textScaleFactor: 1.2,
                                ),
                              ],
                            ),
                            TextFormField(
                              autofocus: false,
                              style: coloredText.style,
                              decoration: textInputDecoration.copyWith(hintText: 'Rezept Suchen...', prefixIcon: Icon(Icons.search, color: textColor)),
                              controller: _textFieldController,
                              onChanged: (val) {
                                _getSearchResult(val);
                              },
                            ),
                            Expanded(
                                child: _hitsList.isEmpty
                                    ? Center(
                                        child: Text(
                                        'Alle Alle',
                                        style: coloredText.style,
                                      ))
                                    : ListView.builder(
                                        padding: const EdgeInsets.all(8),
                                        itemCount: _hitsList.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return Column(
                                            children: [
                                              ListTile(
                                                title: Text(_hitsList[index].name!, style: coloredText.style),
                                                leading: Image.network(_hitsList[index].imgLink!),
                                                trailing: Icon(Icons.keyboard_arrow_right, color: textColor),
                                                onTap: () async {
                                                  _pageController.animateTo(MediaQuery.of(context).size.width * 3, duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
                                                  FocusScope.of(context).unfocus();
                                                  setState(() {
                                                    _selectedRecipe = _hitsList[index];
                                                  });
                                                },
                                              ),
                                              Divider(color: textColor, height: 10, thickness: 1),
                                            ],
                                          );
                                        })),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      _pageController.animateTo(MediaQuery.of(context).size.width * 2, duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
                                    },
                                    icon: Icon(Icons.arrow_back_sharp, color: textColor)),
                                Expanded(
                                  child: Text(
                                    'Zutaten von ${_selectedRecipe.name}',
                                    style: coloredText.style,
                                    textScaleFactor: 1.2,
                                  ),
                                ),
                              ],
                            ),
                            StreamBuilder<List<RecipeIngredient>>(
                                stream: db.recipeIngredientFromRecipe(_selectedRecipe),
                                builder: (context, snapshot) {
                                  return Expanded(
                                    child: snapshot.hasData && snapshot.data!.isEmpty
                                        ? Center(
                                            child: Text(
                                              'Alle Alle',
                                              style: coloredText.style,
                                            ),
                                          )
                                        : ListView.builder(
                                            padding: const EdgeInsets.all(8),
                                            itemCount: snapshot.hasData ? snapshot.data!.length : 0,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Column(
                                                children: [
                                                  ListTile(
                                                    title: Text(snapshot.data![index].name!, style: coloredText.style),
                                                    trailing: Icon(
                                                        providedSnapshot.data!.zutaten!.indexWhere((element) => element.name == snapshot.data![index].name!) != -1
                                                            ? Icons.check
                                                            : Icons.add_shopping_cart,
                                                        color: textColor),
                                                    onTap: () {
                                                      saveItem(providedSnapshot, snapshot.data![index].name!, snapshot.data![index].amount!);
                                                      setState(() {});
                                                    },
                                                    selected: providedSnapshot.data!.zutaten!.indexWhere((element) => element.name == snapshot.data![index].name!) != -1,
                                                    selectedTileColor: backgroundColorLight,
                                                  ),
                                                  Divider(color: textColor, height: 10, thickness: 1),
                                                ],
                                              );
                                            }),
                                  );
                                }),
                          ],
                        )
                      ],
                    ),
                  );
                },
              );
            },
            backgroundColor: backgroundColor,
            constraints: const BoxConstraints(minHeight: 200, maxHeight: 600))
        .whenComplete(() {
      _controller.clear();
      _amountController.clear();
      _textFieldController.clear();
    });
  }

  void clearFields() {
    setState(() {
      name = '';
      amount = '';
    });
  }
}
