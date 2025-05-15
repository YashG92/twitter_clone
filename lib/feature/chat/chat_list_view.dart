import 'package:flutter/material.dart';
import 'package:twitter_clone/common/custom_appbar.dart';
import 'package:twitter_clone/feature/personalization/view/user_profile/widget/user_profile_avatar.dart';

import '../../common/common_app_drawer.dart';

class ChatListView extends StatelessWidget {
  const ChatListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Messages'),
      drawer: CommonAppDrawer(),
      body: ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            leading: UserProfileAvatar(
              backgroundRadius: 26,
              foregroundRadius: 26,
            ),
            title: Text(
              'Yash Gotrijiya',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: Text('@yashgotrijiya'),
          );
        },
        separatorBuilder: (_, __) => Divider(thickness: 0.6),
        itemCount: 5,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: CircleBorder(),
        child: Icon(Icons.messenger_outline),
      ),
    );
  }
}
