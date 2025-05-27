import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/feature/personalization/controller/follower_following_controller.dart';
import 'package:twitter_clone/feature/personalization/controller/user_controller.dart';
import 'package:twitter_clone/feature/personalization/model/user_model.dart';
import 'package:twitter_clone/utils/constants/constants.dart';

import '../user_profile/user_profile_view.dart';

class FollowingView extends StatelessWidget {
  const FollowingView({super.key});

  @override
  Widget build(BuildContext context) {
    final f = FollowerFollowingController.instance;
    final userId = Get.arguments as String;
    WidgetsBinding.instance.addPostFrameCallback((_){
      f.loadUserFollowing(userId);
    });
    return Scaffold(
      appBar: AppBar(title: Text("Following")),
      body: Obx(() {
        final followingUsers = f.followingList;
        if (followingUsers.isEmpty) {
          return Center(child: Text('No followers'));
        }

        return Padding(
          padding: EdgeInsets.all(YSizes.defaultSpace / 2),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: followingUsers.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final followerUser = followingUsers[index];
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
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(user.profileImage),
                      backgroundColor:
                      Colors.grey[200],
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
