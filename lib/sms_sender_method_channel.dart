import 'package:flutter/services.dart';
import 'models/sim_card.dart';
import 'models/phone_number.dart';
import 'sms_sender_platform_interface.dart';

/// A method channel implementation of [SmsSenderPlatform].
class MethodChannelSmsSender extends SmsSenderPlatform {
  /// The method channel used to interact with the native platform.
  static const MethodChannel _channel = MethodChannel('sms_sender');

  @override
  Future<List<SimCard>> getSimCards() async {
    final List<dynamic> sims = await _channel.invokeMethod('getSimCards');
    return sims
        .map((e) => SimCard.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<List<PhoneNumber>> getPhoneNumbers() async {
    final List<dynamic> numbers =
        await _channel.invokeMethod('getPhoneNumbers');
    return numbers
        .map((e) => PhoneNumber.fromMap(Map<String, dynamic>.from(e)))
        .toList();
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
