import Flutter
import UIKit
import MessageUI

public class SmsSenderPlugin: NSObject, FlutterPlugin, MFMessageComposeViewControllerDelegate {
    private var flutterResult: FlutterResult?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "sms_sender", binaryMessenger: registrar.messenger())
        let instance = SmsSenderPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "sendSms":
            guard let args = call.arguments as? [String: Any],
                  let phoneNumber = args["phoneNumber"] as? String,
                  let message = args["message"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
                return
            }
            sendSms(phoneNumber: phoneNumber, message: message, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func sendSms(phoneNumber: String, message: String, result: @escaping FlutterResult) {
        if MFMessageComposeViewController.canSendText() {
            let composeVC = MFMessageComposeViewController()
            composeVC.messageComposeDelegate = self
            composeVC.recipients = [phoneNumber]
            composeVC.body = message

           
            flutterResult = result

            if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
                rootViewController.present(composeVC, animated: true, completion: nil)
            } else {
                result(FlutterError(code: "FAILED", message: "Unable to present SMS composer", details: nil))
            }
        } else {
            result(FlutterError(code: "FAILED", message: "SMS not supported", details: nil))
        }
    }

    public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true) {
            if let flutterResult = self.flutterResult {
                switch result {
                case .sent:
                    flutterResult("SMS sent successfully!")
                case .cancelled:
                    flutterResult(FlutterError(code: "CANCELLED", message: "SMS was cancelled", details: nil))
                case .failed:
                    flutterResult(FlutterError(code: "FAILED", message: "Failed to send SMS", details: nil))
                @unknown default:
                    flutterResult(FlutterError(code: "UNKNOWN", message: "Unknown error occurred", details: nil))
                }
                self.flutterResult = nil // Reset result setelah digunakan
            }
        }
    }
}
