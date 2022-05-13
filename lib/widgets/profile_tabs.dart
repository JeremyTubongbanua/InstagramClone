import 'package:flutter/material.dart';

class ProfileTabs extends StatefulWidget {
  const ProfileTabs();

  @override
  State<ProfileTabs> createState() => _ProfileTabsState();
}

class _ProfileTabsState extends State<ProfileTabs> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        Container(
          height: 30,
          decoration: BoxDecoration(color: theme.backgroundColor),
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.black,
            tabs: <Tab>[
              Tab(icon: Icon(Icons.grid_3x3, color: Colors.black)),
              Tab(icon: Icon(Icons.abc, color: Colors.black)),
            ],
          ),
        ),
        Container(
          height: 500,
          child: TabBarView(
            controller: _tabController,
            children: [
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                itemBuilder: (context, itemCount) {
                  return Container();
                },
              ),
              Container(
                decoration: BoxDecoration(color: Colors.red),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
