import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rich_alert/rich_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progress_dialog/progress_dialog.dart';

class AcceptAmount extends StatefulWidget {
  @override
  _AcceptAmountState createState() => _AcceptAmountState();
}

class _AcceptAmountState extends State<AcceptAmount> {
  final TextEditingController amount = new TextEditingController();
  bool _isLoading = false;
  var amtt;
  var billl;
  ProgressDialog pr;

  Future<String> genAmount() async {
    var jsonResponse;
    SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    var cd = sharedPreferences.getString("customerID");
    var response =
        await http.post("http://wcshcst.xyz/generateAmount.php?cd=${cd}");
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        billl = jsonResponse['result'];
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    }
    return "success";
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context,type: ProgressDialogType.Normal);
    pr.style(message: 'Processing...');
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: Text('COLLECT PAYMENT'),
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
                          controller: amount,
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
                            labelText: "Enter Amount",
                          ),
                          maxLines: 1,
                          autofocus: true,
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                        ),
                        new MaterialButton(
                          height: 40.0,
                          minWidth: 100.0,
                          color: Colors.lightBlue[800],
                          textColor: Colors.white,
                          child: new Text("Submit"),
                          onPressed: () {
                            setState(() {
                              _isLoading = true;
                            });
                            pr.show();
                            submit(amount.text);
                          },
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                        ),
                        new FutureBuilder(
                            future: genAmount(),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.data != null) {
                                return Center(
                                  child: Text(
                                    'Pending Amount for this Customer: '+billl.toString(),
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 17),
                                  ),
                                );
                              }
                              return CircularProgressIndicator();
                            })
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

  Future<void> _accepted() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Payment Done!',
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
                amount.clear();
                pr.hide();
              },
            ),
          ],
          elevation: 24.0,
          backgroundColor: Colors.green[800],
        );
      },
    );
  }

  Future<void> _notAccepted() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Unable to Process!',
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
                amount.clear();
              },
            ),
          ],
          elevation: 24.0,
          backgroundColor: Colors.red[800],
        );
      },
    );
  }

  submit(amt) async {
    var jsonResponse;
    var data;
    SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    var cid = sharedPreferences.getString("customerID");
    var lid= sharedPreferences.getString("token");
    var response = await http
        .post("http://wcshcst.xyz/acceptAmount.php?cid=${cid} & amt=${amt} & lid=${lid}");
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        if (jsonResponse['result1'].isNotEmpty) {
          data = jsonResponse['result1'];
          if (data[0]['STATUS'] == "1") {
            _accepted();
          } else {
            _notAccepted();
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
