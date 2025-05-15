import 'package:flutter/material.dart';
import 'package:twitter_clone/common/custom_appbar.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Home',),
    );
  }
}
