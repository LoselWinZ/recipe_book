import 'package:flutter/material.dart';
import 'package:recipe_book/list/list_viewer.dart';
import 'package:recipe_book/models/list_item.dart';
import 'package:recipe_book/models/list_model.dart';
import 'package:recipe_book/shared/app_bar.dart';
import 'package:recipe_book/shared/constants.dart';

import '../services/database.dart';
import 'meal_list_viewer.dart';

class ListViewersContainer extends StatefulWidget {
  final String? uid;

  const ListViewersContainer({Key? key, this.uid}) : super(key: key);

  @override
  _ListViewersContainerState createState() => _ListViewersContainerState();
}

class _ListViewersContainerState extends State<ListViewersContainer> with TickerProviderStateMixin {
  TabController? tabController;
  List<ListItem> items = List.empty();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  int getTabControllerIndex() {
    return tabController!.index;
  }

  @override
  Widget build(BuildContext context) {
    String clearList(ListModel listmodel) {
      listmodel.zutaten!.clear();
      db.saveListZutat(listmodel);
      return '';
    }

    return Scaffold(
      appBar: CustomAppBar(showBackButton: true, isList: true, removeAll: clearList, listModel: ListModel()),
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          TabBar(
            controller: tabController,
            indicatorColor: primaryColor,
            tabs: const <Widget>[
              Tab(
                text: 'Liste',
                // icon: Icon(Icons.list),
              ),
              Tab(
                text: 'Gerichte',
                // icon: Icon(Icons.beach_access_sharp),
              )
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [ListViewer(uid: widget.uid!), MealListViewer(listId: widget.uid)],
            ),
          ),
        ],
      ),
    );
  }
}
