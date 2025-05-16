import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/utils/constants/constants.dart';

import '../personalization/view/user_profile/widget/user_profile_avatar.dart';

class SearchedContentView extends StatelessWidget {
  const SearchedContentView({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: EdgeInsets.all(YSizes.defaultSpace/2),
        child: ListView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
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
          itemCount: 50,
        ),
      ),
    );
  }
}
