# sms\_sender

Flutter plugin to send SMS messages in the background and select a specific SIM card

## Features

* Send SMS messages in background (Android)
* Show SMS composer using `MFMessageComposeViewController` (iOS)
* Select a specific SIM card for sending SMS (Android only)
* List SIM cards (Android only)
* Works on Android API 19+ (KitKat)

## Permissions

Before using this plugin, add the following permissions to your Android project's **`AndroidManifest.xml`** (inside the `<manifest>` tag):

```xml
<uses-permission android:name="android.permission.SEND_SMS"/>
<uses-permission android:name="android.permission.READ_PHONE_STATE"/>
```

> **Note:** On Android 6.0+ you may also need to request these permissions at runtime.

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  sms_sender: latest_version
```

Or from GitHub:

```yaml
dependencies:
  sms_sender:
    git:
      url: https://github.com/Hayolox/sms_sender.git
```

Then run:

```sh
flutter pub get
```

## Usage

```dart
import 'package:sms_sender/sms_sender.dart';

void sendSMS() async {
  // Only applicable for Android (used to select SIM card if the device has dual SIM)
  List<Map<String, dynamic>> simCards = await SmsSender.getSimCards();

  await SmsSender.sendSms(
    phoneNumber: "12345678",
    message: "Hello, this is a test SMS!",
    simSlot: simCards[0]['simSlot'],
  );
}
```

> **Note:** This plugin can only be tested on a **real device** (not on an emulator).
