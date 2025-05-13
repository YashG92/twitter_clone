import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/feature/authentication/view/signup/signup_view.dart';
import 'package:twitter_clone/utils/helper_function.dart';

import 'constants/assets_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunction.isDarkMode(context);
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity(),
              child: Hero(
                tag: 'logo',
                child: SvgPicture.asset(
                  width: Get.height * 0.2 * _animation.value,
                  height: Get.height * 0.2 * _animation.value,
                  dark
                      ? AssetsConstants.darkAppLogo
                      : AssetsConstants.lightAppLogo,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);
    _animationController..reset()..repeat();
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAll(() => const SignupView());
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
