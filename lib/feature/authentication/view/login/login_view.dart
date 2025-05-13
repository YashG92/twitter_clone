import 'package:flutter/material.dart';
import 'package:twitter_clone/common/common_appbar.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(),
    );
  }
}
