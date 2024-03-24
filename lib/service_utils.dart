import 'package:flutter/services.dart';

class ServiceUtils {
  static const MethodChannel _channel =
      MethodChannel('com.example.new_map_my/service_utils');

  static Future<bool> isGoogleServicesAvailable() async {
    return await _channel.invokeMethod('isGoogleServicesAvailable');
  }

  static Future<bool> isHuaweiServicesAvailable() async {
    return await _channel.invokeMethod('isHuaweiServicesAvailable');
   
  }
}
