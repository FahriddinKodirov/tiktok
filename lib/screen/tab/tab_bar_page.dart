import 'package:flutter/material.dart';
import 'package:tiktok/screen/setting/linked_devices/linked_devices_screen.dart';
import 'package:tiktok/screen/setting/new_broadcast/new_broadcast_screen.dart';
import 'package:tiktok/screen/setting/new_group/new_group_screen.dart';
import 'package:tiktok/screen/setting/settings/settings_screen.dart';
import 'package:tiktok/screen/setting/starred_messages/starred_messages_screen.dart';

class Homescreen extends StatefulWidget {
 const Homescreen({Key? key}) : super(key: key);

  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen>
    with SingleTickerProviderStateMixin {

  TabController? _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 4, vsync: this, initialIndex: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Whatsapp"),
        actions: [
          IconButton(icon: const Icon(Icons.photo_camera_outlined), onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_)=>  Container()));
          }),
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          PopupMenuButton(
            onSelected: (value) {
                Navigator.push(context, MaterialPageRoute(builder: (_) => value));
              },

            itemBuilder: (BuildContext contesxt) {
              return [
                 const PopupMenuItem(
                  value: NewGroupScreen(),
                  child: Text("New group"),
                ),
                const PopupMenuItem(
                  value: NewBroadcastScreen(),
                  child:  Text("New broadcast"),
                ),
                 const PopupMenuItem(
                  value: LinkedDevicesScreen(),
                  child: Text("Linked devices"),
                ),
                 const PopupMenuItem(
                  value: StarredMessagesScreen(),
                  child: Text("Starred messages"),
                ),
                const PopupMenuItem(
                  value: SettingsScreen(),
                  child:  Text("Settings"),
                ),
              ];
            },
          )
        ],
        bottom: TabBar(
          controller: _controller,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(
              icon: Icon(Icons.groups_2_rounded),
            ),
            Tab(
              text: "CHATS",
            ),
            Tab(
              text: "STATUS",
            ),
            Tab(
              text: "CALLS",
            )
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          Container(),
          Container(),
          Text("STATUS"),
          Text("Calls"),
        ],
      ),
    );
  }
}