import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/buttons_screen.dart';

class ProfileAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String profileHandle;

  const ProfileAppBar(this.profileHandle);

  @override
  Size get preferredSize {
    return Size.fromHeight(kToolbarHeight);
  }

  @override
  State<ProfileAppBar> createState() => _ProfileAppBarState();
}

class _ProfileAppBarState extends State<ProfileAppBar> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AppBar(
      backgroundColor: theme.backgroundColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        onPressed: () async {
          await Navigator.of(context).pushReplacementNamed(ButtonsScreen.id);
        },
      ),
      actions: const [
        Icon(Icons.more_horiz, color: Colors.black),
      ],
      title: Text(
        widget.profileHandle.contains('@') ? widget.profileHandle : '@${widget.profileHandle}',
        style: const TextStyle(color: Colors.black),
      ),
      centerTitle: true,
    );
  }
}
