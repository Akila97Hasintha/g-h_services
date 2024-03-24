
import 'dart:io';
import 'package:agconnect_clouddb/agconnect_clouddb.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_map_my/Home.dart';
import 'package:new_map_my/map/google_map.dart';
import 'package:new_map_my/service_utils.dart';
import 'package:new_map_my/storage/firebase_service.dart';
import 'package:new_map_my/storage/huawei_cloudDB.dart';
 


void main()  async {
  WidgetsFlutterBinding.ensureInitialized();

  
  
   if (await ServiceUtils.isGoogleServicesAvailable()) {
          FirebaseOptions firebaseOptions = const FirebaseOptions(
          apiKey: 'AIzaSyAUvLYesTJPJP-Q1Iw4OE71wYCXgQXpTZg',
          
          projectId: 'newappmy-47054',
          
          messagingSenderId: '992036650200',
          appId: '1:992036650200:android:4403dfd7f72e71067debad',
        );
            
        await Firebase.initializeApp(options:firebaseOptions);
            

     } else if (await ServiceUtils.isHuaweiServicesAvailable()) {

            await AGConnectCloudDB.getInstance().initialize();
            AGConnectCloudDB.getInstance().createObjectType();
      
    } 

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  late String id;
  late String model;
  CloudDBService huaweiDb = CloudDBService();
  FirebaseService firebaseDb = FirebaseService();

@override
  void initState() {
    
    super.initState();
    _initializeDeviceInfo();
    huaweiDb.initCloudDBZone();
    firebaseDb.initializeFirebase();
  }

  Future<void> _initializeDeviceInfo() async {
    try {
      Map<String, String?> deviceInfo = await _getDeviceInfo();
      id = deviceInfo['id'] ?? 'default_device_id';
      model = deviceInfo['model'] ?? 'unknown_model';
    } catch (e) {
      print('Error initializing device ID: $e');
      
      id = 'default_device_id';
      model = 'unknown_model';
    }
    if (mounted) {
      setState(() {});
      if (await ServiceUtils.isGoogleServicesAvailable()) {
      print("==========google firebase ===============");
      await firebaseDb.saveDeviceInfoToFirebase(id, model);
      
    } else if (await ServiceUtils.isHuaweiServicesAvailable()) {
      print("==========huawei cloud db===============");
      await huaweiDb.saveDeviceIdToCloudDB(id, model);
    } 
    }
  }

  @override
  Widget build(BuildContext context) {
   
    
    return const HomePage();
    
  }

   // get device Info
  Future<Map<String, String?>> _getDeviceInfo() async {
    var deviceInfo = DeviceInfoPlugin();
    Map<String, String?> info = {};

    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      info['id'] = iosDeviceInfo.identifierForVendor; // Unique on iOS
      info['model'] = iosDeviceInfo.model;
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      info['id'] = androidDeviceInfo.id; // Unique ID on Android
      info['model'] = androidDeviceInfo.model;
    }

    return info;
  }

}
