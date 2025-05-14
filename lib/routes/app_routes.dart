import 'package:get/get.dart';
import 'package:twitter_clone/feature/authentication/view/login/forget_password_view.dart';
import 'package:twitter_clone/feature/authentication/view/login/login_view.dart';
import 'package:twitter_clone/feature/authentication/view/signup/signup_view.dart';
import 'package:twitter_clone/routes/routes.dart';

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
      name: Routes.navigationMenu,
      page: () => const LoginView(),
      transition: Transition.fadeIn,
    ),
  ];
}
