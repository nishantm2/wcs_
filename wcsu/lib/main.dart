import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wcsu/collectWaste.dart';
import 'package:wcsu/myDetails.dart';
import 'package:wcsu/acceptPayment.dart';
import 'package:wcsu/dumpWaste.dart';
import 'package:wcsu/dayWiseStatus.dart';
import 'package:wcsu/changePassword.dart';
import 'login.dart';

void main() => runApp(TabNavTheme());

class TabNavTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(
        primaryColor: Colors.lightBlue[800],
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
  // var textValue;
  // FirebaseMessaging firebaseMessaging = new FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    user = sharedPreferences.getString("token");
    if (user == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
    }
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
                  color: Colors.lightBlue[700],
                  textColor: Colors.white,
                  child: new Text("Collect Waste"),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CollectWaste(),
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
                  color: Colors.lightBlue[700],
                  textColor: Colors.white,
                  child: new Text("Today's Status"),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DayWiseStatus(),
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
                  color: Colors.lightBlue[700],
                  textColor: Colors.white,
                  child: new Text("Collect Payment"),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AcceptPayment(),
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
                  color: Colors.lightBlue[700],
                  textColor: Colors.white,
                  child: new Text("My Details"),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyDetails(),
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
                  color: Colors.lightBlue[700],
                  textColor: Colors.white,
                  child: new Text("Dumping Site Locator"),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DumpWaste(),
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
                  color: Colors.lightBlue[700],
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
}
