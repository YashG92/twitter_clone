import 'package:flutter/material.dart';
import 'package:twitter_clone/common/custom_appbar.dart';
import 'package:twitter_clone/feature/notification/widget/notification_card.dart';

import '../../common/common_app_drawer.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Notifications'),
      drawer: CommonAppDrawer(),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: 15,
          separatorBuilder: (context, index) => Divider(),
          itemBuilder: (context, index) {
            return NotificationCard();
          },
        ),
      ),
    );
  }
}
