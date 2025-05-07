import 'package:flutter/material.dart';
import 'package:twitter_clone/common/common_appbar.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: CommonAppbar());
  }
}
