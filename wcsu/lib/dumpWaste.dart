import 'package:flutter/material.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:geodesy/geodesy.dart';
import 'package:geocoder/geocoder.dart';

class DumpWaste extends StatefulWidget {
  @override
  _DumpWasteState createState() => _DumpWasteState();
}

class _DumpWasteState extends State<DumpWaste> {
  bool _isLoading = false;

Future<String> getPos() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var cLat=position.latitude;
    var cLong=position.longitude;
    var dist=new List();
    Geodesy geodesy = Geodesy();
    LatLng myPos = LatLng(cLat,cLong);
    LatLng p1 = LatLng(25.316806,82.990170);
    LatLng p2 = LatLng(25.280652,83.120966);
    LatLng p3 = LatLng(25.326911,82.986412);
    num distance = geodesy.distanceBetweenTwoGeoPoints(myPos, p1);
    num distance1 = geodesy.distanceBetweenTwoGeoPoints(myPos, p2);
    num distance2 = geodesy.distanceBetweenTwoGeoPoints(myPos, p3);
    dist.add(distance);
    dist.add(distance1);
    dist.add(distance2);
    var d=dist[0];
    for(var i=0;i<2;i++){
      if(dist[i]>dist[i+1]){
        d=dist[i+1];
      }
    }
    LatLng add=LatLng(0,0);
    if(d==distance){
       add = LatLng(25.316806,82.990170);
    }
    else if(d==distance1){
       add = LatLng(25.280652,83.120966);
    }
    else{
       add = LatLng(25.326911,82.986412);
    }
    final coordinates = new Coordinates(add.latitude, add.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      String addr='Nearest Dump Station From Your Location is:\n ${first.featureName}, ${first.locality}, ${first.adminArea}';
      // print(' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
    // print(addr);
    return addr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: Text('DUMP SITE'),
      ),
      body: Center(
      child: FutureBuilder(
        future: getPos(),
        builder: (context,snapshot){
          if(snapshot.data!=null){
            return Center(
              child: Text(
                snapshot.data,
                style: TextStyle(fontStyle: FontStyle.italic,fontSize:17),
                
              ),
            );
          }
          return CircularProgressIndicator();
        }
      )
    ),
    );
            
  }
  
}