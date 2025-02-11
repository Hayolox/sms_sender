import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'sms_sender_method_channel.dart';

/// The interface that defines platform-specific implementations of `SmsSender`.
///
/// This class should not be instantiated directly. Instead, use [SmsSenderPlatform.instance]
/// to interact with the platform-specific implementation.
abstract class SmsSenderPlatform extends PlatformInterface {
  /// Constructs a [SmsSenderPlatform].
  SmsSenderPlatform() : super(token: _token);

  static final Object _token = Object();

  static SmsSenderPlatform _instance = MethodChannelSmsSender();

  /// The default instance of [SmsSenderPlatform] that will be used.
  ///
  /// Defaults to [MethodChannelSmsSender].
  static SmsSenderPlatform get instance => _instance;

  /// Sets a custom implementation of [SmsSenderPlatform].
  ///
  /// This can be used for testing or alternative platform-specific implementations.
  static set instance(SmsSenderPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Retrieves a list of available SIM cards on the device.
  ///
  /// This method must be implemented by platform-specific classes.
  ///
  /// Throws [UnimplementedError] if not overridden.
  Future<List<Map<String, dynamic>>> getSimCards() {
    throw UnimplementedError('getSimCards() has not been implemented.');
  }

  /// Sends an SMS message to the specified [phoneNumber].
  ///
  /// - [phoneNumber]: The recipient's phone number.
  /// - [message]: The SMS message content.
  /// - [simSlot]: The SIM slot to use (only applicable for dual SIM devices on Android).
  ///
  /// Throws [UnimplementedError] if not overridden.
  Future<String> sendSms(String phoneNumber, String message, int simSlot) {
    throw UnimplementedError('sendSms() has not been implemented.');
  }
}
