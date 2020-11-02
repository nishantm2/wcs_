import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:rich_alert/rich_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  var flag = 0;
  final TextEditingController loginController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    } else {
      return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new Image(
              image: new AssetImage("assets/Login_Background.png"),
              fit: BoxFit.cover,
              color: Colors.black54,
              colorBlendMode: BlendMode.darken,
            ),
            new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Image(
                  image: new AssetImage("assets/icon.png"),
                  width: 120,
                  height: 120,
                ),
                new Form(
                  child: new Theme(
                    data: new ThemeData(
                        brightness: Brightness.dark,
                        primaryColor: Colors.white,
                        // hintColor: Colors.white24,
                        inputDecorationTheme: new InputDecorationTheme(
                            labelStyle: new TextStyle(
                          color: Colors.white24,
                          fontSize: 20.0,
                        ))),
                    child: new Container(
                      padding: const EdgeInsets.all(20.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new TextFormField(
                            controller: loginController,
                            decoration: new InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 1.0),
                              ),
                              labelText: "Login ID",
                            ),
                          ),
                          new Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                          ),
                          new TextFormField(
                            controller: passwordController,
                            decoration: new InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 1.0),
                              ),
                              labelText: "Password",
                            ),
                            keyboardType: TextInputType.text,
                            obscureText: true,
                          ),
                          new Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                          ),
                          new MaterialButton(
                            height: 40.0,
                            minWidth: 100.0,
                            color: Colors.lightBlue[800],
                            textColor: Colors.white,
                            child: new Text("Login"),
                            onPressed: () {
                              setState(() {
                                _isLoading = true;
                              });
                              signIn(loginController.text,
                                  passwordController.text);
                              //teacherid = emailController.text;
                            },
                            splashColor: Colors.white70,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      );
    }
  }

  signIn(loginID, pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jsonResponse;
    var data;
    var response = await http.post(
        "http://wcshcst.xyz/checkLogin.php?id=${loginID}&pass=${pass}");
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });

        if (jsonResponse['result'].isNotEmpty) {
          data = jsonResponse['result'];
          if (data[0]['Test'] == "1") {
            sharedPreferences.setString("token", loginID);
            flag = 1;
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => new TabNavTheme()),
                (Route<dynamic> route) => false);
          }
          if (data[0]['Test'] == "0") {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return RichAlertDialog(
                    alertTitle: richTitle("Alert!"),
                    alertSubtitle: richSubtitle("Wrong Password!"),
                    alertType: RichAlertType.WARNING,
                  );
                });
          }
          if (data[0]['Test'] == "2") {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return RichAlertDialog(
                    alertTitle: richTitle("Alert!"),
                    alertSubtitle: richSubtitle("Wrong Login ID!"),
                    alertType: RichAlertType.WARNING,
                  );
                });
          }
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return RichAlertDialog(
                  alertTitle: richTitle("Alert!"),
                  alertSubtitle: richSubtitle("Wrong Login ID!"),
                  alertType: RichAlertType.WARNING,
                );
              });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
