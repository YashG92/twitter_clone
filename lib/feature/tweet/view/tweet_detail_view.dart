import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TweetDetailView extends StatelessWidget {
  const TweetDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final tweet = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close_sharp),
          onPressed: () => Get.back(),
        ),
        title: Text('Thread'),
      ),
      body: Column(),
    );
  }
}
