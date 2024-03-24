package com.example.new_map_my

import android.os.Bundle
import com.google.android.gms.common.ConnectionResult
import com.google.android.gms.common.GoogleApiAvailability
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import com.huawei.hms.api.HuaweiApiAvailability

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.new_map_my/service_utils"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "isGoogleServicesAvailable" -> result.success(checkGoogleServices())
                    "isHuaweiServicesAvailable" -> result.success(checkHuaweiServices())
                    else -> result.notImplemented()
                }
            }
    }

    private fun checkGoogleServices(): Boolean {
        val apiAvailability = GoogleApiAvailability.getInstance()
        val resultCode = apiAvailability.isGooglePlayServicesAvailable(this)
        return resultCode == ConnectionResult.SUCCESS
    }

    private fun checkHuaweiServices(): Boolean {
        val apiAvailability = HuaweiApiAvailability.getInstance()
        val resultCode = apiAvailability.isHuaweiMobileServicesAvailable(this)
        return resultCode == com.huawei.hms.api.ConnectionResult.SUCCESS
    }
}
