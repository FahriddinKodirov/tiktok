import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:tiktok/data/model/popus_choicec.dart';
import 'package:tiktok/screen/chat/login/login_page.dart';
import 'package:tiktok/screen/chat/settings/settings_page.dart';
import 'package:tiktok/view_model/auth_view_model.dart';
import 'package:tiktok/view_model/home_view_model.dart';

class PopupMenuWidget extends StatefulWidget {
  const PopupMenuWidget({super.key});

  @override
  State<PopupMenuWidget> createState() => _PopupMenuWidgetState();
}

class _PopupMenuWidgetState extends State<PopupMenuWidget> {
  late AuthViewModel authProvider;

  
  List<PopupChoices> choices = <PopupChoices>[
    PopupChoices(title: 'Settings', icon: Icons.settings),
    PopupChoices(title: 'Log out', icon: Icons.exit_to_app),
  ];

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<PopupChoices>(
      onSelected: onItemMenuPress,
      itemBuilder: (BuildContext context) {
        return choices.map((PopupChoices choice) {
          return PopupMenuItem<PopupChoices>(
              value: choice,
              child: Row(
                children: [
                  Icon(
                    choice.icon,
                    color:const Color(0xff203152),
                  ),
                  Container(
                    width: 10,
                  ),
                  Text(
                    choice.title,
                    style:const TextStyle(color: Color(0xff203152)),
                  ),
                ],
              ));
        }).toList();
      },
    );
  }

  Future<void> handleSignOut(context) async {
    authProvider.handleSignOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  
  void onItemMenuPress(PopupChoices choice) {
    if (choice.title == 'Log out') {
      handleSignOut(context);
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
    }
  }

}

