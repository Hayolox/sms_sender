package com.example.sms_sender

import android.Manifest
import android.app.Activity
import android.content.pm.PackageManager
import android.telephony.SubscriptionManager
import android.telephony.SmsManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class SmsSenderPlugin : FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private var pendingResult: MethodChannel.Result? = null
    private var pendingMethod: String? = null
    private var pendingArgs: Map<String, Any>? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "sms_sender")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getSimCards" -> requestPermissionAndProceed(Manifest.permission.READ_PHONE_STATE, call.method, result)
            "sendSms" -> {
                val phoneNumber = call.argument<String>("phoneNumber")
                val message = call.argument<String>("message")
                val simSlot = call.argument<Int>("simSlot") ?: 0

                if (!phoneNumber.isNullOrBlank() && !message.isNullOrBlank()) {
                    requestPermissionAndProceed(
                        Manifest.permission.SEND_SMS,
                        call.method,
                        result,
                        mapOf("phoneNumber" to phoneNumber, "message" to message, "simSlot" to simSlot)
                    )
                } else {
                    result.error("INVALID_ARGUMENTS", "Phone number or message is missing", null)
                }
            }
            else -> result.notImplemented()
        }
    }

    private fun requestPermissionAndProceed(permission: String, method: String, result: MethodChannel.Result, args: Map<String, Any>? = null) {
        activity?.let {
            if (ContextCompat.checkSelfPermission(it, permission) == PackageManager.PERMISSION_GRANTED) {
                proceedWithMethod(method, result, args)
            } else {
                pendingResult = result
                pendingMethod = method
                pendingArgs = args
                ActivityCompat.requestPermissions(it, arrayOf(permission), 1)
            }
        } ?: result.error("ACTIVITY_NULL", "Activity is not attached", null)
    }

    private fun proceedWithMethod(method: String, result: MethodChannel.Result, args: Map<String, Any>? = null) {
        when (method) {
            "getSimCards" -> getSimCards(result)
            "sendSms" -> {
                val phoneNumber = args?.get("phoneNumber") as String
                val message = args["message"] as String
                val simSlot = args["simSlot"] as Int
                sendSms(phoneNumber, message, simSlot, result)
            }
        }
    }

    private fun getSimCards(result: MethodChannel.Result) {
        val subscriptionManager = activity?.getSystemService(SubscriptionManager::class.java)
        if (subscriptionManager == null) {
            result.error("UNAVAILABLE", "Could not access SubscriptionManager", null)
            return
        }

        val subscriptionList = subscriptionManager.activeSubscriptionInfoList
        if (subscriptionList.isNullOrEmpty()) {
            result.error("NO_SIM", "No active SIM cards found", null)
            return
        }

        val simCards = subscriptionList.mapIndexed { index, info ->
            mapOf(
                "carrierName" to (info.carrierName?.toString() ?: "Unknown"),
                "iccId" to (info.iccId ?: "Unknown"),
                "simSlot" to info.simSlotIndex
            )
        }

        result.success(simCards)
    }

    private fun sendSms(phoneNumber: String, message: String, simSlot: Int, result: MethodChannel.Result) {
        try {
            val subscriptionManager = activity?.getSystemService(SubscriptionManager::class.java)
            if (subscriptionManager == null) {
                result.error("UNAVAILABLE", "Could not access SubscriptionManager", null)
                return
            }

            val subscriptionList = subscriptionManager.activeSubscriptionInfoList
            if (subscriptionList.isNullOrEmpty()) {
                result.error("NO_SIM", "No active SIM cards found", null)
                return
            }

            val subscriptionInfo = subscriptionList.find { it.simSlotIndex == simSlot }
            if (subscriptionInfo == null) {
                result.error("INVALID_SIM_SLOT", "SIM slot $simSlot not available", null)
                return
            }

            val subscriptionId = subscriptionInfo.subscriptionId
            val smsManager = SmsManager.getSmsManagerForSubscriptionId(subscriptionId)
            smsManager.sendTextMessage(phoneNumber, null, message, null, null)

            result.success("SMS sent successfully via SIM $simSlot!")
        } catch (e: Exception) {
            result.error("FAILED", "Failed to send SMS: ${e.message}", null)
        }
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addRequestPermissionsResultListener { requestCode, _, grantResults ->
            if (requestCode == 1) {
                if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    pendingMethod?.let {
                        proceedWithMethod(it, pendingResult!!, pendingArgs)
                    }
                } else {
                    pendingResult?.error("PERMISSION_DENIED", "User denied permission", null)
                }
            }
            pendingMethod = null
            pendingResult = null
            pendingArgs = null
            true
        }
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }
}
