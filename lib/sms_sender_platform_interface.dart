import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'models/phone_number.dart';
import 'models/sim_card.dart';
import 'sms_sender_method_channel.dart';

/// The interface that defines platform-specific implementations of `SmsSender`.
abstract class SmsSenderPlatform extends PlatformInterface {
  /// Constructs a [SmsSenderPlatform].
  SmsSenderPlatform() : super(token: _token);

  static final Object _token = Object();

  static SmsSenderPlatform _instance = MethodChannelSmsSender();

  /// The default instance of [SmsSenderPlatform].
  static SmsSenderPlatform get instance => _instance;

  /// Sets a custom implementation of [SmsSenderPlatform].
  static set instance(SmsSenderPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Retrieves a list of available SIM cards on the device.
  Future<List<SimCard>> getSimCards() {
    throw UnimplementedError('getSimCards() has not been implemented.');
  }

  /// Retrieves phone numbers for each SIM slot.
  /// Requires `READ_PHONE_NUMBERS` permission on Android 11+.
  Future<List<PhoneNumber>> getPhoneNumbers() {
    throw UnimplementedError('getPhoneNumbers() has not been implemented.');
  }

  /// Sends an SMS message to the specified [phoneNumber].
  Future<String> sendSms(String phoneNumber, String message, int simSlot) {
    throw UnimplementedError('sendSms() has not been implemented.');
  }
}
