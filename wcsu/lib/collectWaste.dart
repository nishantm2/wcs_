import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rich_alert/rich_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CollectWaste extends StatefulWidget {
  @override
  _CollectWasteState createState() => _CollectWasteState();
}

class _CollectWasteState extends State<CollectWaste> {
  final TextEditingController rfidController = new TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: Text('COLLECT WASTE'),
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
                      // hintColor: Colors.white24,
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
                          controller: rfidController,
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
                            labelText: "Scan RFID",
                          ),
                          maxLines: 1,
                          autofocus: true,
                          obscureText: true,
                          onChanged: (newValue) {
                            submit(newValue);
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

  Future<void> _collected() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Waste Collected!',
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
                rfidController.clear();
              },
            ),
          ],
          elevation: 24.0,
          backgroundColor: Colors.green[800],
        );
      },
    );
  }

  Future<void> _notCollected() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Waste Not Collected!',
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
                rfidController.clear();
              },
            ),
          ],
          elevation: 24.0,
          backgroundColor: Colors.red[800],
        );
      },
    );
  }

  submit(rfid) async {
    SharedPreferences sharedPreferences;
    var jsonResponse;
    var data;
    sharedPreferences = await SharedPreferences.getInstance();
    var id = sharedPreferences.getString("token");
    if (rfid.length == 10) {
      var response = await http.post(
          "http://wcshcst.xyz/wasteCollection.php?rfid=${rfid}&id=${id}");
      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);
        if (jsonResponse != null) {
          setState(() {
            _isLoading = false;
          });
          if (jsonResponse['result'].isNotEmpty) {
            data = jsonResponse['result'];
            if (data[0]['RFID'] == rfid) {
              
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CollectWaste(),
                ),
              ).then((value) {
                rfidController.clear();
              });
              if(data[0]['STATUS'] == "1"){
                _collected();
              }else{
                _notCollected();
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
}
