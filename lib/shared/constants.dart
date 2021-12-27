import 'package:flutter/material.dart';

bool dark = true;

InputDecoration textInputDecoration = InputDecoration(
    hintStyle: TextStyle(color: textColor),
    fillColor: const Color.fromARGB(255, 35, 38, 39),
    filled: true,
    enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: primaryColor, width: 2)),
    focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: primaryColor, width: 2)));

const coloredText = Text("", style: TextStyle(color: Color.fromARGB(255, 198, 193, 185)));

Color backgroundColorDark = dark ? const Color.fromARGB(255, 14, 15, 15) : const Color.fromARGB(255, 226, 226, 226);

Color textColor = dark ? const Color.fromARGB(255, 198, 193, 185) : const Color.fromARGB(255, 44, 44, 44);

Color backgroundColor = dark ? const Color.fromARGB(255, 24, 26, 27) : const Color.fromARGB(255, 226, 226, 226);

Color backgroundColorLight = dark ? const Color.fromARGB(255, 35, 38, 39) : Colors.white;

const primaryColor = Color.fromARGB(255, 67, 160, 71);


