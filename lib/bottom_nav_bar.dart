import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/feature/authentication/view/login/login_view.dart';
import 'package:twitter_clone/feature/home/view/home_view.dart';
import 'package:twitter_clone/feature/notification/notification_view.dart';
import 'package:twitter_clone/feature/personalization/view/user_profile/user_profile_view.dart';
import 'package:twitter_clone/theme/theme.dart';
import 'package:twitter_clone/utils/helpers/helper_function.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunction.isDarkMode(context);
    final controller = Get.put(BottomNavBarController());
    return Obx(
      () => Scaffold(
        bottomNavigationBar: Container(
          decoration: BoxDecoration(border: Border(top: BorderSide(color: Palette.grey,width: 0.5))),
          child: BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            onTap: (index) => controller.selectedIndex.value = index,
            elevation: 30,
            type: BottomNavigationBarType.fixed,
            //selectedItemColor: Colors.blue,
            backgroundColor: dark ? Palette.darkBackgroundColor : Colors.white,
            fixedColor: dark ? Colors.white : Colors.black,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              _buildBottomNavigationBarItem(
                context,
                controller,
                Icons.home_outlined,
                Icons.home,
                0,
                'Home',
              ),
              _buildBottomNavigationBarItem(
                context,
                controller,
                Icons.search_outlined,
                Icons.search,
                1,
                'Search',
              ),
              _buildBottomNavigationBarItem(
                context,
                controller,
                Icons.notifications_outlined,
                Icons.notifications,
                2,
                'Notifications',
              ),
              _buildBottomNavigationBarItem(
                context,
                controller,
                Icons.mail_outline,
                Icons.mail,
                3,
                'Messages',
              ),
            ],
          ),
        ),
        body: controller.screens[controller.selectedIndex.value],
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
    BuildContext context,
    BottomNavBarController controller,
    IconData outlinedIcon,
    IconData filledIcon,
    int index,
    String label,
  ) {
    final selectedIndex = controller.selectedIndex.value;
    return BottomNavigationBarItem(
      icon: Icon(
        selectedIndex == index ? filledIcon : outlinedIcon,
        size: selectedIndex == index ? 30 : 25,
        color:
            selectedIndex == index
                ? (HelperFunction.isDarkMode(context)
                    ? Colors.white
                    : Colors.blue)
                : Colors.grey,
      ),
      label: label,
    );
  }
}

class BottomNavBarController extends GetxController {
  static BottomNavBarController get instance => Get.find();

  final Rx<int> selectedIndex = 0.obs;

  final screens = const [
    HomeView(),
    LoginView(),
    NotificationView(),
    UserProfileView(),
  ];
}
