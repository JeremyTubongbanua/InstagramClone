import '../widgets/profile_appbar.dart';
import '../widgets/profile_tabs.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfileDetailScreen extends StatelessWidget {
  final String profileHandle, profileName, imageUrl, description;
  final int followers, following, posts;

  const ProfileDetailScreen(this.profileHandle, this.profileName, this.imageUrl, this.description, this.followers, this.following, this.posts);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final MediaQueryData mqd = MediaQuery.of(context);
    final Size size = mqd.size;
    return Scaffold(
      appBar: ProfileAppBar(profileHandle),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: theme.backgroundColor,
          ),
          constraints: BoxConstraints(
            minHeight: size.height,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildImageContainer(imageUrl),
                  buildTextColumn('Followers', followers),
                  buildTextColumn('Following', following),
                  buildTextColumn('Posts', posts),
                ],
              ),
              buildDescriptionContainer(),
              ProfileTabs(),
            ],
          ),
        ),
      ),
    );
  }

  Container buildDescriptionContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 32.0,
        vertical: 24.0,
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            profileName.replaceAll('@', ''),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            description,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
            maxLines: 6,
          ),
          buildButtonRow(0.5),
        ],
      ),
    );
  }

  Row buildButtonRow(double buttonElevation) {
    return Row(
      children: [
        Expanded(
          flex: 16,
          child: ElevatedButton(
            onPressed: () {},
            child: const Text('Follow'),
            style: ElevatedButton.styleFrom(
              elevation: buttonElevation,
              minimumSize: Size(120, 30),
              primary: Colors.blue,
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(),
        ),
        Expanded(
          flex: 16,
          child: ElevatedButton(
            onPressed: () {},
            child: const Text(
              'Message',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            style: ElevatedButton.styleFrom(
              elevation: buttonElevation,
              minimumSize: Size(120, 30),
              primary: Colors.white,
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(),
        ),
        Expanded(
          flex: 4,
          child: ElevatedButton(
            onPressed: () {},
            child: const Text(
              'v',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            style: ElevatedButton.styleFrom(
              elevation: buttonElevation,
              primary: Colors.white,
              minimumSize: const Size.fromHeight(30),
            ),
          ),
        ),
      ],
    );
  }
}

Container buildImageContainer(String imageUrl) {
  return Container(
    width: 75,
    height: 75,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: Colors.black,
        width: 0.5,
      ),
      image: DecorationImage(
        fit: BoxFit.cover,
        image: NetworkImage(imageUrl),
      ),
    ),
  );
}

Column buildTextColumn(String title, int number) {
  return Column(
    children: [
      Text(
        NumberFormat('###,###').format(number).toString(),
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),
      ),
      Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
      ),
    ],
  );
}
