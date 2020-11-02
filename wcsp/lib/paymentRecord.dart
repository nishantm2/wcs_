import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rich_alert/rich_alert.dart';
import 'main.dart';
import 'dart:convert';
import 'package:wcsp/paymentData.dart';
import 'global.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PaymentRecord extends StatefulWidget {
  @override
  _PaymentRecordState createState() =>
      _PaymentRecordState();
}

class _PaymentRecordState extends State<PaymentRecord>
    with SingleTickerProviderStateMixin {
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();


 Future<Null> _selectStartDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedStartDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedStartDate)
      setState(() {
        selectedStartDate = picked;
      });
  }

  Future<Null> _selectEndDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedEndDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedEndDate)
      setState(() {
        selectedEndDate = picked;
      });
  }
var billl;
bool _isLoading = false;
   Future<String> genAmount() async {
    var jsonResponse;
    SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    var cd = sharedPreferences.getString("custID");
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

  var initialDate = DateTime.parse("2019-08-10"); 
  var finalDate = DateTime.parse("2020-06-01"); 

   nav(){
    String formattedStartDate = DateFormat('dd-MM-yyyy').format(initialDate);
    String formattedEndDate = DateFormat('dd-MM-yyyy').format(finalDate);
    String formatStartDate = DateFormat('yyyy-MM-dd').format(selectedStartDate);
    String formatEndDate = DateFormat('yyyy-MM-dd').format(selectedEndDate);
    if(selectedStartDate.isAfter(initialDate) && selectedEndDate.isBefore(finalDate)){
      inidate = formatStartDate;
      findate = formatEndDate;
       Navigator.push(
              context,
        MaterialPageRoute(builder: (context) => PaymentDataDisplay(),),
      );
    }else{
      showDialog(
        context: context,
        builder: (BuildContext context) {
        return RichAlertDialog(
          alertTitle: richTitle("Alert!"),
          alertSubtitle: richSubtitle("Choose date from "+formattedStartDate+" to "+formattedEndDate),
          alertType: RichAlertType.WARNING,
        );
      });
    }
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
                      TabNav()),
              (Route<dynamic> route) => false),
        ),
      ),
      body: new Stack(
        children: <Widget>[
          new Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: 45.0,
            margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
            child: new FutureBuilder(
                            future: genAmount(),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.data != null) {
                                return Center(
                                  child: Text(
                                    'You have a pending Bill of Rs.: '+billl.toString(),
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 17),
                                  ),
                                );
                              }
                              return CircularProgressIndicator();
                            })
          ),
          new Container(
            margin: EdgeInsets.fromLTRB(0.0, 80.0, 0.0, 0.0),
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: 45.0,
            child: new MaterialButton(
              height: 40.0,
              minWidth: MediaQuery.of(context).size.width - 20,
              color: Colors.green,
              textColor: Colors.white,
              child: new Text("Select Initial Date"),
              onPressed: () => _selectStartDate(context),
            ),
          ),
          new Container(
            margin: EdgeInsets.fromLTRB(0.0, 135.0, 0.0, 0.0),
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: 20.0,
            child: Text("${selectedStartDate.toLocal()}".split(' ')[0],style: TextStyle(fontWeight: FontWeight.bold),),
          ),
          new Container(
            margin: EdgeInsets.fromLTRB(0.0, 170.0, 0.0, 0.0),
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: 45.0,
            child: new MaterialButton(
              height: 40.0,
              minWidth: MediaQuery.of(context).size.width - 20,
              color: Colors.green,
              textColor: Colors.white,
              child: new Text("Select Final Date"),
              onPressed: () => _selectEndDate(context),
            ),
          ),
          new Container(
            margin: EdgeInsets.fromLTRB(0.0, 225.0, 0.0, 0.0),
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: 20.0,
            child: Text("${selectedEndDate.toLocal()}".split(' ')[0],style: TextStyle(fontWeight: FontWeight.bold),),
          ),
          new Container(
            margin: EdgeInsets.fromLTRB(0.0, 255.0, 0.0, 0.0),
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: 45.0,
            child: new MaterialButton(
              height: 40.0,
              minWidth: MediaQuery.of(context).size.width/2,
              color: Colors.green,
              textColor: Colors.white,
              child: new Text("Submit"),
              onPressed: () => nav(),
            ),
          ),
        ],
      ),
    );
  }
}
