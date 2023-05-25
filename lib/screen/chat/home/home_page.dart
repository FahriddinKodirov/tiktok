import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:tiktok/data/model/popus_choicec.dart';
import 'package:tiktok/data/model/user_chat.dart';
import 'package:tiktok/screen/chat/chat/chat_page.dart';
import 'package:tiktok/screen/chat/home/widget/build_item.dart';
import 'package:tiktok/screen/chat/home/widget/popum_menu.dart';
import 'package:tiktok/screen/chat/home/widget/show_dialog_widget.dart';
import 'package:tiktok/screen/chat/login/login_page.dart';
import 'package:tiktok/screen/chat/settings/settings_page.dart';
import 'package:tiktok/screen/widgets/widgets.dart';
import 'package:tiktok/utils/debouncer.dart';
import 'package:tiktok/utils/utils.dart';
import 'package:tiktok/view_model/auth_view_model.dart';
import 'package:tiktok/view_model/home_view_model.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final ScrollController listScrollController = ScrollController();

  int _limit = 20;
  int _limitIncrement = 20;
  String _textSearch = "";
  bool isLoading = false;

  late AuthViewModel authProvider;
  late String currentUserId;
  late HomeProvider homeProvider;
  Debouncer searchDebouncer = Debouncer(milliseconds: 300);
  StreamController<bool> btnClearController = StreamController<bool>();
  TextEditingController searchBarTec = TextEditingController();


  @override
  void initState() {
    super.initState();
    authProvider = context.read<AuthViewModel>();
    homeProvider = context.read<HomeProvider>();

    if (authProvider.getUserFirebaseId()?.isNotEmpty == true) {
      currentUserId = authProvider.getUserFirebaseId()!;
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false,
      );
    }
    registerNotification();
    configLocalNotification();
    listScrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    btnClearController.close();
  }

  void registerNotification() {
    firebaseMessaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('onMessage: $message');
      if (message.notification != null) {
        showNotification(message.notification!);
      }
      return;
    });

    firebaseMessaging.getToken().then((token) {
      print('push token: $token');
      if (token != null) {
        homeProvider.updateDataFirestore('users', currentUserId, {'pushToken': token});
      }
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  void configLocalNotification() {
    AndroidInitializationSettings initializationSettingsAndroid = const AndroidInitializationSettings('app_icon');
    IOSInitializationSettings initializationSettingsIOS = const IOSInitializationSettings();
    InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void scrollListener() {
    if (listScrollController.offset >= listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  
  void showNotification(RemoteNotification remoteNotification) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      Platform.isAndroid ? 'com.dfa.flutterchatdemo' : 'com.duytq.flutterchatdemo',
      'Flutter chat demo',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

    print(remoteNotification);

    await flutterLocalNotificationsPlugin.show(
      0,
      remoteNotification.title,
      remoteNotification.body,
      platformChannelSpecifics,
      payload: null,
    );
  }

  Future<bool> onBackPress() {
    openDialog(context);
    return Future.value(false);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text(
          'Home',
          style: TextStyle(color: Color(0xff203152)),
        ),
        centerTitle: true,
        actions: const [
           PopupMenuWidget()
        ],
      ),
      body: SafeArea(
        child: WillPopScope(
          onWillPop: onBackPress,
          child: Stack(
            children: [
              Column(
                children: [
                  buildSearchBar(),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: homeProvider.getStreamFireStore('users', _limit, _textSearch),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          if ((snapshot.data?.docs.length ?? 0) > 0) {
                            return BuilItem(currentUserId: currentUserId, listScrollController: listScrollController, snapshot: snapshot,);
                          } else {
                            return const Center(
                              child: Text("No users"),
                            );
                          }
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(
                              color:Color(0xfff5a623)
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),

              // Loading
              Positioned(
                child: isLoading ? const LoadingView() : const SizedBox.shrink(),
              )
            ],
          ),
        ),
      ),
    );
  }

   Widget buildSearchBar() {
    return Container(
      height: 40,
      // ignore: sort_child_properties_last
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.search, color: Color(0xffaeaeae), size: 20),
          const SizedBox(width: 5),
          Expanded(
            child: TextFormField(
              textInputAction: TextInputAction.search,
              controller: searchBarTec,
              onChanged: (value) {
                searchDebouncer.run(() {
                  if (value.isNotEmpty) {
                    btnClearController.add(true);
                    setState(() {
                      _textSearch = value;
                    });
                  } else {
                    btnClearController.add(false);
                    setState(() {
                      _textSearch = "";
                    });
                  }
                });
              },
              decoration: const InputDecoration.collapsed(
                hintText: 'Search nickname (you have to type exactly string)',
                hintStyle: TextStyle(fontSize: 13, color:Color(0xffaeaeae) ),
              ),
              style: const TextStyle(fontSize: 13),
            ),
          ),
          StreamBuilder<bool>(
              stream: btnClearController.stream,
              builder: (context, snapshot) {
                return snapshot.data == true
                    ? GestureDetector(
                        onTap: () {
                          searchBarTec.clear();
                          btnClearController.add(false);
                          setState(() {
                            _textSearch = "";
                          });
                        },
                        child: const Icon(Icons.clear_rounded, color: Color(0xffaeaeae), size: 20))
                    : const SizedBox.shrink();
              }),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xffE8E8E8),
      ),
      padding:const EdgeInsets.fromLTRB(16, 8, 16, 8),
      margin:const EdgeInsets.fromLTRB(16, 8, 16, 8),
    );
  }

}