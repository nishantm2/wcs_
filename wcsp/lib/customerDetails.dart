import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CustomerDetails extends StatefulWidget {
  @override
  _CustomerDetailsState createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  final TextEditingController rfidController = new TextEditingController();
  bool _isLoading = false;
  var data;

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: Text('MY DETAILS'),
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
                        title: const Text('Customer ID'),
                        subtitle: Text(data['Customer_ID']),
                      ),
                      new ListTile(
                        leading: const Icon(Icons.person),
                        title: const Text('Contact Person'),
                        subtitle: Text(data['Contact_person']),
                      ),
                      new ListTile(
                        leading: const Icon(Icons.business),
                        title: const Text('Area'),
                        subtitle: Text(data['Area']),
                      ),
                      new ListTile(
                        leading: const Icon(Icons.room),
                        title: const Text('Room Number'),
                        subtitle: Text(data['Room_no']),
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
                        leading: const Icon(Icons.style),
                        title: const Text('RFID'),
                        subtitle: Text(data['RFID']),
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

  Future<String> fetchdetails() async {
    SharedPreferences sharedPreferences;
    var jsonResponse;
    sharedPreferences = await SharedPreferences.getInstance();
    var id = sharedPreferences.getString("custID");
    if (id == null) {
      var response = await http.post(
          "http://wcshcst.xyz/customerDetails.php?cid=${id}");
      if (response.statusCode == 200) {
        print(response.statusCode);
        jsonResponse = json.decode(response.body);
        if (jsonResponse != null) {
        }
        print(data);
      } else {
      }
      return "success";
    } else {
      var response = await http
          .post("http://wcshcst.xyz/customerDetails.php?cid=${id}");
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
}