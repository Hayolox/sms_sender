# sms_sender

Flutter plugin to send SMS messages in the background and select a specific SIM card

## Features

- Send SMS messages background (Android)
- Show SMS composer using MFMessageComposeViewController (IOS)
- Select a specific SIM card for sending SMS (Android only)
- List SIM card (Android only)
- Works on Android API 19+ (KitKat)

## Permissions
No setting permissions


## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  sms_sender: latest_version
```
or 

```yaml
dependencies:
  sms_sender: 
    git:
      url: https://github.com/Hayolox/sms_sender_background.git
```

Then run:

```sh
flutter pub get
```

## Usage

```dart
import 'package:sms_sender/sms_sender.dart';

void sendSMS() async {
  
  await SmsSender.sendSms(
    phoneNumber: "12345678",
    message: "Hello, this is a test SMS!",
    simSlot: 0, // Android only: Used to select SIM card
  );

  // Only applicable for Android (used to select SIM card if the device has dual SIM)
  await SmsSender.getSimCards();
}
```

