import 'package:flutter/material.dart';
import 'package:tiktok/screen/setting/settings/profile_screen.dart/profile_screen.dart';
import 'package:tiktok/utils/my_utils.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text('Settings'),),
      body: Column(
        children: [
          SizedBox(
            height: height(context)*0.1,
            width: width(context),
            child: ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
              },
             leading: const Icon(Icons.account_circle,size: 70,), 
             title: const Text('Fahriddin'),
             subtitle: const Text('Busy'),
             trailing: const Icon(Icons.qr_code),
            )),
            const Divider(color: Colors.black,),
          Expanded(
            child: ListView.builder(
              itemCount: 9,
              itemBuilder:(context, index) {
              return listTitleWidget(listSettingsIcon[index],listSettingsName[index],listSettingsDate[index]);
            },),
          ),
        ],
      ),
    );
  }
  listTitleWidget(icon,name,data) {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon),
      ),
      trailing: const Icon(Icons.edit),
      title: Text(
        name,
        style: const TextStyle(),
      ),
      subtitle: Text(
        data,
        style: const TextStyle(),
      ),
    );
  }
}

List listSettingsIcon = [
Icons.key_outlined,
Icons.lock,
Icons.run_circle,
Icons.chat,
Icons.notifications,
Icons.data_saver_off_sharp,
Icons.language,
Icons.help_outline_outlined,
Icons.person_add_sharp,
];

List listSettingsName = [
'Account',
'Privacy',
'Avatar',
'Chats',
'Notifications',
'Storage and Data',
'App Language',
'Help',
'Invite a friend'
];

List listSettingsDate = [
'Fahriddin',
'Busy',
'996550597759',
'Fahriddin',
'Busy',
'996550597759',
'Fahriddin',
'Busy',
''
];
  