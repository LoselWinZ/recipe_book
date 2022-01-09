import 'package:flutter/material.dart';
import 'package:recipe_book/services/auth.dart';
import 'package:recipe_book/shared/loading.dart';

import '../../shared/constants.dart';

class SignIn extends StatefulWidget {
  final Function? toggleView;

  const SignIn({Key? key, this.toggleView}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(backgroundColor: backgroundColorDark, elevation: 0.0, title: Text("Anmelden", style: coloredText.style), actions: <Widget>[
              TextButton.icon(
                  icon: Icon(Icons.person, color: textColor),
                  onPressed: () {
                    widget.toggleView!();
                  },
                  label: Text('Registrieren', style: coloredText.style))
            ]),
            body: Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20),
                      TextFormField(
                          onChanged: (val) => setState(() => email = val),
                          validator: (val) => val!.isEmpty ? 'Bitte ausfüllen' : null,
                          style: coloredText.style,
                          autofillHints: const [AutofillHints.email],

                          decoration: textInputDecoration.copyWith(hintText: 'Email', prefixIcon: Icon(Icons.mail, color: textColor))),
                      const SizedBox(height: 20),
                      TextFormField(
                          onChanged: (val) => setState(() => password = val),
                          obscureText: true,
                          validator: (val) => val!.length < 6 ? 'Mindestens 6 Zeichen' : null,
                          style: coloredText.style,
                          autofillHints: const [AutofillHints.password],
                          decoration: textInputDecoration.copyWith(hintText: 'Passwort', prefixIcon: Icon(Icons.lock, color: textColor))),
                      const SizedBox(height: 20),
                      ElevatedButton(
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent), shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: primaryColor, width: 2)))),
                          onPressed: () async {
                        if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                          setState(() => loading = true);
                          dynamic user = await _authService.login(email, password);
                          if (user == null) {
                            setState(() {
                              error = 'user not found';
                              loading = false;
                            });
                          }
                          setState(() {
                            loading = false;
                          });
                        }
                      }, child: const Text('Einloggen', style: TextStyle(color: Colors.white))),
                      const SizedBox(height: 12),
                      Text(error, style: const TextStyle(color: Colors.red, fontSize: 14))
                    ],
                  ),
                )),
          );
  }
}
