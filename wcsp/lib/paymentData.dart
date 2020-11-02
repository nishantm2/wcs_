import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'global.dart';
import 'package:wcsp/paymentRecord.dart';

class PaymentDataDisplay extends StatefulWidget {
  @override
  _PaymentDataDisplayState createState() =>
      _PaymentDataDisplayState();
}

class _PaymentDataDisplayState extends State<PaymentDataDisplay>
    with SingleTickerProviderStateMixin {
  
  var data;
  Future<List<Recordss>> details() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    // print(studentid);
    String id = sharedPreferences.getString("custID");
    var data = await http.post(
        "http://wcshcst.xyz/paymentData.php?cid=${id}&indate=${inidate}&fidate=${findate}");
        // print(data.statusCode);
    var jsonData = json.decode(data.body);
    // print(jsonData);
    List<Recordss> recordss = [];

    for (var u in jsonData) {
      Recordss fs = Recordss(u["Date"],u["Receipt_no"], u["Amount"],u["Due"],u["Excess"],);
      recordss.add(fs);
    }
    return recordss;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('PAYMENT RECORD'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      PaymentRecord()),
              (Route<dynamic> route) => false),
        ),
      ),
      body: new Stack(
        children: <Widget>[
          new Container(
              margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              child: Center(
                child: FutureBuilder<List<Recordss>>(
                    future: details(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Recordss>> snapshot) {
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
                                        "DATE(YYYY-MM-DD)",
                                      ),
                                      numeric: false,
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "RECEIPT NUMBER",
                                      ),
                                      numeric: false,
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "AMOUNT",
                                      ),
                                      numeric: false,
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "DUE",
                                      ),
                                      numeric: false,
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "EXCESS",
                                      ),
                                      numeric: false,
                                    ),
                                  ],
                                  rows: snapshot.data
                                      .map(
                                        (recordss) => DataRow(cells: [
                                          DataCell(
                                            Text(
                                              recordss.date,
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              recordss.receiptNo,
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              recordss.amount,
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              recordss.due,
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              recordss.excess,
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

class Recordss {
  String date;
  String receiptNo;
  String amount;
  String due;
  String excess;
  Recordss(this.date, this.receiptNo,this.amount,this.due,this.excess);
}