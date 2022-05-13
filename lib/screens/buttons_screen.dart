import 'package:flutter/material.dart';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_app_flutter/at_app_flutter.dart';
import 'package:at_commons/at_commons.dart';
import 'package:instagram_clone/screens/edit_profile_screen.dart';
import 'package:instagram_clone/screens/profile_detail_screen.dart';

class ButtonsScreen extends StatefulWidget {
  static const String id = '/buttons';

  const ButtonsScreen();

  @override
  State<ButtonsScreen> createState() => _ButtonsScreenState();
}

class _ButtonsScreenState extends State<ButtonsScreen> {
  @override
  void initState() {
    super.initState();
  }

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

  Future<void> goToEditProfile() async {
    await Navigator.of(context).pushReplacementNamed(EditProfileScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Instagram Clone'),
              onPressed: () => goToInstagramClone(context),
            ),
            ElevatedButton(
              child: const Text('Edit Profile'),
              onPressed: () => goToEditProfile(),
            ),
          ],
        ),
      ),
    );
  }
}
