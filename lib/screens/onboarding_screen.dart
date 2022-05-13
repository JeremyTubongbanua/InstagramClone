import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/buttons_screen.dart';

import 'package:path_provider/path_provider.dart';

import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_app_flutter/at_app_flutter.dart';
import 'package:at_onboarding_flutter/at_onboarding_flutter.dart' show Onboarding;
import 'package:at_utils/at_logger.dart' show AtSignLogger;

class OnboardingScreen extends StatefulWidget {
  static const String id = '/';

  const OnboardingScreen();

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late AtSignLogger _logger;

  @override
  void initState() {
    super.initState();
    _logger = AtSignLogger(AtEnv.appNamespace);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Onboard with your @ sign:'),
            ElevatedButton.icon(
              onPressed: () async {
                await onboard(context);
              },
              icon: Icon(Icons.thumb_up_sharp),
              label: Text('Let\'s Go!'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onboard(BuildContext ctx) async {
    String path = (await getApplicationSupportDirectory()).path;
    AtClientPreference preference = AtClientPreference();
    preference.rootDomain = AtEnv.rootDomain;
    preference.namespace = AtEnv.appNamespace;
    preference.commitLogPath = path;
    preference.hiveStoragePath = path;
    preference.isLocalStoreRequired = true;

    // final Widget nextScreen = ProfileDetailScreen(atSign, atSign, 'https://upload.wikimedia.org/wikipedia/en/5/53/Spy_x_Family_key_visual.jpg', 'Spy X Family best anime', 232, 232, 232);

    final Widget nextScreen = ButtonsScreen();

    // important to leave "atSign" param out
    Onboarding(
      atClientPreference: preference,
      context: context,
      domain: AtEnv.rootDomain,
      rootEnvironment: AtEnv.rootEnvironment,
      appAPIKey: AtEnv.appApiKey,
      onboard: (atClientServiceMap, atSign) {
        _logger.info('Onboard complete with: $atSign');
      },
      onError: (err) {
        _logger.severe('Onboarding error: $err');
      },
      nextScreen: nextScreen,
    );
  }
}
