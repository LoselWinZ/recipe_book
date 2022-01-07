import 'package:flutter/material.dart';
import 'package:recipe_book/models/user.dart';
import 'package:recipe_book/services/auth.dart';
import 'package:recipe_book/shared/constants.dart';

import '../../services/database.dart';

class AccountView extends StatefulWidget {
  final CustomUser user;

  const AccountView({Key? key, required this.user}) : super(key: key);

  @override
  _AccountViewState createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  final DatabaseService db = DatabaseService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CustomUser?>(
      future: db.getUserData(widget.user.uid!),
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: backgroundColor,
          body: Column(
            children: [
              Card(
                margin: const EdgeInsets.all(10),
                color: backgroundColorLight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 100, child: Text(snapshot.data != null ? 'Name: ' : '', style: coloredText.style)),
                          Text(snapshot.data != null ? snapshot.data!.displayName! : '', style: coloredText.style),
                        ],
                      ),
                      Divider(
                        height: 10,
                        thickness: 0.5,
                        color: textColor.withAlpha(100),
                      ),
                      Row(
                        children: [
                          SizedBox(width: 100, child: Text(snapshot.data != null ? 'Email: ' : '', style: coloredText.style)),
                          Text(snapshot.data != null ? snapshot.data!.email! : '', style: coloredText.style),
                        ],
                      ),
                      Divider(
                        height: 10,
                        thickness: 0.5,
                        color: textColor.withAlpha(100),
                      ),
                      Row(
                        children: [
                          SizedBox(width: 100, child: Text(snapshot.data != null ? 'UserID: ' : '', style: coloredText.style)),
                          Text(snapshot.data != null ? snapshot.data!.uid! : '', style: coloredText.style),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: primaryColor, width: 2)))),
                  onPressed: () async {
                    dynamic user = await _authService.logout();
                    debugPrint(user);
                  },
                  child: Text('Ausloggen', style: coloredText.style))
            ],
          ),
        );
      },
    );
  }
}
