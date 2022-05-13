import 'package:flutter/material.dart';

import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_app_flutter/at_app_flutter.dart';
import 'package:at_commons/at_commons.dart';

class EditProfileScreen extends StatefulWidget {
  static const String id = '/edit_profile';

  const EditProfileScreen();

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late int numFollowers, numFollowing, numPosts;
  late String imageUrl;
  late String atSign;
  late TextEditingController _followersController, _followingController, _postsController, _imageUrlController;

  @override
  void initState() {
    super.initState();
    numFollowers = 0;
    numFollowing = 0;
    numPosts = 0;
    imageUrl = 'empty';
    atSign = 'empty';
    _followersController = TextEditingController();
    _followingController = TextEditingController();
    _postsController = TextEditingController();
    _imageUrlController = TextEditingController();
  }

  Future<void> updateValues() async {
    final AtClientManager atClientManager = AtClientManager.getInstance();
    final AtClient atClient = atClientManager.atClient;

    final String atSign = atClient.getCurrentAtSign()!;

    final AtValue numFollowersAV = await atClient.get(AtKey()..key = 'followers');
    final AtValue numFollowingAV = await atClient.get(AtKey()..key = 'following');
    final AtValue numPostsAV = await atClient.get(AtKey()..key = 'posts');
    final AtValue imageUrlAV = await atClient.get(AtKey()..key = 'imageUrl');

    setState(() {
      this.atSign = atSign;
      this.numFollowers = int.parse(numFollowersAV.value);
      this.numFollowing = int.parse(numFollowingAV.value);
      this.numPosts = int.parse(numPostsAV.value);
      this.imageUrl = imageUrlAV.value;
    });
  }

  Future<void> submit() async {
    final AtClientManager atClientManager = AtClientManager.getInstance();
    final AtClient atClient = atClientManager.atClient;
    final String currentAtSign = atClient.getCurrentAtSign()!;

    AtKey followersAK = AtKey()
      ..key = 'followers'
      ..namespace = AtEnv.appNamespace
      ..sharedBy = currentAtSign;

    AtKey followingAK = AtKey()
      ..key = 'following'
      ..namespace = AtEnv.appNamespace
      ..sharedBy = currentAtSign;

    AtKey postsAK = AtKey()
      ..key = 'posts'
      ..namespace = AtEnv.appNamespace
      ..sharedBy = currentAtSign;

    AtKey imageUrlAK = AtKey()
      ..key = 'imageUrl'
      ..namespace = AtEnv.appNamespace
      ..sharedBy = currentAtSign;

    await atClient.put(followersAK, _followersController.text);
    await atClient.put(followingAK, _followingController.text);
    await atClient.put(postsAK, _postsController.text);
    await atClient.put(imageUrlAK, _imageUrlController.text);

    await updateValues();
    clearControllers();
    setState(() {});
  }

  void clearControllers() {
    _followersController.clear();
    _followingController.clear();
    _postsController.clear();
    _imageUrlController.clear();
  }

  Row buildRow(String name, dynamic value, TextEditingController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text('$name: $value'),
        SizedBox(
          width: 50,
          child: TextField(
            controller: controller,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Current @ Sign: $atSign'),
            buildRow('Followers', numFollowers, _followersController),
            buildRow('Following', numFollowing, _followingController),
            buildRow('Posts', numPosts, _postsController),
            buildRow('Image URL', imageUrl, _imageUrlController),
            ElevatedButton(
              onPressed: () async => await updateValues(),
              child: const Text('Reload'),
            ),
            ElevatedButton(
              onPressed: () async => await submit(),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
