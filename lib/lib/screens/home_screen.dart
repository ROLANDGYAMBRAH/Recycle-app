import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../utils/locale_keys.g.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.home_title.tr()),
      ),
      body: Center(
        child: Text(LocaleKeys.welcome.tr()),
      ),
    );
  }
}
