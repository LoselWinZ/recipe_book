import 'package:flutter/material.dart';
import 'package:recipe_book/home/recipe_widget.dart';
import 'package:recipe_book/list/shopping_list.dart';
import 'package:recipe_book/screens/authenticate/authenticate.dart';
import 'package:recipe_book/search/search.dart';
import 'package:recipe_book/shared/app_bar.dart';
import 'package:recipe_book/shared/constants.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[const RecipeWidget(), const SearchProvider(), const ShoppingList(), const Authenticate()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.menu_book),
            label: 'Rezepte',
            backgroundColor: backgroundColorDark,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: 'Suche',
            backgroundColor: backgroundColorDark,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.list),
            label: 'Liste',
            backgroundColor: backgroundColorDark,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: 'Account',
            backgroundColor: backgroundColorDark,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
