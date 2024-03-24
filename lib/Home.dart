import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:huawei_location/huawei_location.dart' as HuaweiLocation;
import 'package:location/location.dart' as GoogleLocation;
import 'package:new_map_my/location/google_location_service.dart';
import 'package:new_map_my/map/google_map.dart';
import 'package:new_map_my/location/huawei_location_services.dart';
import 'package:new_map_my/map/huawei_map.dart';
import 'package:new_map_my/service_utils.dart';
import 'package:new_map_my/storage/sqllite_db.dart';
import 'package:new_map_my/widget/RowContainer.dart';
import 'package:new_map_my/widget/custom_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_map_my/widget/custom_button.dart'; 
import 'package:connectivity_plus/connectivity_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}): super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController remarksController = TextEditingController();
  late File ? _selectedImage;
  int selectedContainerIndex = 0;
  String selectedActivityType = "Activity Type";
  late Widget _mapWidget = Container();
  late LatLng? currentLocationData = null ;
  late ConnectivityResult _connectivityResult;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final DatabaseHelper _helper = DatabaseHelper();
    
  List<String> ActivityTypes = ["Hork from home", "Client Visit"];

  @override
  void initState() {
    super.initState();
    _loadMap();
    getCurrentLocation();
    checkConnectivity();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _connectivityResult = result;
         if (_connectivityResult != ConnectivityResult.none) {
          showStatusSnackbar('Online');
          _sendPendingData();
        } else {
          showStatusSnackbar('Offline');
        }
         
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
  }
// online offline 
   Future<void> checkConnectivity() async {
    final connectivity = Connectivity();
    final result = await connectivity.checkConnectivity();
    setState(() {
      _connectivityResult = result;
       if (_connectivityResult != ConnectivityResult.none) {
        
        _sendPendingData();
      }
    });
  }

   void showStatusSnackbar(String status) {
    final snackBar = SnackBar(
      content: Text('App is currently $status'),
      duration: const Duration(seconds: 10),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _loadMap() async {
    Widget mapWidget = await _buildMap();
    setState(() {
      _mapWidget = mapWidget;
    });
  }

 
   
// show popup menu
  void _showPopupMenu(BuildContext context) async {
    
    String? newValue = await showMenu(
      context: context,
      
      position: const RelativeRect.fromLTRB(0,600, 0,0),
      items: ActivityTypes.map<PopupMenuEntry<String>>((String value) {
        return PopupMenuItem<String>(
          value: value,
          child:  Container(
          height: 40, 
          width:   MediaQuery.of(context).size.width - 30,   
          child: Center(child: Text(value)),
        ),
        );
      }).toList(),
      
    );
    if (newValue != null) {
    setState(() {
      selectedActivityType = newValue;
    });
  }
  }


  


  @override
  Widget build(BuildContext context) {
    
    return  Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
           const CustomAppBar(Icons.arrow_back_ios_outlined, Icons.notifications),
          Container(
            
            margin: const EdgeInsets.all(15),
            height: 280,
            decoration:  const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
               color: Colors.white,
                       
            ),
            // ignore: unnecessary_null_comparison
            child: _mapWidget != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: _mapWidget,
              )
            : const CircularProgressIndicator(),
            
            
          ),
          Container(
             margin: const EdgeInsets.all(15),
            height: 120,
            decoration:  const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
               color: Color.fromARGB(255, 223, 238, 250),
                        
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _pickImageFromCam,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration:   BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(15)),
                               border: Border.all(
                               color: const Color.fromARGB(255, 114, 113, 113), 
                               width: 1.5, 
                             ),
                              
                          
                            ),
                            child: const Center(child: Icon(Icons.camera_alt,color: Color.fromARGB(255, 117, 116, 116),size: 30,)),
                  ),
                ),
                const SizedBox(width: 10,),
        
                Container(
                  width: 150,
                  height: 90,
                  decoration:  const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
               
                        
            ),
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("General Shift",style: TextStyle(color:Colors.blue,fontWeight: FontWeight.w400)),
                const SizedBox(width: 10,),
                 RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: '12:56',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold,color:Colors.blue,),
                      ),
                      WidgetSpan(
                        child: Transform.translate(
                          offset: const Offset(0.0, -8.0), 
                          child: const Text(
                            'PM',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color:Colors.blue,),
                          ),
                        ),
                      ),
                    ],
                  ),
              ),
              const SizedBox(width: 20,),
                const Text("Saturday, 24 FEB 2024",style: TextStyle(color:Colors.blue,fontWeight: FontWeight.w400)),
              ],
            ),
                ),
                
                
              ],
            ),
          ),
          
           Center(
            child: SizedBox(
             width: double.infinity,
              child: RowContainer(
                selectedContainerIndex: selectedContainerIndex,
              onContainerSelected: (index) {
                setState(() {
                  selectedContainerIndex = index;
                });
              },
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              _showPopupMenu(context);
            },
            child: Container(
              margin: const EdgeInsets.all(15),
              
                     height: 40,
                      decoration:   BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(15)),
                                 border: Border.all(
                                 color: const Color.fromARGB(255, 114, 113, 113), 
                                 width: 1.5, 
                               ),
                                
                            
                              ),
                              child:  Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  
                                  children: [
                                  
                                     Text(selectedActivityType,style:TextStyle(color: Colors.grey,fontWeight: FontWeight.w800)),
                                  
                                   Icon(Icons.arrow_drop_down),
                                ]),
                              ),
            ),
          ),
        
          Container(
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(5),
                   height: 80,
                    decoration:   BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(15)),
                               border: Border.all(
                               color: const Color.fromARGB(255, 114, 113, 113), 
                               width: 1.5, 
                             ),
                              
                          
                            ),
                            child:  Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              
                              children: [
                              
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: TextField(
                                    controller:remarksController,
        
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Remarks',
                                      hintStyle: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
          ),
        
           CustomButton(
                      text:"SUBMIT", 
                      
                      onPressed: (){
                        print("click ======== submit");
                          _submitForm();
                          
                      },
                      leftColor: Color.fromARGB(255, 247, 166, 46),
                      rightColor: Color.fromARGB(255, 247, 88, 26),)
        
          ],
          
        ),
      ),
    );
  }

  // Build map
    Future<Widget> _buildMap() async {
    if (await ServiceUtils.isGoogleServicesAvailable()) {
      print("==========google available===============");
      return const SizedBox.expand(child: MapGoogle());
    } else if (await ServiceUtils.isHuaweiServicesAvailable()) {
      print("==========huawei available===============");
      return const SizedBox.expand(child: MapHuawei());
    } else {
      return const Text("No available service");
    }
  }

