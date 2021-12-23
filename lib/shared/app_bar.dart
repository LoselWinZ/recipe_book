import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/shared/constants.dart';

import '../models/user.dart';
import '../screens/authenticate/authenticate.dart';
import '../services/auth.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? text;
  final bool? showBackButton;
  const CustomAppBar({Key? key, this.text, this.showBackButton}) : super(key: key);

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();
    final user = Provider.of<CustomUser?>(context);

    return AppBar(
        automaticallyImplyLeading: widget.showBackButton != null ? widget.showBackButton! : true,
        backgroundColor: backgroundColorDark,
        elevation: 0.0,
        title: Image.asset('lib/assets/favicon.ico', width: 30),
        actions: <Widget>[
          PopupMenuButton(
              color: const Color.fromARGB(255, 24, 26, 27),
              icon: const Icon(
                Icons.menu,
                color: Color.fromARGB(255, 198, 193, 185),
              ),
              onSelected: (value) async {
                if (user != null) {
                  await _authService.logout();
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Authenticate()),
                );
              },
              itemBuilder: (context) => [
                    PopupMenuItem<int>(
                      value: 0,
                      child: user != null
                          ? const Text('Ausloggen', style: TextStyle(color: Color.fromARGB(255, 198, 193, 185)))
                          : const Text('Einloggen', style: TextStyle(color: Color.fromARGB(255, 198, 193, 185))),
                    ),
                  ])
        ]);
    ;
  }
}
