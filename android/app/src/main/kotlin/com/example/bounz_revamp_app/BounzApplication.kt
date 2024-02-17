package com.vernost.BounzAppUAT //"com.vernost.BounzApp"

import com.moengage.core.LogLevel
import com.moengage.core.MoEngage
import com.moengage.core.config.FcmConfig
import com.moengage.core.config.NotificationConfig
import com.moengage.core.config.PushKitConfig
import com.moengage.core.model.SdkState
import com.moengage.flutter.MoEInitializer
import com.moengage.pushbase.MoEPushHelper
import com.moengage.core.*
import com.moengage.core.config.LogConfig
import io.flutter.app.FlutterApplication

class BounzApplication : FlutterApplication() {
    override fun onCreate() {
        super.onCreate()
        val moEngage: MoEngage.Builder = MoEngage.Builder(this, "668EZ1ENJ3R8N6YSZNAGIQP0")
            .configureNotificationMetaData(NotificationConfig(
                R.drawable.ic_launcher,
                R.drawable.ic_launcher,
                notificationColor = -1,
                isMultipleNotificationInDrawerEnabled = true,
                isBuildingBackStackEnabled = true,
                isLargeIconDisplayEnabled = true
            ))
            // .configureLogs(LogConfig(LogLevel.VERBOSE, true))
            .setDataCenter(DataCenter.DATA_CENTER_4)
            .configureFcm(FcmConfig(true))
//        MoEngage.initialise(moEngage)
        MoEInitializer.initialiseDefaultInstance(applicationContext, moEngage, SdkState.ENABLED)
        MoEPushHelper.getInstance().registerMessageListener(CustomPushListener())
    }
}