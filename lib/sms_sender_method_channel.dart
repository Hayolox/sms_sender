import 'package:flutter/services.dart';
import 'sms_sender_platform_interface.dart';

class MethodChannelSmsSender extends SmsSenderPlatform {
  static const MethodChannel _channel = MethodChannel('sms_sender');

  @override
  Future<List<Map<String, dynamic>>> getSimCards() async {
    final List<dynamic> sims = await _channel.invokeMethod('getSimCards');
    return sims.map((e) => Map<String, dynamic>.from(e)).toList();
  }

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
