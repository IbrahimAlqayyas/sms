import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:sms/sms_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    DevicePreview(
      // enabled: true,
      enabled: false,
      builder: (context) => const SmsApp(),
    ),
  );
}
