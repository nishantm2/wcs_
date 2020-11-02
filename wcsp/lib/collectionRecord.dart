import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rich_alert/rich_alert.dart';
import 'main.dart';
import 'package:wcsp/collectionData.dart';
import 'global.dart';

class CollectionRecord extends StatefulWidget {
  @override
  _CollectionRecordState createState() =>
      _CollectionRecordState();
}

class _CollectionRecordState extends State<CollectionRecord>
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
  var initialDate = DateTime.parse("2019-08-10"); 
  var finalDate = DateTime.parse("2020-06-01"); 

   nav(){
    String formattedStartDate = DateFormat('dd-MM-yyyy').format(initialDate);
    String formattedEndDate = DateFormat('dd-MM-yyyy').format(finalDate);
    String formatStartDate = DateFormat('yyyy-MM-dd').format(selectedStartDate);
    String formatEndDate = DateFormat('yyyy-MM-dd').format(selectedEndDate);
    if(selectedStartDate.isAfter(initialDate) && selectedEndDate.isBefore(finalDate)){
      indate = formatStartDate;
      fidate = formatEndDate;
       Navigator.push(
              context,
        MaterialPageRoute(builder: (context) => CollectionDataDisplay(),),
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
        title: Text('COLLECTION RECORD'),
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
            margin: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
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
            margin: EdgeInsets.fromLTRB(0.0, 95.0, 0.0, 0.0),
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: 20.0,
            child: Text("${selectedStartDate.toLocal()}".split(' ')[0],style: TextStyle(fontWeight: FontWeight.bold),),
          ),
          new Container(
            margin: EdgeInsets.fromLTRB(0.0, 130.0, 0.0, 0.0),
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
            margin: EdgeInsets.fromLTRB(0.0, 185.0, 0.0, 0.0),
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: 20.0,
            child: Text("${selectedEndDate.toLocal()}".split(' ')[0],style: TextStyle(fontWeight: FontWeight.bold),),
          ),
          new Container(
            margin: EdgeInsets.fromLTRB(0.0, 215.0, 0.0, 0.0),
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
