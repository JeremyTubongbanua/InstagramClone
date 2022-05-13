import 'package:flutter/material.dart';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_app_flutter/at_app_flutter.dart';
import 'package:at_commons/at_commons.dart';
import 'package:instagram_clone/screens/profile_detail_screen.dart';

class DebugScreen extends StatefulWidget {
  static const String id = '/debugscreen';

  const DebugScreen();

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  @override
  void initState() {
    super.initState();
  }

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

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        child: ElevatedButton(
          child: Text('Go'),
          onPressed: () => onPress(context),
        ),
      ),
    );
  }
}
