import 'package:flutter/material.dart';
import 'package:sms/Presentation_layer/controllers/splash_controller.dart';
import 'package:sms/theme/theme_constants.dart';
import 'package:get/get.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});
  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    Get.put(SplashController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kBackgroundColor,
      child: Center(
        child: Image.asset(
          'assets/logo/logo.png',
          width: 200,
        ),
      ),
    );
  }
}
