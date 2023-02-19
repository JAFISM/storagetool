import 'package:flutter/material.dart';
import 'package:storagetool/Sqflite_ex/login/sqlops.dart';

void main() {
  runApp(MaterialApp(
    home: LoginScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  var dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Screen"),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                  hintText: 'Enter your username', labelText: 'Username'),
            ),
            TextField(
              obscureText: true,
              controller: passwordController,
              decoration: InputDecoration(
                  hintText: 'Enter your password', labelText: 'Password'),
            ),
            ElevatedButton(
              child: Text('Login'),
              onPressed: () {
                dbHelper
                    .loginUser(usernameController.text, passwordController.text)
                    .then(
                  (value) {
                    if (value) {
                      Navigator.of(context).pushReplacementNamed('/home');
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content: Text('Invalid username or password'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Close'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                        },
                      );
                    }
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
