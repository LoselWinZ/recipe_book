import 'package:flutter/material.dart';
import 'package:recipe_book/models/list_model.dart';
import 'package:recipe_book/models/meal_list.dart';
import 'package:recipe_book/shared/constants.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? text;
  final bool? showBackButton;
  final bool? isList;
  final Function? setIndex;
  final Function? removeAll;
  final ListModel? listModel;
  final MealList? mealList;

  const CustomAppBar({Key? key, this.text, this.showBackButton, this.setIndex, this.removeAll, this.isList, this.listModel, this.mealList}) : super(key: key);

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
        elevation: 1.0,
        shadowColor: Colors.black,
        toolbarHeight: 3000,
        title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          widget.showBackButton != null && !widget.showBackButton!
              ? GestureDetector(onTap: () => widget.setIndex != null ? widget.setIndex!(0) : Navigator.pop(context), child: Image.asset('lib/assets/favicon.ico', width: 30))
              : const SizedBox(width: 0, height: 0),
          Text(widget.text != null ? widget.text! : '', style: coloredText.style)
        ]),
        // actions: <Widget>[showPopupButton()]
    );
  }

  Widget showPopupButton() {
    return widget.isList != null && widget.isList!
        ? PopupMenuButton(
            color: backgroundColor,
            onSelected: (value) {
              widget.removeAll != null ? widget.removeAll!(widget.listModel != null ? widget.listModel! : ListModel()) : '';
            },
            itemBuilder: (context) {
              return <PopupMenuEntry<int>>[
                PopupMenuItem<int>(
                    value: 0,
                    child: Text(
                      'Alle löschen',
                      style: coloredText.style,
                    ))
              ];
            },
          )
        : const Text('');
  }
}
