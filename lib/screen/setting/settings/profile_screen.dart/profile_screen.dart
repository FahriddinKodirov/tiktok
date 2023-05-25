import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiktok/utils/my_utils.dart';
import 'package:tiktok/view_model/auth_view_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FirebaseAuth? auth;

  List listDate = [
'Fahriddin',
'Busy',
FirebaseAuth.instance.currentUser!.phoneNumber.toString()
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Consumer<AuthViewModel>(
        builder: (context, value, child) {
          return Column(
          children: [
            Center(
                child: Icon(
              Icons.account_circle_rounded,
              size: height(context) * 0.32,
            )),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return listTitleWidget(listIcon[index],listName[index],listDate[index]);
                },
              ),
            ),
          ],
        );
        },
      
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
        style: const TextStyle(fontSize: 16,color: Colors.black54),
      ),
      subtitle: Text(
        data,
        style: const TextStyle(fontSize: 20,color: Colors.black),
      ),
    );
  }
}

List listIcon = [
Icons.person,
Icons.abc,
Icons.phone,
];

List listName = [
'Name',
'About',
'Phone'
];


  

