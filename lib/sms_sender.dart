import 'sms_sender_platform_interface.dart';

/// A class for sending SMS messages, including support for background sending on Android.
class SmsSender {
  /// Retrieves a list of available SIM cards on the device.
  ///
  /// **Android only**: This function is useful for devices with dual SIM support.
  ///
  /// Returns a `Future` containing a list of SIM card details as `Map<String, dynamic>`.
  static Future<List<Map<String, dynamic>>> getSimCards() {
    return SmsSenderPlatform.instance.getSimCards();
  }

  /// Sends an SMS message to a specified phone number.
  ///
  /// - [phoneNumber]: The recipient's phone number.
  /// - [message]: The SMS content.
  /// - [simSlot]: *(Android only)* Specifies the SIM slot to use. Default is `0` (SIM 1).
  ///
  /// Returns a `Future<String>` with the status of the SMS sending process.
  static Future<String> sendSms({
    required String phoneNumber,
    required String message,
    int simSlot = 0, // Android only: Used to select SIM card
  }) {
    return SmsSenderPlatform.instance.sendSms(phoneNumber, message, simSlot);
  }
}
