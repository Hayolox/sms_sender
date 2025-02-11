import 'package:flutter/services.dart';
import 'sms_sender_platform_interface.dart';

/// A method channel implementation of [SmsSenderPlatform].
///
/// This class communicates with the native platform using method channels.
class MethodChannelSmsSender extends SmsSenderPlatform {
  /// The method channel used to interact with the native platform.
  static const MethodChannel _channel = MethodChannel('sms_sender');

  /// Retrieves a list of available SIM cards on the device.
  ///
  /// This method is only supported on Android.
  @override
  Future<List<Map<String, dynamic>>> getSimCards() async {
    final List<dynamic> sims = await _channel.invokeMethod('getSimCards');
    return sims.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  /// Sends an SMS message to the specified [phoneNumber].
  ///
  /// - [phoneNumber]: The recipient's phone number.
  /// - [message]: The SMS message content.
  /// - [simSlot]: The SIM slot to use (only applicable for dual SIM devices on Android).
  ///
  /// Returns a [String] result from the native platform.
  @override
  Future<String> sendSms(
      String phoneNumber, String message, int simSlot) async {
    final String result = await _channel.invokeMethod('sendSms', {
      'phoneNumber': phoneNumber,
      'message': message,
      'simSlot': simSlot,
    });
    return result;
  }
}
