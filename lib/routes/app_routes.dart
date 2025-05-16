import 'package:get/get.dart';
import 'package:twitter_clone/bottom_nav_bar.dart';
import 'package:twitter_clone/feature/authentication/view/login/forget_password_view.dart';
import 'package:twitter_clone/feature/authentication/view/login/login_view.dart';
import 'package:twitter_clone/feature/authentication/view/signup/signup_view.dart';
import 'package:twitter_clone/feature/personalization/view/user_profile/user_profile_view.dart';
import 'package:twitter_clone/routes/routes.dart';

import '../feature/search/search_view.dart';
import '../feature/search/searched_content_view.dart';

class AppRoutes {
  static final pages = [
    GetPage(
      name: Routes.loginView,
      page: () => const LoginView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.signUpView,
      page: () => const SignupView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.forgotPasswordView,
      page: () => const ForgotPasswordView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.bottomNavBar,
      page: () =>  BottomNavBar(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.userProfileView,
      page: () => const UserProfileView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.searchView,
      page: () => const SearchView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.searchedContentView,
      page: () => const SearchedContentView(),
      transition: Transition.fadeIn,
    ),
  ];
}
