import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:provider/provider.dart';
import 'package:tiktok/screen/auth/register/widget/sign_up_text.dart';
import 'package:tiktok/screen/home_page.dart';
import 'package:tiktok/utils/my_colors.dart';
import 'package:tiktok/utils/my_utils.dart';
import 'package:tiktok/view/auth_google_repo.dart';
import 'package:tiktok/view/auth_view_model.dart';

class SignUpPage extends StatefulWidget {
  final VoidCallback onClickSignIp;
  const SignUpPage({super.key, required this.onClickSignIp});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  bool isTrue = true;

  @override
  Widget build(BuildContext context) {
    AuthGoogleViewModel authProvider = Provider.of<AuthGoogleViewModel>(context);
    return KeyboardDismisser(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: height(context) * 0.035),
          child: Form(
            key: formKey,
            child: SizedBox(
              height: height(context),
              width: width(context),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(top: height(context) * 0.2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Welcome to Grofast!',
                              style: TextStyle(fontSize: 30)),
                          SizedBox(height: height(context) * 0.04),
                          TextFormField(
                              controller: nameController,
                              validator: (value) =>
                                  value != null && value.length < 2
                                      ? 'Enter full name'
                                      : null,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              cursorHeight: 22,
                              decoration: getInputDecoration(
                                  icon: Icons.person_outline_rounded,
                                  word: 'Full Name',
                                  eye: icon())),
                          SizedBox(height: height(context) * 0.022),
                          TextFormField(
                              validator: (value) => value != null &&
                                      !EmailValidator.validate(value)
                                  ? 'Email address is incorrect'
                                  : null,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              cursorHeight: 22,
                              controller: emailController,
                              decoration: getInputDecoration(
                                  icon: Icons.email_outlined,
                                  word: 'Email Adress',
                                  eye: icon())),
                          SizedBox(height: height(context) * 0.022),
                          TextFormField(
                            validator: (password) =>
                                password != null && password.length < 6
                                    ? 'Password is incorrect'
                                    : null,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            obscureText: isTrue,
                            controller: passwordController,
                            decoration: getInputDecoration(
                                icon: Icons.lock_outline_sharp,
                                word: 'Password',
                                eye: icon()),
                            cursorHeight: 22,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      top: height(context) * 0.64,
                      child: Column(
                        children: [
                          InkWell(
                            onTap: SignUp,
                            child: Container(
                              height: height(context) * 0.08,
                              width: width(context) * 0.85,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      height(context) * 0.06),
                                  gradient: gradientGreen()),
                              child: const Center(
                                  child: Text(
                                'Sign in',
                                style: TextStyle(color: Colors.white),
                              )),
                            ),
                          ),
                          SizedBox(height: height(context) * 0.03),
                          const Center(child: Text('or With')),
                          SizedBox(height: height(context) * 0.03),
                          InkWell(
                            onTap: () {
                              authProvider
                                    .signInWithGoogle()
                                    .then((isSuccess) {
                                  if (isSuccess) {
                                    print(isSuccess);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const HomePage(),
                                      ),
                                    );
                                  }
                                }).catchError((error, stackTrace) {
                                  Fluttertoast.showToast(msg: error.toString());
                                });
                            },
                            child: Row(children: [
                              Image.asset('assets/images/google.png',width: height(context)*0.03,),
                              SizedBox(width: width(context)*0.03,),
                              const Text('Google Sign in')
                            ],
                            ),
                          ),
                          SizedBox(height: height(context) * 0.06),
                          Center(
                              child: SignUpText(
                                  onClickSignUp: widget.onClickSignIp)),
                        ],
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> SignUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    await Provider.of<AuthViewModel>(context, listen: false).signUp(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget icon() {
    return isTrue
        ? IconButton(
            icon: const Icon(Icons.visibility_off_sharp),
            onPressed: () {
              setState(() {
                isTrue = !isTrue;
              });
            },
          )
        : IconButton(
            icon: const Icon(Icons.remove_red_eye),
            onPressed: () {
              setState(() {
                isTrue = !isTrue;
              });
            },
          );
  }
}
