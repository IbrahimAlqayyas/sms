import 'package:flutter/material.dart';
import 'package:sms/Presentation_layer/theme/theme_constants.dart';
import 'views/splash_view.dart';
import 'package:get/get.dart';

class SmsApp extends StatelessWidget {
  const SmsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SMS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        primaryColor: kPrimaryColor,
        backgroundColor: kBackgroundColor,
        fontFamily: 'A Jannat LT Regular',
      ),
      home: const SplashView(),
    );
  }
}