// pick image 
  Future _pickImageFromCam() async {
    final returnImage =  await ImagePicker().pickImage(source: ImageSource.camera);

    if(returnImage == null) return;

    setState(() {
      _selectedImage = File(returnImage.path);
    });
  }



   // get Current Location
  getCurrentLocation() async {
     if (await ServiceUtils.isGoogleServicesAvailable()) {
      print("==========google available===============");
      try{
        GoogleLocation.LocationData? location = await LocationServiceGoogle().getCurrentLocation();
        currentLocationData = LatLng(location!.latitude!, location.longitude!);
      }catch(e){
         Fluttertoast.showToast(
                  msg: " location: $e",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,);
      }
      
    } else if (await ServiceUtils.isHuaweiServicesAvailable()) {
      print("==========huawei available===============");
      try{
        HuaweiLocation.Location? location = await LocationServiceHuawei().getCurrentLocation();
        currentLocationData = LatLng(location!.latitude!, location.longitude!);
          
      }catch(e){
          Fluttertoast.showToast(
                  msg: " location: $e",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,);
      }
       
       
      
    } else {
      return const Text("No available service");
    }
     setState(() {});
  }

    Future<void> _sendPendingData() async {
    final List<Map<String, dynamic>> pendingData = await DatabaseHelper.getFormData();
    if (pendingData.isNotEmpty) {
      // Show pending data in toast message
      Fluttertoast.showToast(
        msg: "Pending data: $pendingData",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
      // Optionally, you can send pending data to the server here
    }
    
  }


  // submit form
   Future<void> _submitForm() async {
    
    Map<String, dynamic> formData = {
      
      'activityType': ActivityTypes[selectedContainerIndex],
      'imagePath': _selectedImage?.path, 
    'remarks': remarksController.text, 
    "location": currentLocationData != null
        ? {
            'latitude': currentLocationData?.latitude,
            'longitude': currentLocationData?.longitude,
          }
        : null,
      
    };

     if (_connectivityResult == ConnectivityResult.none) {
      // If offline, save the JSON data to local database
      //DatabaseHelper.deleteTable("offline_request");
      DatabaseHelper.insertFormData(formData);
      Fluttertoast.showToast(
                      msg: " offline :",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,);

       
      
    } else {
      // If online, directly send the JSON data to API
      String jsonData = json.encode(formData);
      Fluttertoast.showToast(
                      msg: " online == : ",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,);
    }

    String jsonData = json.encode(formData);

   Fluttertoast.showToast(
                  msg: " location: $jsonData",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,);
    print(jsonData);
    

  }

}