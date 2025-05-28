import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/feature/chat/view/chat_list_view.dart';
import 'package:twitter_clone/feature/home/view/home_view.dart';
import 'package:twitter_clone/feature/notification/notification_view.dart';
import 'package:twitter_clone/feature/search/search_view.dart';
import 'package:twitter_clone/theme/theme.dart';
import 'package:twitter_clone/utils/helpers/helper_function.dart';

import 'feature/chat/controller/chat_controller.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunction.isDarkMode(context);
    final controller = Get.put(BottomNavBarController());
    final chatController = Get.put(ChatController());
    return Obx(() {
      final totalUnread = chatController.chats.fold(
        0,
        (sum, chat) => sum + chatController.getUnreadCount(chat),
      );
      return Scaffold(
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Palette.grey, width: 0.5)),
          ),
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
                unreadCount: totalUnread,
              ),
            ],
          ),
        ),
        body: controller.screens[controller.selectedIndex.value],
      );
    });
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
    BuildContext context,
    BottomNavBarController controller,
    IconData outlinedIcon,
    IconData filledIcon,
    int index,
    String label, {
    int unreadCount = 0,
  }) {
    final selectedIndex = controller.selectedIndex.value;
    final isSelected = selectedIndex == index;

    return BottomNavigationBarItem(
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(
            isSelected ? filledIcon : outlinedIcon,
            size: isSelected ? 30 : 25,
            color:
                isSelected
                    ? (HelperFunction.isDarkMode(context)
                        ? Colors.white
                        : Colors.blue)
                    : Colors.grey,
          ),
          if (unreadCount > 0 && index == 3)
            Positioned(
              right: -5,
              top: -5,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        HelperFunction.isDarkMode(context)
                            ? Palette.darkBackgroundColor
                            : Colors.white,
                    width: 2,
                  ),
                ),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                child: Text(
                  unreadCount > 9 ? '9+' : unreadCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
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
    SearchView(),
    NotificationView(),
    ChatListView(),
  ];
}
