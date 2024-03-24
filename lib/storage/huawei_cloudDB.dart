import 'package:agconnect_clouddb/agconnect_clouddb.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CloudDBService {
  late AGConnectCloudDBZone _zone;

  Future<void> initCloudDBZone() async {
    final zoneConfig = AGConnectCloudDBZoneConfig(
      zoneName: "newZone97",
    );

    try {
      _zone = await AGConnectCloudDB.getInstance().openCloudDBZone(
        zoneConfig: zoneConfig,
      );
      print("Cloud DB zone opened successfully");
      Fluttertoast.showToast(
        msg: "Cloud DB zone opened successfully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
      
    } catch (e) {
      print("Error opening Cloud DB zone: $e");
      Fluttertoast.showToast(
        msg: "Zone problem: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  Future<void> saveDeviceIdToCloudDB(String id , String model) async {
    var entries = [
      {"id": id, "model": model},
      
    ];
    try {
      final int numOfWrittenObj = await _zone.executeUpsert(
        objectTypeName: "deviceInfo",
        entries: entries,
      );
      print("SUCCESS");
      Fluttertoast.showToast(
        msg: "Saved successfully $numOfWrittenObj",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
    } catch (e) {
      print("Error saving Device ID to Cloud DB: $e");
      Fluttertoast.showToast(
        msg: "Error saving Device ID to Cloud DB: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
    }
  }
}
