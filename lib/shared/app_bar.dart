import 'package:flutter/material.dart';
import 'package:recipe_book/shared/constants.dart';

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
    return AppBar(
        automaticallyImplyLeading: widget.showBackButton != null ? widget.showBackButton! : true,
        backgroundColor: backgroundColorDark,
        elevation: 0.0,
        title: Image.asset('lib/assets/favicon.ico', width: 30),
        actions: const <Widget>[
        ]);
  }
}
