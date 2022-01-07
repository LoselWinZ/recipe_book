import 'package:flutter/material.dart';

import '../../services/auth.dart';
import '../../shared/constants.dart';
import '../../shared/loading.dart';

class Register extends StatefulWidget {
  // const Register({Key? key}) : super(key: key);

  final Function? toggleView;

  const Register({Key? key, this.toggleView}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<Register> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String username = '';
  String error = '';


  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
                backgroundColor: backgroundColorDark,
                elevation: 0.0,
                title: Text('Registrieren', style: coloredText.style),
                actions: <Widget>[
                  TextButton.icon(
                      icon: Icon(Icons.person, color: textColor,),
                      onPressed: () {
                        widget.toggleView!();
                      },
                      label: Text('Anmelden', style: coloredText.style))
                ]),
            body: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20),
                      TextFormField(
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                        validator: (val) =>
                            val!.isEmpty ? 'Bitte ausfüllen' : null,
                        style: coloredText.style,
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Email', prefixIcon: Icon(Icons.mail, color: textColor)),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                          onChanged: (val) {
                            setState(() => password = val);
                          },
                          obscureText: true,
                          validator: (val) =>
                              val!.length < 6 ? 'Mindestens 6 Zeichen' : null,
                          style: coloredText.style,
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Passwort', prefixIcon: Icon(Icons.lock, color: textColor))),
                      const SizedBox(height: 20),
                      TextFormField(
                          onChanged: (val) {
                            setState(() => username = val);
                          },
                          obscureText: true,
                          validator: (val) =>
                          val!.isEmpty ? 'Bitte ausfüllen' : null,
                          style: coloredText.style,
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Benutzername', prefixIcon: Icon(Icons.person, color: textColor))),
                      const SizedBox(height: 20),
                      ElevatedButton(
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent), shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: primaryColor, width: 2)))),
                          onPressed: () async {
                            if (_formKey.currentState != null &&
                                _formKey.currentState!.validate()) {
                              setState(() => loading = true);
                              dynamic user =
                                  await _authService.register(email, password, username);
                              if (user == null) {
                                setState(() {
                                  error = 'please provide a valid email';
                                  loading = false;
                                });
                              }
                            }
                          },
                          child: const Text('Registrieren',
                              style: TextStyle(color: Colors.white))),
                      const SizedBox(height: 12),
                      Text(error,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 14))
                    ],
                  ),
                )),
          );
  }
}
