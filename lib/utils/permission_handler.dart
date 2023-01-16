import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  static Future<dynamic> handleSmsPermission() async {
    bool status;
    if (!await Permission.sms.status.isGranted) {
      status = await _requestPermission();
    } else {
      status = true;
    }
    return status;
  }

  static _requestPermission() async {
    PermissionStatus request = await Permission.sms.request();
    if (request.isGranted) {
      return true;
    } else {
      return false;
    }
  }
}
