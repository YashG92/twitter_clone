import 'package:flutter/material.dart';

import '../../../../../utils/constants/constants.dart';

class TweetActionButton extends StatelessWidget {
  const TweetActionButton({
    super.key,
    required this.icon,
    this.count = 0,
    required this.onPressed,
  });

  final IconData icon;
  final int count;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: onPressed, icon: Icon(icon, size: 18)),
        if (count > 0) ...[
          const SizedBox(width: YSizes.sm / 2),
          Text(count.toString()),
        ],
      ],
    );
  }
}
