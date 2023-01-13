import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  // returning bool <or> string
  static Future<dynamic> handleSmsPermission() async {
    dynamic status;
    if (!await Permission.sms.status.isGranted) {
      status = await _requestPermission();
    } else {
      status = true;
    }
    return status;
  }

  static _requestPermission() async {
    dynamic status = false;
    await Permission.sms.request().then((result) {
      if (result.isGranted) {
        status = true;
        return;
      } else if (result.isDenied) {
        status = false;
        return;
      } else if (result.isPermanentlyDenied) {
        status = 'denied_permanently';
        return;
      } else if (result.isRestricted) {
        status = 'denied_permanently';
        return;
      } else {
        status = false;
        return;
      }
    });
    return status;
  }
}
