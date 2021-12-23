import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/models/user.dart';
import 'package:recipe_book/screens/recipe/home.dart';
import 'package:recipe_book/screens/wrapper.dart';
import 'package:recipe_book/services/auth.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<CustomUser?>.value(
      initialData: null,
      value: AuthService().user,
      child: const MaterialApp(
        home: RecipeWidget(),
      ),
    );
  }
}
