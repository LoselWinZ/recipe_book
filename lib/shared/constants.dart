import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
    hintStyle: TextStyle(color: textColor),
    fillColor: Color.fromARGB(255, 35, 38, 39),
    filled: true,
    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryColor, width: 2)),
    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryColor, width: 2)));

const coloredText = Text("", style: TextStyle(color: Color.fromARGB(255, 198, 193, 185)));

const backgroundColorDark = Color.fromARGB(255, 14, 15, 15);

const textColor = Color.fromARGB(255, 198, 193, 185);

const backgroundColor = Color.fromARGB(255, 24, 26, 27);

const backgroundColorLight = Color.fromARGB(255, 35, 38, 39);

const primaryColor = Color.fromARGB(255, 67, 160, 71);
