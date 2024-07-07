// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationAttendanceScreen extends StatefulWidget {
  const LocationAttendanceScreen({super.key});

  @override
  State<LocationAttendanceScreen> createState() =>
      _LocationAttendanceScreenState();
}

class _LocationAttendanceScreenState extends State<LocationAttendanceScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition initialCameraPosition = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(32.6415732, 74.1669387),
      zoom: 19.151926040649414);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Attendance Location'),
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: initialCameraPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    ));
  }
}
