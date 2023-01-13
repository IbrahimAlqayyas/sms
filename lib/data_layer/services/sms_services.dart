import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';

abstract class SmsService {
  Future<List<SmsMessage>> fetchMessages({String? keyword});
}
