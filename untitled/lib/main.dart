import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
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
  double la = 0.0;
  double lo = 0.0;
  String add = "";
//서버로부터 좌표 받아오기
  void fetchData() async {
    final response = await http.get(Uri.parse('http://203.249.22.49:8000'));

    String jsonData = response.body;
    List list = jsonDecode(jsonData);
    la = list[0]['lantitude'];
    lo = list[0]['longitude'];

    //좌표->주소로 변환
    final placeMarks =
        await placemarkFromCoordinates(la, lo, localeIdentifier: "ko_KR");
    add = ("${placeMarks[0].country} ${placeMarks[0].administrativeArea} "
        "${placeMarks[0].locality} ${placeMarks[0].subLocality} "
        "${placeMarks[0].thoroughfare} ${placeMarks[0].street}");

    print(add);//주소출력
    setState(() {
      myMarker = [];
      myMarker.add(
        //마커에 추가(이름: 주소(한글))
        Marker(markerId: MarkerId(add), position: LatLng(la, lo)),
      );
    });
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(myMarker[0].markerId.toString()),
        ),
        body: GoogleMap(
          initialCameraPosition:
              CameraPosition(target: myMarker[0].position, zoom: 17.0),
          markers: Set.from(myMarker),
        ));
  }
}
