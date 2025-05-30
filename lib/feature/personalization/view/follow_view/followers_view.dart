import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/feature/personalization/controller/follower_following_controller.dart';
import 'package:twitter_clone/feature/personalization/controller/user_controller.dart';
import 'package:twitter_clone/feature/personalization/model/user_model.dart';
import 'package:twitter_clone/feature/personalization/view/user_profile/widget/user_profile_avatar.dart';
import 'package:twitter_clone/utils/constants/constants.dart';

import '../user_profile/user_profile_view.dart';

class FollowersView extends StatelessWidget {
  const FollowersView({super.key});

  @override
  Widget build(BuildContext context) {
    final f = FollowerFollowingController.instance;
    final userId = Get.arguments as String;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      f.loadUserFollowers(userId);
    });
    return Scaffold(
      appBar: AppBar(title: const Text('Followers')),
      body: Obx(() {
        final followerUsers = f.followersList;
        if (followerUsers.isEmpty) {
          return const Center(child: Text('No followers'));
        }

        return Padding(
          padding: const EdgeInsets.all(YSizes.defaultSpace / 2),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: followerUsers.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final followerUser = followerUsers[index];
              return StreamBuilder<UserModel>(
                stream: UserController.instance.getUserStream(
                  followerUser.userId,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(
                      leading: CircleAvatar(radius: 25),
                      title: Text('Loading...'),
                    );
                  }

                  if (!snapshot.hasData || snapshot.hasError) {
                    return const ListTile(
                      leading: CircleAvatar(radius: 25),
                      title: Text('Error loading user'),
                    );
                  }
                  final user = snapshot.data ?? UserModel.empty();
                  return ListTile(
                    onTap:
                        () => Get.to(
                          () => UserProfileView(otherUserId: user.userId),
                        ),
                    leading: UserProfileAvatar(
                      backgroundRadius: 25,
                      foregroundRadius: 25,
                      imageUrl: user.profileImage,
                    ),
                    title: Text(
                      user.username,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    subtitle: Text(user.email.split('@').first),
                  );
                },
              );
            },
          ),
        );
      }),
    );
  }
}
