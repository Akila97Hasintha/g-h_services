import 'package:location/location.dart';

class LocationServiceGoogle {
  
  Future<LocationData?> getCurrentLocation() async {
    Location location = Location();
    bool serviceEnabled = await location.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        
        return null;
      }
    }

    PermissionStatus permissionStatus = await location.hasPermission();

    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
       
        return null;
      }
    }

    try {
      LocationData currentLocation = await location.getLocation();
      return currentLocation;
    } catch (e) {
      print("Error getting location: $e");
      return null;
    }
  }
}
