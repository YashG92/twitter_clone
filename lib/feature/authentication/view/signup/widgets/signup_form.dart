import 'package:flutter/material.dart';
import 'package:twitter_clone/utils/constants/constants.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(decoration: InputDecoration(hintText: 'Name')),
              SizedBox(height: YSizes.spaceBtwInputFields),
              TextFormField(
                decoration: InputDecoration(hintText: 'Enter email'),
              ),
              SizedBox(height: YSizes.spaceBtwInputFields),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(hintText: 'Enter password'),
              ),
              SizedBox(height: YSizes.spaceBtwInputFields),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(hintText: 'Confirm password'),
              ),
              SizedBox(height: YSizes.spaceBtwInputFields),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: () {}, child: Text('Sign Up')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
