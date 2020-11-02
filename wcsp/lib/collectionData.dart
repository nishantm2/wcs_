import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'global.dart';
import 'package:wcsp/collectionRecord.dart';

class CollectionDataDisplay extends StatefulWidget {
  @override
  _CollectionDataDisplayState createState() =>
      _CollectionDataDisplayState();
}

class _CollectionDataDisplayState extends State<CollectionDataDisplay>
    with SingleTickerProviderStateMixin {
  
  var data;
  Future<List<Records>> details() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString("custID");
    var data = await http.post(
        "http://wcshcst.xyz/wasteCollectionData.php?cid=${id}&indate=${indate}&fidate=${fidate}");
        print(data.statusCode);
    var jsonData = json.decode(data.body);
    List<Records> records = [];

    for (var u in jsonData) {
      Records fc = Records(u["Date"], u["Status"]);
      records.add(fc);
    }
    return records;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('COLLECTION RECORD'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      CollectionRecord()),
              (Route<dynamic> route) => false),
        ),
      ),
      body: new Stack(
        children: <Widget>[
          new Container(
              margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              child: Center(
                child: FutureBuilder<List<Records>>(
                    future: details(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Records>> snapshot) {
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
                                child: DataTable(
                                  columns: [
                                    DataColumn(
                                      label: Text(
                                        "DATE(YYYY-MM-DD)",
                                      ),
                                      numeric: false,
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "STATUS",
                                      ),
                                      numeric: false,
                                    ),
                                  ],
                                  rows: snapshot.data
                                      .map(
                                        (records) => DataRow(cells: [
                                          DataCell(
                                            Text(
                                              records.date,
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              records.status,
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

class Records {
  String date;
  String status;

  Records(this.date, this.status);
}