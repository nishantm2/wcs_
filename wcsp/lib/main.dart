import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'package:wcsp/customerDetails.dart';
import 'package:wcsp/collectionRecord.dart';
import 'package:rich_alert/rich_alert.dart';
import 'package:wcsp/changePassword.dart';
import 'package:wcsp/paymentRecord.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
void main() => runApp(TabNavTheme());

class TabNavTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(
        primaryColor: Colors.green,
      ),
      home: new TabNav(),
    );
  }
}


class TabNav extends StatefulWidget {
  @override
  _TabNavState createState() => _TabNavState();
}

class _TabNavState extends State<TabNav> with SingleTickerProviderStateMixin {
  SharedPreferences sharedPreferences;
  List data;
  String user;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    setupNotification();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    user = sharedPreferences.getString("custID");
    if (user == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
    }
  }

  void setupNotification() async {

   _firebaseMessaging.getToken().then((token){
     print(token);
   });

   _firebaseMessaging.configure(
     onMessage: (Map<String, dynamic> message) async{
       print("Message : $message");
      showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            message['notification']['title']+"\n"+message['notification']['body'],
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
              },
            ),
          ],
          elevation: 24.0,
          backgroundColor: Colors.amber[800],
        );
      },
    );
     },
     onResume: (Map<String, dynamic> message) async{
       print("Message : $message");
     },
     onLaunch: (Map<String, dynamic> message) async{
       print("Message : $message");
     }
   );

  }


   @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        centerTitle: true,
        title: Text('WCS'),
        actions: <Widget>[
          IconButton(
            icon: FaIcon(FontAwesomeIcons.signOutAlt),
            onPressed: () {
              sharedPreferences.clear();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage()),
                  (Route<dynamic> route) => false);
            },
          )
        ],
      ),
      body: new Center(
        child: new ListView(
          children: [
            Center(
              child: new Container(
                margin: EdgeInsets.fromLTRB(0.0, 150.0, 0.0, 0.0),
                child: new MaterialButton(
                  height: 50.0,
                  minWidth: (MediaQuery.of(context).size.width) - 20,
                  color: Colors.green,
                  textColor: Colors.white,
                  child: new Text("Collection Status"),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                  ),
                  onPressed: () {
                    setState(() {
                                _isLoading = true;
                              });
                              collectionStatus();
                  },
                  splashColor: Colors.white70,
                ),
              ),
            ),
            Center(
              child: new Container(
                margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                child: new MaterialButton(
                  height: 50.0,
                  minWidth: (MediaQuery.of(context).size.width) - 20,
                  color: Colors.green,
                  textColor: Colors.white,
                  child: new Text("My Details"),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomerDetails(),
                      ),
                    );
                  },
                  splashColor: Colors.white70,
                ),
              ),
            ),
            Center(
              child: new Container(
                margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                child: new MaterialButton(
                  height: 50.0,
                  minWidth: (MediaQuery.of(context).size.width) - 20,
                  color: Colors.green,
                  textColor: Colors.white,
                  child: new Text("Collection Record"),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CollectionRecord(),
                      ),
                    );
                  },
                  splashColor: Colors.white70,
                ),
              ),
            ),
            Center(
              child: new Container(
                margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                child: new MaterialButton(
                  height: 50.0,
                  minWidth: (MediaQuery.of(context).size.width) - 20,
                  color: Colors.green,
                  textColor: Colors.white,
                  child: new Text("Payment Ledger"),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentRecord(),
                      ),
                    );
                  },
                  splashColor: Colors.white70,
                ),
              ),
            ),
            Center(
              child: new Container(
                margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                child: new MaterialButton(
                  height: 50.0,
                  minWidth: (MediaQuery.of(context).size.width) - 20,
                  color: Colors.green,
                  textColor: Colors.white,
                  child: new Text("Change Password"),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangePassword(),
                      ),
                    );
                  },
                  splashColor: Colors.white70,
                ),
              ),
            ),
          ],
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
            'Your Waste is Collected!',
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
              },
            ),
          ],
          elevation: 24.0,
          backgroundColor: Colors.red[800],
        );
      },
    );
  }

 collectionStatus() async {
   var id = sharedPreferences.getString("custID");
    var jsonResponse;
    var data;
    var response = await http.post(
        "http://wcshcst.xyz/collectionStatus.php?cid=${id}");
        if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);
        if (jsonResponse != null) {
          setState(() {
            _isLoading = false;
          });
          
          if (jsonResponse['result'].isNotEmpty) {
            data = jsonResponse['result'];
            print(data[0]['STATUS']);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TabNav(),
                ),
              ).then((value) {
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
          setState(() {
            _isLoading = false;
          });
        }
      }
      else {
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
  }

}