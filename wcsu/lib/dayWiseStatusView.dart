import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'global.dart';
import 'package:wcsu/dayWiseStatus.dart';

class DayWiseStatusView extends StatefulWidget {
  @override
  _DayWiseStatusViewState createState() =>
      _DayWiseStatusViewState();
}

class _DayWiseStatusViewState extends State<DayWiseStatusView>{
  
  var data;
  Future<List<Status>> details() async {
    String area = selected;
    var data = await http.post(
        "http://wcshcst.xyz/dayWiseStatusView.php?area=${area}");
        print(data.statusCode);
    var jsonData = json.decode(data.body);
    List<Status> status = [];

    for (var u in jsonData) {
      Status fc = Status(u["Room_no"], u["Contact_person"], u["Mobile_no"]);
      status.add(fc);
    }
    return status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("TODAY'S STATUS"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      DayWiseStatus()),
              (Route<dynamic> route) => false),
        ),
      ),
      body: new Stack(
        children: <Widget>[
          new Container(
              margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              child: Center(
                child: FutureBuilder<List<Status>>(
                    future: details(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Status>> snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                          child: Center(
                            child: Text("Loading..."),
                          ),
                        );
                      } else {
                        return Center(
                          child: ListView(
                            children: <Widget>[
                              new SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columns: [
                                    DataColumn(
                                      label: Text(
                                        "ROOM NUMBER",
                                      ),
                                      numeric: false,
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "CONTACT PERSON",
                                      ),
                                      numeric: false,
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "MOBILE NUMBER",
                                      ),
                                      numeric: false,
                                    ),
                                  ],
                                  rows: snapshot.data
                                      .map(
                                        (status) => DataRow(cells: [
                                          DataCell(
                                            Text(
                                              status.room,
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              status.name,
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              status.mobile,
                                            ),
                                          ),
                                        ]),
                                      )
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    }),
              ),
            ),
        ],
      ),
    );
  }
}

class Status {
  String room;
  String name;
  String mobile;

  Status(this.room, this.name, this.mobile);
}