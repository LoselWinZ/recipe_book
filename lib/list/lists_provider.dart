import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/list/lists.dart';
import 'package:recipe_book/models/list_model.dart';
import 'package:recipe_book/shared/constants.dart';

import '../models/user.dart';
import '../services/database.dart';

class ListsProvider extends StatefulWidget {
  const ListsProvider({Key? key}) : super(key: key);

  @override
  _ListsProviderState createState() => _ListsProviderState();
}

class _ListsProviderState extends State<ListsProvider> {
  final _formKey = GlobalKey<FormState>();

  String name = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);
    return StreamProvider<List<ListModel>>.value(
      value: DatabaseService().listsByUserId(user?.uid),
      initialData: const [],
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: const Lists(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              'Liste erstellen',
                              style: coloredText.style,
                              textScaleFactor: 1.2,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                                autofocus: true,
                                onChanged: (val) => setState(() => name = val),
                                validator: (val) => val!.isEmpty ? 'Bitte ausfüllen' : null,
                                style: coloredText.style,
                                decoration: textInputDecoration.copyWith(hintText: 'Name', prefixIcon: Icon(Icons.text_snippet_outlined, color: textColor))),
                            const SizedBox(height: 20),
                            ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: primaryColor, width: 2)))),
                                onPressed: () {
                                  db.createNewList(name, user!);
                                  setState(() {
                                    name = '';
                                  });
                                },
                                child: Text('Erstellen', style: coloredText.style)),
                            const SizedBox(height: 20)
                          ],
                        ),
                      ),
                    ),
                  );
                },
                backgroundColor: backgroundColor,
                constraints: const BoxConstraints(maxHeight: 500));
          },
          backgroundColor: primaryColor,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
