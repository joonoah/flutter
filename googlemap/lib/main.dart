import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  double a = 0.0;
  double b = 0.0;

  double lat = 0;
  double lon = 0;

  //현재 위치 받아오기
  getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    a = position.latitude;
    b = position.longitude;
    //현재 좌표를 마커(리스트)에 넣기
    myMarker.add(Marker(markerId: MarkerId("first"), position: LatLng(a, b)));
  }

  //서버로 좌표 보내는 기능
  Future<void> postPosition(double lat, double lon) async {
    try {
      final _url = Uri.parse('http://203.249.22.50:8080/noa');
      http
          .post(_url, headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded',
          }, body: {
            "latitude": lat.toString(),
            "longitude": lon.toString()
          })
          //body: json.encode({token.accessToken}))
          .then((res) => print(json.decode(res.body.toString())))
          .catchError((e) => print(e.toString()));
      print("noah");
    } catch (error) {
      print('에러' + error.toString());
    }
  }

  @override
  void initState() {
    getLocation(); //현재 위치 좌표 받아서 마커에 넣기
    super.initState();
  }

  //찍으곳에 마커 찍고 위경도값 출력
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
            target: myMarker[0].position, zoom: 17.0), //카메라 시작 :현재위치
        markers: Set.from(myMarker),
        onTap: _handleTap, //핑 찍은 곳에 마커 띄우기
      ),
      floatingActionButton: ElevatedButton(
        //
        onPressed: _postaddress, //좌표 전송하기
        child: Text('결정하기'),
      ),
    );
  }

  //좌표 전송
  _postaddress() {
    print(lat);
    print(lon);
    postPosition(lat, lon);
  }

  //핑 찍은 곳을 마커에 추가
  _handleTap(LatLng tappedPoint) {
    double lai = tappedPoint.latitude;
    double loni = tappedPoint.longitude;
    lat = lai;
    lon = loni;
    setState(() {
      myMarker = [];
      myMarker.add(Marker(
        markerId: MarkerId(tappedPoint.toString()),
        position: tappedPoint,
      ));
    });
  }
}
