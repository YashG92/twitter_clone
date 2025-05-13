import 'package:flutter/material.dart';

import '../../../../../utils/constants/constants.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(decoration: InputDecoration(hintText: 'Enter email')),
          SizedBox(height: YSizes.spaceBtwInputFields),
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(hintText: 'Enter password'),
          ),
          SizedBox(height: YSizes.spaceBtwSections),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(onPressed: () {}, child: Text('Email Login')),
          ),
        ],
      ),
    );
  }
}
