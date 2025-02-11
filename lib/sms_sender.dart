import 'sms_sender_platform_interface.dart';

class SmsSender {
  // Only applicable for Android (used to select SIM card if the device has dual SIM)
  static Future<List<Map<String, dynamic>>> getSimCards() {
    return SmsSenderPlatform.instance.getSimCards();
  }

  static Future<String> sendSms({
    required String phoneNumber,
    required String message,

    // Android only: Used to select SIM card
    int simSlot = 0,
  }) {
    return SmsSenderPlatform.instance.sendSms(phoneNumber, message, simSlot);
  }
}
