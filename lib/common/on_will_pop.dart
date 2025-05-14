import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class OnWillPop {
  static Future<bool> onWillPop(BuildContext context) async {
    return await Get.dialog(
          AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit the app'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                // Stay on page
                child: Text(
                  'Cancel',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              TextButton(
                onPressed: () {
                  if (Platform.isAndroid) {
                    SystemNavigator.pop();
                  }
                },
                child: Text(
                  'Yes',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ],
          ),
        ) ??
        false;
  }
}
