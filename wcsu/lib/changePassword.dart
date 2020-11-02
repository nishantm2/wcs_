import 'package:flutter/material.dart';
import 'package:rich_alert/rich_alert.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() =>
      _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword>
    with SingleTickerProviderStateMixin {
  final TextEditingController oldPassword = new TextEditingController();
  final TextEditingController newPassword = new TextEditingController();
  final TextEditingController confirmNewPassword = new TextEditingController();
  bool _isLoading=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: Text('CHANGE PASSWORD'),
      ),
      body: new SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Stack(
            children: <Widget>[
              new Form(
                child: new Theme(
                  data: new ThemeData(
                      primaryColor: Colors.blueGrey[700],
                      inputDecorationTheme: new InputDecorationTheme(
                          labelStyle: new TextStyle(
                        color: Colors.blueGrey[700],
                        fontSize: 20.0,
                      ))),
                  child: new Container(
                    padding: const EdgeInsets.all(20.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                         new TextField(
                          controller: oldPassword,
                          decoration: new InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blueGrey[700], width: 1.0),
                                borderRadius: BorderRadius.circular(5.0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.blueGrey[700], width: 1.0),
                            ),
                            labelText: "Enter Current Password",
                          ),
                          maxLines: 1,
                          autofocus: true,
                          obscureText: true,
                         ),
                          new Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                          ),
                          new TextField(
                          controller: newPassword,
                          decoration: new InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blueGrey[700], width: 1.0),
                                borderRadius: BorderRadius.circular(5.0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.blueGrey[700], width: 1.0),
                            ),
                            labelText: "Enter New Password",
                          ),
                          maxLines: 1,
                          autofocus: true,
                          obscureText: true,
                         ),
                         new Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                          ),
                          new TextField(
                          controller: confirmNewPassword,
                          decoration: new InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blueGrey[700], width: 1.0),
                                borderRadius: BorderRadius.circular(5.0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.blueGrey[700], width: 1.0),
                            ),
                            labelText: "Re-Enter New Password",
                          ),
                          maxLines: 1,
                          autofocus: true,
                          obscureText: true,
                         ),
                        new Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                          ),
                          new MaterialButton(
                            height: 40.0,
                            minWidth: 100.0,
                            color: Colors.blue,
                            textColor: Colors.white,
                            child: new Text("Submit"),
                            onPressed: () {
                              setState(() {
                                _isLoading = true;
                              });
                              submit(oldPassword.text,newPassword.text,confirmNewPassword.text);
                           },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _changed() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Password Changed!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                oldPassword.clear();
                newPassword.clear();
                confirmNewPassword.clear();
              },
            ),
          ],
          elevation: 24.0,
          backgroundColor: Colors.green[800],
        );
      },
    );
  }

  Future<void> _notMatched() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "New Password Don't Match!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                oldPassword.clear();
                newPassword.clear();
                confirmNewPassword.clear();
              },
            ),
          ],
          elevation: 24.0,
          backgroundColor: Colors.red[800],
        );
      },
    );
  }
  Future<void> _incorrectOldPass() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Wrong Current Password!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                 oldPassword.clear();
                newPassword.clear();
                confirmNewPassword.clear();
              },
            ),
          ],
          elevation: 24.0,
          backgroundColor: Colors.red[800],
        );
      },
    );
  }
submit(old,newp,cnewp) async {
    var jsonResponse;
    var data;
    SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    var lid= sharedPreferences.getString("token");
    var response = await http.post(
        "http://wcshcst.xyz/changePasswordEmp.php?lid=${lid}&old=${old}&newp=${newp}&cnewp=${cnewp}");
    if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);
        if (jsonResponse != null) {
          setState(() {
            _isLoading = false;
          });
          if (jsonResponse.isNotEmpty) {
            data = jsonResponse['result'];
            if (data == "0") {
              _incorrectOldPass();
            }
            else if(data=="3"){
                _changed();
              }
            else if(data=="2"){
                _notMatched();
              }
            else{
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return RichAlertDialog(
                    alertTitle: richTitle("Alert!"),
                    alertSubtitle: richSubtitle("Try Again!"),
                    alertType: RichAlertType.WARNING,
                  );
                  oldPassword.clear();
                  newPassword.clear();
                  confirmNewPassword.clear();
                });
            }
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return RichAlertDialog(
                    alertTitle: richTitle("Alert!"),
                    alertSubtitle: richSubtitle("Try Again!"),
                    alertType: RichAlertType.WARNING,
                  );
                  oldPassword.clear();
                    newPassword.clear();
                    confirmNewPassword.clear();
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