import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/authenticate/register.dart';
import 'package:recipe_book/authenticate/sign_in.dart';
import 'package:recipe_book/models/user.dart';

import 'account.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  bool isLoggedIn = false;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  void toggleLoggedIn() {
    setState(() {
      isLoggedIn = !isLoggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);
    if (showSignIn && user == null) {
      return SignIn(toggleView: toggleView);
    } else if (!showSignIn && user == null) {
      return Register(toggleView: toggleView);
    } else if (user != null) {
      return AccountView(user: user);
    } else {
      return const Text('error');
    }
  }
}
