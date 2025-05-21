import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentView extends StatelessWidget {
  const CommentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close_sharp),
          onPressed: () => Get.back(),
        ),
        actions: [
          SizedBox(
            width: 80,
            height: 46,
            child: ElevatedButton(onPressed: () {}, child: Text('Reply')),
          ),
        ],
      ),
    );
  }
}
