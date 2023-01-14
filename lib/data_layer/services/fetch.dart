import 'package:sms/data_layer/services/sms_services.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import '../models/sms.dart';

class Fetch implements SmsService {
  @override
  Future<List<Sms>> fetchMessages({String? keyword}) async {
    SmsQuery query = SmsQuery();
    List<SmsMessage> messages = await query.querySms(
      kinds: [SmsQueryKind.inbox],
    );
    return parseSmsListIntoModels(messages);
  }

  @override
  List<Sms> parseSmsListIntoModels(List<SmsMessage> messages) {
    List<Sms> smsList = [];
    for (SmsMessage msg in messages) {
      smsList.add(Sms.fromSmsMessage(msg));
    }
    return smsList;
  }
}
