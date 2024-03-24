import 'package:fluttertoast/fluttertoast.dart';
import 'package:huawei_location/huawei_location.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationServiceHuawei {
   // PermissionHandler permissionHandler; 
   late FusedLocationProviderClient locationService;

  late LocationRequest locationRequest;
  late List<LocationRequest> locationRequestList;
  late LocationSettingsRequest locationSettingsRequest;

  LocationServiceHuawei(){
   // permissionHandler =PermissionHandler();
    locationService = FusedLocationProviderClient()..initFusedLocationService();

    locationRequest = LocationRequest();
    locationRequest.interval = 5000;
    locationRequestList = <LocationRequest>[locationRequest];
    locationSettingsRequest = LocationSettingsRequest(requests: locationRequestList);
  }

  Future<String> checkLocationSettings() async {
    try{
      LocationSettingsStates? states = await locationService.checkLocationSettings(locationSettingsRequest);
      return states.toString();
    }catch(e){
      return e.toString();
    }

    
  }

   Future<bool> hasPermission() async {
    try {
      var status = await Permission.location.status;
      return status.isGranted;
    } catch (e) {
      Fluttertoast.showToast(
                  msg: "== has permition ==",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,);
      return false;
    }
  }
  
  Future<bool> requestPermission() async {
  try {
    var status = await Permission.location.request();
    return status.isGranted;
  } catch (e) {
    Fluttertoast.showToast(
                  msg: "== request permition ==",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,);
    return false;
    
  }
}

  Future<Location?> getCurrentLocation() async {
    try {
  var locationData = await locationService.getLastLocation();
        Fluttertoast.showToast(
                      msg: "== fetching location ==",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,);
      
      return locationData;
      print("Location =======================================================: $locationData");
    } catch (error) {
        Fluttertoast.showToast(
                      msg: "Error fetching location: $error",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,);
      print("Error fetching location: $error");
      return null;
    }
  }
}