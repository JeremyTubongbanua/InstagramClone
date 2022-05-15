# InstagramClone

This is my attempt at using the at platform in my instagram clone app. The at\_ packages that it uses are: `at_client_mobile` and `at_app_flutter`.

## Images

![instagram clone app image](https://i.imgur.com/Edk2bGF.png) \
![Edit profile screen](https://i.imgur.com/rupqIMO.png)

## pubspec.yaml

At\_ packages versions may be important.

-   `path_provider: ^2.0.10`
-   `intl: ^0.17.0`
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

or

```
defaultConfig {
  compileSdkVersion 29
  minSdkVersion 24
  targetSdkVersion 29
}
```

## AndroidManifest.xml

```
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.USE_FULL_SCREEN_INTENT" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-feature android:name="android.hardware.camera" />
<uses-feature android:name="android.hardware.camera.autofocus" />
<uses-feature android:name="android.hardware.camera.flash" />
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

AtClientPreference will be needed by the Onboarding widget and the AtClientManager.

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

-   Ran into problems when using the `at_onboarding_flutter` package from `pub.dev`. So instead, `at_app_flutter` was used since it was exported in there.
-   Be sure to check both the `android/build.gradle` and `android/app/build.gradle`changes above if you're running into errors when trying to use this widget.

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
Future<void> goToInstagramClone(BuildContext context) async {
  // 1. Get AtClientManager instance
  AtClientManager atClientManager = AtClientManager.getInstance();

  // 2. Get AtClient instance
  AtClient atClient = atClientManager.atClient;
  // unnecessary, but you can get the current at sign
  final String atSign = atClient.getCurrentAtSign()!;
  print('Current @ sign: $atSign');

  // 3. Make AtKey instances
  AtKey followersAK = AtKey();
  followersAK.key = 'followers';
  // syntax same as above.
  AtKey followingAK = AtKey()..key = 'following';
  AtKey postsAK = AtKey()..key = 'posts';
  AtKey imageUrlAK = AtKey()..key = 'imageUrl';

  // 3.5. Make a Metadata (optional)
  Metadata metaData = Metadata();
  metaData.namespaceAware = true;
  metaData.isPublic = true;
  metaData.isEncrypted = true;
  // followersAK.metadata = metaData; uncommnet this if u want to use meta data in ur AtKey

  // 4. Data you want to encrypt
  const String data = 'https://i.imgur.com/msVdDTo.png';

  // 5. AtClient.put
  bool success = await atClient.put(imageUrlAK, data);
  print('Success: $success');

  // 6. AtClient.get
  AtValue followersAV = await atClient.get(followersAK);
  print('AtValue: ${followersAV.value}');
  AtValue followingAV = await atClient.get(followingAK);
  AtValue postsAV = await atClient.get(postsAK);
  AtValue imageUrlAV = await atClient.get(imageUrlAK);

  // 7. Do whatever you want with the data
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (ctx) => ProfileDetailScreen(
        atSign, // String profileHandle
        atSign, // String profileName
        imageUrlAV.value, // String imageUrl
        'Spy X family pog', // String description
        int.parse(followersAV.value), // int followers
        int.parse(followingAV.value), // int following
        int.parse(postsAV.value), // int posts
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
