import 'package:flutter/material.dart';

import '../../../../../theme/theme.dart';

class ForgetPasswordButton extends StatelessWidget {
  const ForgetPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Text(
        'Forget password?',
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
          color: Palette.blueColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
