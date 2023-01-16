import 'dart:async';
import 'package:get/get.dart';
import '../views/sms_view.dart';

class SplashController extends GetxController {
  startNavigationTimer() async {
    var duration = const Duration(seconds: 4);
    return Timer(duration, route);
  }

  route() {
    Get.offAll(const SmsView());
  }

  @override
  void onInit() {
    startNavigationTimer();
    super.onInit();
  }
}
