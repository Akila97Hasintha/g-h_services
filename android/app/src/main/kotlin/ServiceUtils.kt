package com.example.new_map_my

import android.app.Activity
import com.google.android.gms.common.ConnectionResult
import com.google.android.gms.common.GoogleApiAvailability
import com.huawei.hms.api.HuaweiApiAvailability

object ServiceUtils {

    private var activity: Activity? = null

    fun init(activity: Activity) {
        ServiceUtils.activity = activity
    }

    fun isGoogleServicesAvailable(): Boolean {
        val currentActivity = activity
        return currentActivity != null && checkGooglePlayServices(currentActivity)
    }

    private fun checkGooglePlayServices(activity: Activity): Boolean {
        val apiAvailability = GoogleApiAvailability.getInstance()
        val resultCode = apiAvailability.isGooglePlayServicesAvailable(activity)
        return resultCode == ConnectionResult.SUCCESS
    }

    fun isHuaweiServicesAvailable(): Boolean {
        val currentActivity = activity
        return currentActivity != null && checkHuaweiServices(currentActivity)
    }

    private fun checkHuaweiServices(activity: Activity): Boolean {
        val apiAvailability = HuaweiApiAvailability.getInstance()
        val resultCode = apiAvailability.isHuaweiMobileServicesAvailable(activity)
        return resultCode == com.huawei.hms.api.ConnectionResult.SUCCESS
    }
}
