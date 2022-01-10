import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:recipe_book/list/lists_provider.dart';
import 'package:recipe_book/search/search_view.dart';
import 'package:recipe_book/shared/app_bar.dart';
import 'package:recipe_book/shared/constants.dart';

import '../authenticate/authenticate.dart';
import '../recipe/recipe_widget.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  
  
  
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[const RecipeWidget(), const SearchView(), const ListsProvider(), const Authenticate()];
  final List<String> names = ["Rezepte", "Suche", "Einkaufslisten", "Account"];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(text: names[_selectedIndex], setIndex: _onItemTapped, showBackButton: false),
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

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('de');
  }
}
