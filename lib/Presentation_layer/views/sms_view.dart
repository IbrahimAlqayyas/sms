import 'package:flutter/material.dart';
import 'package:sms/theme/theme_constants.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/version_strip.dart';

class SmsView extends StatelessWidget {
  const SmsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: const AppBarWidget(),
        bottomNavigationBar: const VersionStripWidget(),
      ),
    );
  }
}
