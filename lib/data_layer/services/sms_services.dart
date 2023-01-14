import '../models/sms.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';

abstract class SmsService {
  Future<List<Sms>> fetchMessages({String? keyword});
  List<Sms> parseSmsListIntoModels(List<SmsMessage> messages);
}
