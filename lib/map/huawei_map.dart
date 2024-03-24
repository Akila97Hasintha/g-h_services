import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:huawei_map/huawei_map.dart';
import 'package:new_map_my/location/huawei_location_services.dart';
import 'package:logger/logger.dart';

class MapHuawei extends StatefulWidget {
  const MapHuawei({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MapHuaweiState createState() => _MapHuaweiState();
}

class _MapHuaweiState extends State<MapHuawei> {
  final LocationServiceHuawei locationService = LocationServiceHuawei();
  final Logger _logger = Logger();
  LatLng? currentLocation;
  late String lati;
  bool initialLocationMarkerAdded = false;
 Set<Marker> markers = <Marker>{};
  List<LatLng> selectedLocations = [];
   



  @override
  void initState() {
    super.initState();
    HuaweiMapInitializer.setApiKey(apiKey: 'DAEDAJuK0ln1CJv0eVuQkZkGvjI2PugNRiwKvpqVOyr+yazQJIcZ99nE7lP9OndwUV/61hgSCWQBT6RWTm4CBM0ob5nRcHBLmNGvGw==');
    HuaweiMapInitializer.initializeMap();
    initLocation();
    
  }

 
  initLocation() async {
    try {
      await locationService.requestPermission();
      
      
      final location = await locationService.getCurrentLocation();
      

      if (location != null) {
        setState(() {
          try{
              
           currentLocation = LatLng(location.latitude!, location.longitude!);
           addMarker(currentLocation!, "Your Location", true);
           Fluttertoast.showToast(
                  msg: " location ==: $currentLocation + $location.latitude ",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,);
           
          }catch(e){
               Fluttertoast.showToast(
                  msg: " location: $e",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,);
          }
          
          
          addMarker(currentLocation!, "Your Location", true);
          
        });
       // addMarker(LatLng(37.33500926, -122.03272188));
       
      }else{
          Fluttertoast.showToast(
            msg: " location null:",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,);
      }
        
      addMarker(currentLocation!, "Your Location", true);

    } catch (e) {

      _logger.e("Error fetching location========: $e");
            Fluttertoast.showToast(
                msg: "Error fetching location////: $e",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
              );
    }
  }


   void addMarker(LatLng position, String title, bool isCurrentLocation) {
    final Marker newMarker = Marker(
      markerId: MarkerId(isCurrentLocation ? "currentLocation" : "selectedMarker_${position.lat}_${position.lng}"),
      position: position ,
      infoWindow: InfoWindow(
        title: title,
        snippet: isCurrentLocation ? "This is your current location" : "This is a selected marker",
      ),
      icon: isCurrentLocation ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed) : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );

    setState(() {
      markers.add(newMarker);
     
    });
  }

 

  @override
  Widget build(BuildContext context) {

    

    return Scaffold(
      body: HuaweiMap(
        
        initialCameraPosition: CameraPosition(
          target: currentLocation!,
          zoom: 12,
        ),
        mapType: MapType.normal,
        tiltGesturesEnabled: true,
        buildingsEnabled: true,
        compassEnabled: true,
        zoomControlsEnabled: true,
        rotateGesturesEnabled: true,
        myLocationButtonEnabled: true,// change
        myLocationEnabled: false,
        trafficEnabled: true,
        onClick: (LatLng latLng) {
          addMarker(latLng, "Selected Location", false);
        },
        markers: markers,
        
      ),
    );
  }
  
  }


  

