import 'dart:developer';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sms/Presentation_layer/sms_app.dart';

void main() {
  // log('/// ////////////////');
  // String x = 'gghj AED 2,542.00 aaaaa';
  // log(replace(x));
  // log(_getAmount(x).toString());

  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    DevicePreview(
      // enabled: true,
      enabled: false,
      builder: (context) => const SmsApp(),
    ),
  );
}

// replace (String? body) {
//   body = body!.replaceAll(RegExp('[^0-9]'), '');
//   return body;
// }
//
// double? _getAmount(String? body) {
//   try {
//     double? amount;
//     if (body!.toLowerCase().contains('aed')) {
//       List<String> bodyParts = body.split(' ');
//       log('Body Parts: ${bodyParts.length}');
//       for (int i = 0; i < bodyParts.length; i++) {
//         if (i > 0 || i < bodyParts.length - 1) {
//           if (bodyParts[i].replaceAll(RegExp('[^0-9]'), '').isNumericOnly &&
//                   bodyParts[i - 1].toLowerCase() == 'aed' ||
//               bodyParts[i].replaceAll(RegExp('[^0-9]'), '').isNumericOnly &&
//                   bodyParts[i + 1].toLowerCase() == 'aed') {
//             log(bodyParts[i]);
//             amount = double.parse(bodyParts[i].replaceAll(',', ''));
//           }
//         } else {
//           amount = 0.0;
//         }
//       }
//     } else {
//       amount = 0.0;
//     }
//     return amount!;
//   } catch (e, stacktrace) {
//     log(e.toString());
//     log(stacktrace.toString());
//     return null;
//   }
// }
