import 'dart:io';

import 'package:algolia/algolia.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/models/einheit.dart';
import 'package:recipe_book/models/ingredient.dart';
import 'package:recipe_book/models/recipe.dart';
import 'package:recipe_book/models/recipe_ingredient.dart';
import 'package:recipe_book/models/user.dart';
import 'package:recipe_book/services/database.dart';
import 'package:recipe_book/shared/app_bar.dart';
import 'package:recipe_book/shared/constants.dart';

import '../models/categorie.dart';
import '../services/algolia.dart';

class RecipeCreator extends StatefulWidget {
  const RecipeCreator({Key? key}) : super(key: key);

  @override
  _RecipeCreatorState createState() => _RecipeCreatorState();
}

class _RecipeCreatorState extends State<RecipeCreator> {
  final DatabaseService db = DatabaseService();
  AlgoliaAPI algoliaAPI = AlgoliaAPI();
  String _searchText = "";
  List<Ingredient> _hitsList = [];
  TextEditingController _textFieldController = TextEditingController();
  List<RecipeIngredient> _recipeIngredients = [];
  HtmlEditorController _editorController = HtmlEditorController();
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  Recipe recipe = Recipe();

  Future<void> _getSearchResult(String query) async {
    if (query.isEmpty) {
      return Future.value('');
    }
    List<AlgoliaObjectSnapshot>? response = await algoliaAPI.search(query);
    var hitsList = response!.map((json) {
      return Ingredient(id: json.objectID, name: json.data["name"]);
    }).toList();
    setState(() {
      _hitsList = hitsList;
    });
  }

