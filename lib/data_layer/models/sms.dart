import 'dart:async';

import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:get/get.dart';
import 'package:sms/utils/number_formatting_extension.dart';

/// Message
class Sms implements Comparable<Sms> {
  int? id;
  int? threadId;
  String? sender;
  String? body;
  bool? read;
  DateTime? date;
  DateTime? dateSent;
  SmsMessageKind? kind;
  SmsMessageState _state = SmsMessageState.none;
  double? amount;
  bool? isTransaction;

  Sms(
      {this.id,
      this.threadId,
      this.sender,
      this.body,
      this.read,
      this.date,
      this.dateSent,
      this.kind,
      this.amount,
      this.isTransaction});

  final StreamController<SmsMessageState> _stateStreamController = StreamController<SmsMessageState>();

  Sms.fromSmsMessage(SmsMessage data) {
    sender = data.address;
    body = data.body;
    id = data.id;
    threadId = data.threadId;
    read = data.read;
    kind = data.kind;
    date = data.date;
    dateSent = data.dateSent;
    amount = _getAmount(data.body);
    isTransaction = amount == 0.0 ? false : true;
  }

  double? _getAmount(String? body) {
    try {
      double? amount;
      if (body!.toLowerCase().contains('aed')) {
        List<String> bodyParts = body.split(' ');
        for (int i = 0; i < bodyParts.length; i++) {
          if (i == 0 && bodyParts[i].replaceAll(RegExp('[^0-9]'), '').isNumericOnly) {
            amount = double.parse(bodyParts[i].replaceAll(',', ''));
          } else if (i > 0 || i < bodyParts.length - 1) {
            if (bodyParts[i].replaceAll(RegExp('[^0-9]'), '').isNumericOnly &&
                    bodyParts[i - 1].toLowerCase() == 'aed' ||
                bodyParts[i].replaceAll(RegExp('[^0-9]'), '').isNumericOnly &&
                    bodyParts[i + 1].toLowerCase() == 'aed') {
              amount = double.parse(bodyParts[i].replaceAll(',', ''));
            }
          } else {
            amount = 0.0;
          }
        }
      } else {
        amount = 0.0;
      }
      return amount!;
    } catch (e) {
      return 0.0;
    }
  }

  @override
  int compareTo(Sms other) {
    return other.id! - id!;
  }
}
