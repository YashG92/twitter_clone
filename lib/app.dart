import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/routes/app_routes.dart';
import 'package:twitter_clone/splash_screen.dart';
import 'package:twitter_clone/theme/app_theme.dart';

import 'bindings/general_bindings.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: GeneralBindings(),
      title: 'Twitter Clone',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      getPages: AppRoutes.pages,
      home: const SplashScreen(),
    );
  }
}
