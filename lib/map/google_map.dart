import 'dart:async';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:new_map_my/location/google_location_service.dart';

class MapGoogle extends StatefulWidget {
  const MapGoogle({super.key});

  @override
  State<StatefulWidget> createState() => _MapGoogleState();
}

class _MapGoogleState extends State<MapGoogle> {

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
  static const LatLng destination = LatLng(37.33429383, -122.06600055);
  LocationServiceGoogle googleLocation = LocationServiceGoogle();
  List<LatLng> polylineCoordinate = [];
  LocationData? currentLocation;
// Get Current Location
  Future<void> getCurrentLocation() async {
  

  currentLocation = await googleLocation.getCurrentLocation();
  setState(() {});
}


  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyDjLxe2E-ee8xdqJSasfL6J2hUoex4F6Mw',
       PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude)
        );

        if(result.points.isNotEmpty){
          for (var point in result.points) {
            polylineCoordinate.add(LatLng(point.latitude, point.longitude));
          }
          setState(() {
            
          });
        }
  }
  
       @override
  void initState() {
    super.initState();
   
    getCurrentLocation().then((_) {
      getPolyPoints();
      setState(() {});
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: currentLocation == null
      ? const Center(child: Text("loading"),)
      :GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition:  CameraPosition(
          target: LatLng(currentLocation!.latitude!,currentLocation!.longitude!),
          zoom: 14.5
          ),
        myLocationEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          
        },
        markers: {
             Marker(markerId: const MarkerId('currentLocation'),
            position:LatLng(currentLocation!.latitude!,currentLocation!.longitude!),
            ),
            const Marker(markerId: MarkerId('source'),
            position: sourceLocation,
            ),
            const Marker(markerId: MarkerId('destination'),
            position: destination,
            )
        },
        polylines: {
          Polyline(polylineId: const PolylineId('route'),
          points: polylineCoordinate,
          color: Colors.blue,
          width: 10,
          )
        },
        
        ),
      
    );
  }
}