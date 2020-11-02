import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyDetails extends StatefulWidget {
  @override
  _MyDetailsState createState() => _MyDetailsState();
}

class _MyDetailsState extends State<MyDetails> {
  final TextEditingController rfidController = new TextEditingController();
  bool _isLoading = false;
  var data;

   Future<String> fetchdetails() async {
    SharedPreferences sharedPreferences;
    var jsonResponse;
    sharedPreferences = await SharedPreferences.getInstance();
    var id = sharedPreferences.getString("token");
    if (id == null) {
      var response = await http.post(
          "http://wcshcst.xyz/empDetails.php?PSEUDO=${id}");
      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);
        if (jsonResponse != null) {
        }
        print(data);
      } else {
      }
      return "success";
    } else {
      var response = await http
          .post("http://wcshcst.xyz/empDetails.php?PSEUDO=${id}");
      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);
        if (jsonResponse != null) {
          data = jsonResponse;
        }
      } else {
      }
      return "success";
    }
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: Text('DETAILS'),
      ),
      body: new Stack(
        children: <Widget>[
          new Container(
            child: FutureBuilder(
              future: fetchdetails(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Container(
                      child: Center(child: CircularProgressIndicator()));
                } else {
                  return new ListView(
                    children: <Widget>[
                      new ListTile(
                        leading: const Icon(Icons.info),
                        title: const Text('Login ID'),
                        subtitle: Text(data['Login_ID']),
                      ),
                      new ListTile(
                        leading: const Icon(Icons.person),
                        title: const Text('Name'),
                        subtitle: Text(data['Name']),
                      ),
                      new ListTile(
                        leading: const Icon(Icons.phone_android),
                        title: const Text('Mobile Number'),
                        subtitle: Text(data['Mobile_no']),
                      ),
                      new ListTile(
                        leading: const Icon(Icons.mail_outline),
                        title: const Text('Email-ID'),
                        subtitle: Text(data['Email']),
                      ),
                      new ListTile(
                        leading: const Icon(Icons.home),
                        title: const Text('Address'),
                        subtitle: Text(data['Address']),
                      ),
                      new ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: const Text('Date of Joining'),
                        subtitle: Text(data['DOJ']),
                      ),
                      ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}