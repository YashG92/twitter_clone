import 'package:flutter/material.dart';

import '../theme/theme.dart';
import '../utils/helpers/helper_function.dart';

class FormDivider extends StatelessWidget {
  const FormDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunction.isDarkMode(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32 / 1.5),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: dark ? Palette.darkGrey : Palette.grey,
              thickness: 2,
              indent: 5,
              endIndent: 5,
            ),
          ),
          Text(
            'or',
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(fontSize: 16),
          ),
          Expanded(
            child: Divider(
              color: dark ? Palette.darkGrey : Palette.grey,
              thickness: 2,
              indent: 5,
              endIndent: 5,
            ),
          ),
        ],
      ),
    );
  }
}
