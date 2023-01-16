import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/theme_constants.dart';

showSnackBar(str,
    {message = '',
    duration = 3,
    Color backgroundColor = kBackgroundColor,
    Color colorText = kPrimaryColor,
    overlayBlur,
    snackPosition = SnackPosition.BOTTOM,
    margin = const EdgeInsets.all(16),
    boxShadow}) {
  Get.snackbar(
    str.toString(),
    message,
    borderRadius: 4,
    snackPosition: snackPosition,
    duration: Duration(seconds: duration),
    backgroundColor: backgroundColor,
    colorText: colorText,
    overlayBlur: overlayBlur,
    margin: margin,
    boxShadows: boxShadow,
  );
}
