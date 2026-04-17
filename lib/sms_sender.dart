import 'models/sim_card.dart';
import 'models/phone_number.dart';
import 'sms_sender_platform_interface.dart';

export 'models/models.dart';

/// A class for sending SMS messages, including support for background sending on Android.
class SmsSender {
  /// Retrieves a list of available SIM cards on the device.
  ///
  /// **Android only**: Returns SIM card details (carrier name, ICC ID, slot index).
  /// Requires `READ_PHONE_STATE` permission.
  static Future<List<SimCard>> getSimCards() {
    return SmsSenderPlatform.instance.getSimCards();
  }

  /// Retrieves phone numbers for each SIM slot.
  ///
  /// **Android only**: Requires `READ_PHONE_NUMBERS` permission on Android 11+.
  /// Phone number may be empty if the carrier does not store it on the SIM.
  static Future<List<PhoneNumber>> getPhoneNumbers() {
    return SmsSenderPlatform.instance.getPhoneNumbers();
  }

  /// Sends an SMS message to a specified phone number.
  ///
  /// - [phoneNumber]: The recipient's phone number.
  /// - [message]: The SMS content.
  /// - [simSlot]: *(Android only)* Specifies the SIM slot to use. Default is `0`.
  static Future<String> sendSms({
    required String phoneNumber,
    required String message,
    int simSlot = 0,
  }) {
    return SmsSenderPlatform.instance.sendSms(phoneNumber, message, simSlot);
  }
}
