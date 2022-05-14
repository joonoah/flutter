import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'dart:async';
import 'package:geolocator/geolocator.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('GoogleMap'),
        ),
        body: MapSample(),
      ),
    ),
  );
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  List<Marker> myMarker = [];
  double a = 0;
  double b = 0;

  void fetchData() async {
    print("2");
    final response = await http.get(Uri.parse('http://203.249.22.49:8000'));

    String jsonData = response.body;
    List list = jsonDecode(jsonData);
    print("List : " + list.toString());

    for (var colar in list) {
      a = colar['lantitude'];
      b = colar['longitude'];
      print(a);
      print(b);
      print("${colar['lantitude']} ${colar['longitude']}");
    }
  }

  void initState() {
    super.initState();
    fetchData();
    myMarker.add(
      Marker(markerId: MarkerId("first"), position: LatLng(a, b)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GoogleMap(
      initialCameraPosition: CameraPosition(target: LatLng(a, b), zoom: 14.0),
      markers: Set.from(myMarker),
    ));
  }
}
