import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'global.dart';
import 'main.dart';
import 'package:wcsu/dayWiseStatusView.dart';

class DayWiseStatus extends StatefulWidget {
  @override
  _DayWiseStatusState createState() => _DayWiseStatusState();
}

class _DayWiseStatusState extends State<DayWiseStatus>
    with SingleTickerProviderStateMixin {
  String selectedValues;

  List<String> _area = <String>['',
    'AUDITORIUM','MAIN BUILDING','MBA BUILDING','TRAINING AND PLACEMENT','TRAINING AND DEVELOPEMENT','CULTURAL DEPARTMENT','LIBRARY','READING HALL',
'WORKSHOP BUILDING',
'GUEST HOUSE',
'SWAMI VIVEKANAND HALL',
'VIKRAM SARABHAI HALL',
'RADHA KRISHNA HALL',
'SHARDA HALL',
'SENIOR FACULTY HALL',
  ];
  String _areaa = '';

  nav() {
    selected = _areaa;
    print(selected);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DayWiseStatusView()),
    );
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
            height: 70.0,
            child: new FormField<String>(
              builder: (FormFieldState<String> state) {
                return InputDecorator(
                  decoration: InputDecoration(
                    icon: const Icon(FontAwesomeIcons.graduationCap),
                    labelText: 'Select Area',
                  ),
                  isEmpty: _areaa == '',
                  child: new DropdownButtonHideUnderline(
                    child: new DropdownButton<String>(
                      value: _areaa,
                      isDense: true,
                      onChanged: (String newValue) {
                        setState(() {
                          _areaa = newValue;
                          state.didChange(newValue);
                        });
                      },
                      items: _area.map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
          new Container(
            margin: EdgeInsets.fromLTRB(0.0, 220.0, 0.0, 0.0),
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: 45.0,
            child: new MaterialButton(
              height: 40.0,
              minWidth: MediaQuery.of(context).size.width / 2,
              color: Colors.blue,
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
