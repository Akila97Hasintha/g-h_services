import 'package:agconnect_clouddb/agconnect_clouddb.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LocationDetails extends StatefulWidget {
  final String id;

  const LocationDetails({Key? key, required this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LocationDetailsState();
}

class _LocationDetailsState extends State<LocationDetails> {
  late final AGConnectCloudDBZone zone;
  Future<void> initState() async {
    super.initState();
     openCloudDBZone();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Device ID"),),
      body:  Center(
      child: Text('Device Details  ${widget.id}'),)
    );
    
  }

  Future<void> openCloudDBZone() async {
    final zoneConfig = AGConnectCloudDBZoneConfig(
      zoneName: "newZone97",
    );

    try {
       zone = await AGConnectCloudDB.getInstance().openCloudDBZone(
        zoneConfig: zoneConfig,
      );
      print("Cloud DB zone opened successfully");
        Fluttertoast.showToast(
                  msg: " Cloud DB zone opened successfully ",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,);
                  await saveDeviceIdToCloudDB() ;
                  
    } catch (e) {
      // Handle error
      print("Error opening Cloud DB zone: $e");
      Fluttertoast.showToast(
                  msg: " zone problem ==== $e",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,);
    }
  }

   Future<void> saveDeviceIdToCloudDB() async {
          var entries = [{
          "id": "1234",
          "model": "Huawei",
          
          },
          {
          "id": "1245",
          "model": "Huaweijj",
          
          }];
    try {
        final int numOfWrittenObj = await zone.executeUpsert(
        objectTypeName: "deviceInfo",
        entries: [
          {
          "id": "1234",
          "model": "Huawei",
          
          },
          {
          "id": "1245",
          "model": "Huaweijj",
          
          }
        ],
        );
        print("SUCCESS");
        Fluttertoast.showToast(
              msg: "Svaaed success $numOfWrittenObj",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
            );
    } catch (e) {
      // Handle error
        print("Error saving Device ID to Cloud DB: $e");
        Fluttertoast.showToast(
          msg: "Error saving Device ID to Cloud DB: $e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
        );
    }
  }

}
