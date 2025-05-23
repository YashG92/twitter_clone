import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/feature/personalization/controller/user_controller.dart';
import 'package:twitter_clone/utils/constants/constants.dart';

import '../personalization/view/user_profile/widget/user_profile_avatar.dart';

class SearchedContentView extends StatelessWidget {
  const SearchedContentView({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = UserController.instance;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Hero(
          tag: 'search-bar',
          child: Material(
            color: Colors.transparent,
            child: SizedBox(
              height: kToolbarHeight,
              child: TextField(
                autofocus: true,
                onChanged: (query) => userController.searchUsers(query),
                decoration: InputDecoration(
                  hintText: 'Search Twitter',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios_new_outlined),
        ),
      ),
      body: Obx(() {
        final users = userController.searchedUsers;
        if (users.isEmpty) {
          return Center(child: Text('Enter Something...'));
        }

        return Padding(
          padding: EdgeInsets.all(YSizes.defaultSpace / 2),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: users.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: Image.network(user.profileImage),
                title: Text(
                  user.username,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                subtitle: Text(user.email.split('@').first),
              );
            },
          ),
        );
      }),
    );
  }
}
