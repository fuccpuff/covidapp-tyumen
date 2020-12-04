import 'package:covidapp/sceens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:location/location.dart';

import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class LocationPane extends StatefulWidget {
  @override
  LocationPaneState createState() => LocationPaneState();
}

class LocationPaneState extends State<LocationPane> {
  Completer<GoogleMapController> _controller = Completer();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Geoflutterfire geo = Geoflutterfire();
  Location location = new Location();
  Set<Marker> _markers = Set<Marker>();
  BehaviorSubject<double> radius = BehaviorSubject<double>.seeded(100.0);
  Stream<dynamic> query;
  StreamSubscription subscription;

  void _animateToUser() async {
    LocationData pos = await location.getLocation();
    print(pos.latitude);
    print(pos.longitude);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(pos.latitude, pos.longitude),
      zoom: 11.0,
    )));
    print(_controller);
  }

  void _updateMarker(List<DocumentSnapshot> documentList) async {
    var pos = await location.getLocation();
    double lat = pos.latitude;
    double lng = pos.longitude;

    // Make a referece to firestore
    var ref = firestore.collection('locations');
    GeoFirePoint center = geo.point(latitude: lat, longitude: lng);

    _markers.clear();
    documentList.forEach((DocumentSnapshot document) {
      GeoPoint geopoint = document.data()['position']['geopoint']['name'];

      // double distance = center.distance(lat: geopoint.latitude, lng: geopoint.longitude);

      setState(() {
        _markers.add(Marker(
            markerId: MarkerId(document.id),
            position: LatLng(document.data()['position']['geopoint'].latitude,
                document.data()['position']['geopoint'].longitude),
            icon: BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(
                title: 'Возможно заражение')));
      });
    });
  }

  void onBack() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(
        builder: (context) {
          return HomeScreen();
        },
    ),
    );
  }


  _startQuery() async {
    // Get users location
    var pos = await location.getLocation();
    double lat = pos.latitude;
    double lng = pos.longitude;

    // Make a referece to firestore
    var ref = firestore.collection('locations');
    GeoFirePoint center = geo.point(latitude: lat, longitude: lng);
    // subscribe to query
    subscription = radius.switchMap((rad) {
      print(rad);
      return geo.collection(collectionRef: ref).within(
            center: center,
            radius: rad,
            field: 'position',
            strictMode: true,
          );
    }).listen(_updateMarker);
  }

  _updateQuery(value) async {
    print(value);
    final zoomMap = {
      100.0: 12.0,
      200.0: 10.0,
      300.0: 7.0,
      400.0: 6.0,
      500.0: 5.0
    };
    final zoom = zoomMap[value];
    final GoogleMapController controller = await _controller.future;
    controller.moveCamera(CameraUpdate.zoomTo(zoom));

    setState(() {
      radius.add(value);
    });
  }

  @override
  dispose() {
    subscription.cancel();
    super.dispose();
  }

  Future<DocumentReference> _addGeoPoint() async {
    LocationData pos = await location.getLocation();
    GeoFirePoint point =
        geo.point(latitude: pos.latitude, longitude: pos.longitude);
    return firestore
        .collection('locations')
        .add({'position': point.data, 'name': 'Infetionmaybe'});
  }

  void initState() {
    _animateToUser();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Stack(children: [
        GoogleMap(
          markers: _markers,
          initialCameraPosition: CameraPosition(
            target: LatLng(57.153033, 65.534328),
            zoom: 5.0,
          ),
          myLocationEnabled: true,
          compassEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            _startQuery();
          },
        ),
        Positioned(
            bottom: 95,
            right: 10,
            child: FlatButton(
                child: Icon(Icons.pin_drop),
                color: Colors.red[200],
                onPressed: () {
                  _addGeoPoint();
                })),
        Positioned(
            bottom: 145,
            right: 10,
            child: FlatButton(
                child: Icon(Icons.arrow_back_rounded),
                color: Colors.red[200],
                onPressed: () {
                  onBack();
                })),
        Positioned(
            bottom: 50,
            left: 10,
            child: Material(
                child: Slider(
              min: 100.0,
              max: 500.0,
              divisions: 4,
              value: radius.value,
              label: 'Radius ${radius.value}km',
              activeColor: Colors.red[200],
              inactiveColor: Colors.red[200].withOpacity(0.2),
              onChanged: _updateQuery,
            )))
      ]),
    );
  }
}
