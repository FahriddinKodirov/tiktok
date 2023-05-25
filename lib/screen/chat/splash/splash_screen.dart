import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiktok/screen/chat/home/home_page.dart';
import 'package:tiktok/screen/chat/login/login_page.dart';
import 'package:tiktok/view_model/auth_view_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      // just delay for showing this slash page clearer because it too fast
      checkSignedIn();
    });
  }

  void checkSignedIn() async {
    AuthViewModel authProvider = context.read<AuthViewModel>();
    bool isLoggedIn = await authProvider.isLoggedIn();
    if (isLoggedIn) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
      return;
    }
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "images/app_icon.png",
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 20),
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(color: Color(0xfff5a623)),
            ),
          ],
        ),
      ),
    );
  }
}