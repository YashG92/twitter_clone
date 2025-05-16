import 'package:flutter/material.dart';
import 'package:twitter_clone/common/common_app_drawer.dart';
import 'package:twitter_clone/common/custom_appbar.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Search twitter',isSearch: true),
      drawer: CommonAppDrawer(),
    );
  }
}
