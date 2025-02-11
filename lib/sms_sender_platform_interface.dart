import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'sms_sender_method_channel.dart';

abstract class SmsSenderPlatform extends PlatformInterface {
  SmsSenderPlatform() : super(token: _token);

  static final Object _token = Object();

  static SmsSenderPlatform _instance = MethodChannelSmsSender();

  static SmsSenderPlatform get instance => _instance;

  static set instance(SmsSenderPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<List<Map<String, dynamic>>> getSimCards() {
    throw UnimplementedError('getSimCards() has not been implemented.');
  }

  Future<String> sendSms(String phoneNumber, String message, int simSlot) {
    throw UnimplementedError('sendSms() has not been implemented.');
  }
}