  _imgFromCamera() async {
    XFile? image = await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  Future<String> _uploadImageToFirebase(Recipe recipe) async {
    String fileName = recipe.name!;
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
    TaskSnapshot taskSnapshot = await firebaseStorageRef.putFile(File(_image!.path), SettableMetadata(customMetadata: {'uploadedBy': recipe.userId!}));
    return await taskSnapshot.ref.getDownloadURL();
  }

  @override
  void initState() {
    super.initState();
    _textFieldController.addListener(() {
      if (_searchText != _textFieldController.text) {
        setState(() {
          _searchText = _textFieldController.text;
        });
        _getSearchResult(_searchText);
      }
    });
    _getSearchResult('');
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    final user = Provider.of<CustomUser?>(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const CustomAppBar(text: "Gericht erstellen", showBackButton: true),
      body: PageView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Informationen",
                    style: coloredText.style,
                    textScaleFactor: 2,
                  ),
                  TextFormField(
                      onChanged: (val) => setState(() => recipe.name = val),
                      validator: (val) => val!.isEmpty ? 'Bitte ausfüllen' : null,
                      style: coloredText.style,
                      decoration: textInputDecoration.copyWith(hintText: 'Name', prefixIcon: Icon(Icons.restaurant_menu, color: textColor))),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: TextFormField(
                            keyboardType: TextInputType.number,
                            onChanged: (val) => setState(() => recipe.cooktime = val),
                            validator: (val) => val!.isEmpty ? 'Bitte ausfüllen' : null,
                            style: coloredText.style,
                            decoration: textInputDecoration.copyWith(hintText: 'Zubereitungszeit', prefixIcon: Icon(Icons.access_time, color: textColor))),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                            keyboardType: TextInputType.number,
                            onChanged: (val) => setState(() => recipe.portions = int.parse(val)),
                            validator: (val) => val!.isEmpty ? 'Bitte ausfüllen' : null,
                            style: coloredText.style,
                            decoration: textInputDecoration.copyWith(hintText: 'Portionen', prefixIcon: Icon(Icons.pie_chart, color: textColor))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField(
                    items: Categorie.values
                        .map((categorie) => DropdownMenuItem(
                            child: Text(
                              categorie.name,
                              style: coloredText.style,
                            ),
                            value: categorie))
                        .toList(),
                    onChanged: (Categorie? value) {
                      setState(() {
                        recipe.categorie = value!.name;
                      });
                    },
                    dropdownColor: backgroundColorLight,
                    hint: Text('Kategorie', style: coloredText.style),
                    decoration: textInputDecoration,
                    icon: Icon(Icons.arrow_drop_down_outlined, color: textColor),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                      onChanged: (val) => setState(() => recipe.description = val),
                      validator: (val) => val!.isEmpty ? 'Bitte ausfüllen' : null,
                      style: coloredText.style,
                      decoration: textInputDecoration.copyWith(hintText: 'Beschreibung', prefixIcon: Icon(Icons.pie_chart, color: textColor))),
                  const Expanded(child: SizedBox(height: 0)),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: primaryColor, width: 2)))),
                            onPressed: () async {
                              controller.animateTo(MediaQuery.of(context).size.width, duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
                            },
                            child: Text('Weiter', style: coloredText.style)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                        style: coloredText.style,
                        decoration: textInputDecoration.copyWith(
                            suffixIcon: Icon(
                              Icons.search,
                              color: textColor,
                            ),
                            hintText: 'Suche'),
                      ),
                      suggestionsCallback: (pattern) async {
                        _textFieldController.text = pattern;
                        await _getSearchResult(pattern);
                        return _hitsList;
                      },
                      itemBuilder: (context, Ingredient? suggestion) {
                        debugPrint(suggestion.toString());
                        return ListTile(
                          title: Text(suggestion!.name!),
                        );
                      },
                      onSuggestionSelected: (Ingredient? suggestion) {
                        RecipeIngredient recipeIngredient = RecipeIngredient(name: suggestion!.name, ingredientId: suggestion.id);
                        setState(() {
                          if (_recipeIngredients.indexWhere((element) => element.name == recipeIngredient.name) == -1) {
                            _recipeIngredients.add(recipeIngredient);
                          }
                        });
                      },
                    ),
                  ),
                  _hitsList.isEmpty
                      ? GestureDetector(
                          onTap: () async {
                            if (_textFieldController.text.isEmpty) {
                              return;
                            }
                            String ingredientId = await db.createIngredient( _textFieldController.text);
                            RecipeIngredient recipeIngredient = RecipeIngredient(name: _textFieldController.text, ingredientId: ingredientId);
                            setState(() {
                              if (_recipeIngredients.indexWhere((element) => element.name == recipeIngredient.name) == -1) {
                                _recipeIngredients.add(recipeIngredient);
                              }
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(15),
                            child: const Icon(Icons.add, color: primaryColor),
                            decoration: BoxDecoration(border: Border.all(color: primaryColor, width: 2), borderRadius: BorderRadius.circular(2.5)),
                          ),
                        )
                      : const SizedBox(width: 0)
                ],
              ),
              Expanded(
                  child: _recipeIngredients.isEmpty
                      ? Center(
                          child: Text(
                          'Alle Alle',
                          style: coloredText.style,
                        ))
                      : ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: _recipeIngredients.length,
                          itemBuilder: (BuildContext context, int index) {
                            debugPrint(index.toString());
                            return Dismissible(
                              key: Key(_recipeIngredients[index].name!),
                              background: Container(color: Colors.red),
                              onDismissed: (direction) {
                                _recipeIngredients.removeAt(index);
                              },
                              child: Row(children: <Widget>[
                                Expanded(
                                    flex: 3,
                                    child: Text(
                                      '${_recipeIngredients[index].name}',
                                      style: coloredText.style,
                                    )),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      onChanged: (val) => setState(() => _recipeIngredients[index].amount = val),
                                      validator: (val) => val!.isEmpty ? 'Bitte ausfüllen' : null,
                                      style: coloredText.style,
                                      decoration: textInputDecoration.copyWith(hintText: 'Menge')),
                                ),
                                Expanded(
                                  child: DropdownButtonFormField(
                                    items: Einheit.values
                                        .map((categorie) => DropdownMenuItem(
                                            child: Text(
                                              categorie.name,
                                              style: coloredText.style,
                                            ),
                                            value: categorie))
                                        .toList(),
                                    onChanged: (Einheit? value) {
                                      setState(() {
                                        _recipeIngredients[index].einheit = value!.name;
                                      });
                                    },
                                    dropdownColor: backgroundColorLight,
                                    decoration: textInputDecoration,
                                    icon: Icon(Icons.arrow_drop_down_outlined, color: textColor),
                                  ),
                                ),
                              ]),
                            );
                          })),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: primaryColor, width: 2)))),
                          onPressed: () async {
                            controller.animateTo(-MediaQuery.of(context).size.width, duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
                          },
                          child: Text('Zurück', style: coloredText.style)),
                    ),
                    Expanded(
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: primaryColor, width: 2)))),
                          onPressed: () async {
                            controller.animateTo(MediaQuery.of(context).size.width * 2, duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
                          },
                          child: Text('Weiter', style: coloredText.style)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: [
              Expanded(
                child: HtmlEditor(
                  controller: _editorController,
                  htmlEditorOptions: const HtmlEditorOptions(inputType: HtmlInputType.text, darkMode: true),
                  htmlToolbarOptions: HtmlToolbarOptions(
                      textStyle: coloredText.style,
                      toolbarType: ToolbarType.nativeGrid,
                      defaultToolbarButtons: [const StyleButtons(), const ListButtons(listStyles: false), const OtherButtons()],
                      buttonColor: textColor),
                  otherOptions: const OtherOptions(height: 800),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: primaryColor, width: 2)))),
                          onPressed: () async {
                            controller.animateTo(MediaQuery.of(context).size.width, duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
                          },
                          child: Text('Zurück', style: coloredText.style)),
                    ),
                    Expanded(
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: primaryColor, width: 2)))),
                          onPressed: () async {
                            controller.animateTo(MediaQuery.of(context).size.width * 3, duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
                            var text = await _editorController.getText();
                            setState(() {
                              recipe.preparation = text;
                            });
                          },
                          child: Text('Weiter', style: coloredText.style)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: [
              Expanded(
                child: Image.file(
                  File(_image != null ? _image!.path : ''),
                  fit: BoxFit.contain,
                  width: 300,
                ),
              ),
              Expanded(
                  child: Row(children: [
                Expanded(child: IconButton(onPressed: _imgFromCamera, icon: Icon(Icons.camera_alt, color: textColor))),
                Expanded(child: IconButton(onPressed: _imgFromGallery, icon: Icon(Icons.photo, color: textColor)))
              ])),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: primaryColor, width: 2)))),
                          onPressed: () async {
                            controller.animateTo(MediaQuery.of(context).size.width * 2, duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
                          },
                          child: Text('Zurück', style: coloredText.style)),
                    ),
                    Expanded(
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: BorderSide(color: isFilled(recipe) ? primaryColor : Colors.grey, width: 2)))),
                          onPressed: () async {
                            if (!isFilled(recipe)) return;
                            debugPrint(recipe.toString());
                            setState(() {
                              recipe.userId = user!.uid;
                            });
                            String imgLink = await _uploadImageToFirebase(recipe);
                            setState(() {
                              recipe.imgLink = imgLink;
                            });
                            db.createRecipe(recipe, user!, _recipeIngredients);
                            Navigator.pop(context);
                          },
                          child: Text('Speichern', style: coloredText.style)),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  bool isFilled(Recipe recipe) {
    return recipe.preparation != null &&
        recipe.preparation!.isNotEmpty &&
        recipe.name != null &&
        recipe.name!.isNotEmpty &&
        recipe.description != null &&
        recipe.description!.isNotEmpty &&
        recipe.portions != null &&
        recipe.categorie != null &&
        recipe.categorie!.isNotEmpty &&
        recipe.cooktime != null &&
        recipe.cooktime!.isNotEmpty;
  }
}
