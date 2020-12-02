import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({this.hospital, this.latitude, this.longitude});
  final String hospital;
  final latitude, longitude;
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  Set<Marker> markers = HashSet<Marker>();
  GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.hospital),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Локация на карте',
                style: TextStyle(
                    letterSpacing: 1,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: size.height * 0.45,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                    setState(() {
                      markers.add(
                        Marker(
                          markerId: MarkerId(
                              '${DateTime.now().millisecondsSinceEpoch}'),
                          position: LatLng(widget.latitude, widget.longitude),
                        ),
                      );
                    });
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(widget.latitude, widget.longitude),
                    zoom: 12,
                  ),
                  markers: markers,
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
    ;
  }
}
