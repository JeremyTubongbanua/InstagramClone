# InstagramClone

This is my attempt at using the at platform in my instagram clone app. The at\_ packages that it uses are: `at_client_mobile` and `at_app_flutter`.

## Image

![Sample]('https://i.imgur.com/Edk2bGF.png')

## pubspec.yaml

Versions may be important

-   `at_client_mobile: ^3.0.22` (`at_commons` export is missing from `3.0.3`).
-   `at_app_flutter: ^5.0.0` (untested, but snackbar demo uses `^5.0.0` instead of `^5.0.0+1`)

```yaml
dependencies:
    flutter:
        sdk: flutter
    path_provider: ^2.0.10
    intl: ^0.17.0
    at_client_mobile: ^3.0.22
    at_app_flutter: ^5.0.0
```

## android/build.gradle

-   To rebuild the android folder, use `flutter create -a kotlin .`
-   Setting kotlin version to `1.5.32` may fix biometric storage version error.

```gradle
buildscript {
    ext.kotlin_version = '1.5.32'
}
```

## android/app/build.gradle

-   To rebuild the android folder, use `flutter create -a kotlin .`
-   Setting `minSdkVersion 23` may fix `at_onboarding_flutter` import errors. (`at_onboarding_flutter` is exported by `at_app_flutter`; using the package itself may pose errors, so best to use it through the `at_app_flutter` package).

```
android {
    compileSdkVersion flutter.compileSdkVersion

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId "com.example.instagram_clone"
        minSdkVersion 23
        targetSdkVersion flutter.targetSdkVersion
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
    }
}
```

## AtEnv

AtEnv is a class from `at_app_flutter`. It gives helpful methods and variables like:

```dart
// 1. Make .env file in root project folder and put values in it.
NAMESPACE=smoothalligator
API_KEY=477b-876u-bcez-c42z-6a3d

// 2. Call .load() in main()
try {
  await AtEnv.load();
} catch (err) {
  print("AtEnv error: $err");
}

// 3. Use the class
AtEnv.rootDomain // root.atsign.org
AtEnv.appNamespace // from NAMESPACE=smoothalligator in .env
AtEnv.rootEnvironment // used in the Onboarding widget
AtEnv.appApiKey // from .env
```

## AtClientPreference Example

```dart
// 1. Import at_client_mobile or at_client
import 'package:at_client_mobile/at_client_mobile.dart';

// 2. Instansiate AtClientPreference
AtClientPreference preference = AtClientPreference();

// 3. Set preferences
String path = (await getApplicationSupportDirectory()).path; // from path_provider package
preference.rootDomain = AtEnv.rootDomain; // root.atsign.org
preference.namespace = AtEnv.appNamespace; // from .env (see the AtEnv section of this README)
preference.commitLogPath = path; // support directory
preference.hiveStoragePath = path; // support directory
preference.isLocalStoreRequired = true;
```

## Onboarding Widget Example

Onboarding is the act of putting your at sign where the app "logs in to you."

```dart
// Simply instantiate the object where a "_show()" method will be called in the constructor (if you dig deep, you will see it).
// important to leave "atSign" param out
Onboarding(
  atClientPreference: preference, // AtClientPreference
  context: context, // BuildContext
  domain: AtEnv.rootDomain, // root.atsign.org
  rootEnvironment: AtEnv.rootEnvironment,
  appAPIKey: AtEnv.appApiKey, // API_KEY in .env - needed if user wants to make new @ signs within the app
  onboard: (atClientServiceMap, atSign) {
    _logger.info('Onboard complete with: $atSign');
  },
  onError: (err) {
    _logger.severe('Onboarding error: $err');
  },
  nextScreen: nextScreen, // Widget
);
```

## AtClientManager, AtClient, AtKey, AtValue Example

-   Uses `AtClientManager`, `AtClient`, from `at_client_mobile ^3.0.22`
-   Uses `AtKey` & `AtValue` from `at_commons` exported from `at_client_mobile ^3.0.22` (wasn't exported in `^3.0.3`).

```dart
Future<void> onPress(BuildContext context) async {
  // 1. Get AtClientManager instance
  AtClientManager atClientManager = AtClientManager.getInstance();
  // 2. Get AtClient instance
  AtClient atClient = atClientManager.atClient;
  print('Current @ sign: ${atClient.getCurrentAtSign()}');
  // 3. Make an AtKey
  AtKey atKey = AtKey();
  atKey.key = 'data';
  atKey.sharedWith = null;
  atKey.sharedBy = atClient.getCurrentAtSign();
  atKey.namespace = AtEnv.appNamespace;
  // 3.5. Make a Metadata
  Metadata metaData = Metadata();
  metaData.namespaceAware = true;
  metaData.isPublic = true;
  metaData.isEncrypted = true;
  atKey.metadata = metaData;
  // 4. Data you want to encrypt
  const String data = 'https://i.imgur.com/msVdDTo.png';
  // 5. AtClient.put
  bool success = await atClient.put(
    atKey,
    data,
  );
  print('Success: $success');
  // 6. AtClient.get
  AtValue atValue = await atClient.get(atKey);
  print('AtValue: ${atValue.value}');
  // 7. Do whatever you want with the data
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (ctx) => ProfileDetailScreen(
        atKey.sharedBy!,
        atKey.sharedBy!,
        atValue.value,
        'Spy X family pog',
        232,
        111,
        22,
      ),
    ),
  );
}
```

## AtSignLogger

From `at_utils/at_logger.dart`;

```dart
// 1. Import at_utils
import 'package:at_utils/at_logger.dart' show AtSignLogger;

// 2. Instansiate
AtSignLogger _logger = AtSignLogger(AtEnv.appNamespace);

// 3. Use
_logger.finer('...');
_logger.severe('...');

```
