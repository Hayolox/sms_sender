# sms\_sender

Flutter plugin to send SMS messages in the background and select a specific SIM card

## Features

* Send SMS messages in background (Android)
* Show SMS composer using `MFMessageComposeViewController` (iOS)
* Select a specific SIM card for sending SMS (Android only)
* List SIM cards info (Android only)
* Get phone numbers from SIM cards (Android only)
* Works on Android API 21+ (Lollipop) - minSdk 21 required

## Permissions

Add the following permissions to your Android project's **`AndroidManifest.xml`** (inside the `<manifest>` tag):

```xml
<!-- Required for sending SMS -->
<uses-permission android:name="android.permission.SEND_SMS"/>

<!-- Required for getSimCards() -->
<uses-permission android:name="android.permission.READ_PHONE_STATE"/>

<!-- Required for getPhoneNumbers() on Android 11+ -->
<uses-permission android:name="android.permission.READ_PHONE_NUMBERS"/>
```

> **Note:** You only need `READ_PHONE_NUMBERS` if you use `getPhoneNumbers()`. If you only use `getSimCards()` and `sendSms()`, you can skip it.

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

**Important:** Ensure your `android/app/build.gradle` has `minSdk` set to 21 or higher:

```gradle
android {
    defaultConfig {
        minSdk = 21  // Required
    }
}
```

## Usage

```dart
import 'package:sms_sender/sms_sender.dart';

void example() async {
  // Get SIM card info (requires READ_PHONE_STATE)
  List<SimCard> simCards = await SmsSender.getSimCards();
  print(simCards[0].carrierName);  // e.g., "Telkomsel"
  print(simCards[0].simSlot);      // e.g., 0

  // Get phone numbers (requires READ_PHONE_NUMBERS on Android 11+)
  List<PhoneNumber> phoneNumbers = await SmsSender.getPhoneNumbers();
  print(phoneNumbers[0].phoneNumber);  // e.g., "+628123456789"
  print(phoneNumbers[0].simSlot);      // e.g., 0

  // Send SMS (requires SEND_SMS)
  await SmsSender.sendSms(
    phoneNumber: "12345678",
    message: "Hello, this is a test SMS!",
    simSlot: simCards[0].simSlot,
  );
}
```

## Models

### SimCard

| Property | Type | Description |
|---|---|---|
| `carrierName` | `String` | Carrier name (e.g., "Telkomsel") |
| `iccId` | `String` | ICC ID of the SIM card |
| `simSlot` | `int` | SIM slot index (0-based) |

### PhoneNumber

| Property | Type | Description |
|---|---|---|
| `simSlot` | `int` | SIM slot index (0-based) |
| `phoneNumber` | `String` | Phone number (may be empty) |

> **Note:** This plugin can only be tested on a **real device** (not on an emulator).
> Phone number may be empty if the carrier does not store it on the SIM.
