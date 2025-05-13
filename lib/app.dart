import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/feature/authentication/view/signup/signup_view.dart';
import 'package:twitter_clone/splash_screen.dart';
import 'package:twitter_clone/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Twitter Clone',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
