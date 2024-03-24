import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseService {
  late FirebaseFirestore _firestore;

  Future<void> initializeFirebase() async {
    try {

      await Firebase.initializeApp();
      _firestore = FirebaseFirestore.instance;

      print("Firebase initialized successfully");
      
      Fluttertoast.showToast(
        msg: "Firebase initialized successfully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );

    } catch (e) {
      print("Error initializing Firebase: $e");
      Fluttertoast.showToast(
        msg: "Firebase initialization problem: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  Future<void> saveDeviceInfoToFirebase(String id, String model) async {
    try {
       var querySnapshot = await _firestore
        .collection('deviceInfo')
        .where('id', isEqualTo: id)
        .get();

      if(querySnapshot.docs.isEmpty){
      await _firestore.collection('deviceInfo').add({
        'id': id,
        'model': model,
      });

      print("DeviceInfo saved to Firebase successfully");

      Fluttertoast.showToast(
        msg: "DeviceInfo saved to Firebase successfully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );

      }else{
        print("DeviceInfo with ID $id already exists in Firebase");
      }

    } catch (e) {

      print("Error saving DeviceInfo to Firebase: $e");

      Fluttertoast.showToast(
        msg: "Error saving DeviceInfo to Firebase: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );

    }
  }
}
