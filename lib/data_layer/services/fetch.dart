import 'package:sms/data_layer/services/sms_services.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';

class Fetch implements SmsService {
  @override
  Future<List<SmsMessage>> fetchMessages({String? keyword}) async {
    SmsQuery query = SmsQuery();
    List<SmsMessage> messages = await query.querySms(
      kinds: [SmsQueryKind.inbox],
    );
    return messages;
  }
}
