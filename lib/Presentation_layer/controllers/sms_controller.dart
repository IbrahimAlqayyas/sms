import 'dart:developer';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:get/get.dart';
import 'package:sms/data_layer/services/sms_services.dart';
import 'package:sms/utils/list_extensions.dart';
import 'package:sms/utils/number_formatting_extension.dart';
import 'package:sms/utils/permission_handler.dart';
import '../../data_layer/models/sms.dart';
import '../../data_layer/services/fetch.dart';
import '../../data_layer/services/filter.dart';

class SmsController extends GetxController {
  bool? isLoadingMessages;
  String? loadingErrorMessage;
  List<Sms> smsMessageList = [];
  List<bool> isExpanded = [];
  Permission? permissionStatus;
  bool? fetchFailed;

  _emitIsLoadingState(bool state) {
    isLoadingMessages = state;
    update();
  }

  changeIsExpandedState(bool state, index) {
    isExpanded[index] = state;
    update();
  }

  String getTotalAmount() {
    double amount = 0.0;
    for(int i = 0 ; i < smsMessageList.length ; i++) {
      amount += smsMessageList[i].amount!.toDouble();
    }

    return amount.formatThousands();
  }

  fetchSmsMessages({String? keyword}) async {
    try {

      // TODO: re-activate the conditions
      // if (keyword == null || keyword.removeAllWhitespace == '') {
      //   await _fetchAllMessages(smsService: Fetch());
      // } else {
      //   await _fetchFilteredMessages(smsService: Filter(), keyword: keyword);
      // }

      // TODO: remove this declaration (only testing)
    smsMessageList = [
    Sms.fromSmsMessage(SmsMessage.fromJson({'body' : 'ttego AED 2,563.05 ;jndfg', 'address' : 'Ibrahim', 'date' : 1640979000000})),
    Sms.fromSmsMessage(SmsMessage.fromJson({'body' : 'ttego AED 2574.05 ;jndfg', 'address' : 'Ibrahim', 'date' : 1640979000000})),
    Sms.fromSmsMessage(SmsMessage.fromJson({'body' : 'ttego AED 2,000.0 ;jndfg', 'address' : 'Ibrahim', 'date' : 1640979000000})),
    Sms.fromSmsMessage(SmsMessage.fromJson({'body' : 'ttego AED 63.05 ;jndfg', 'address' : 'Ibrahim', 'date' : 1640979000000})),
    Sms.fromSmsMessage(SmsMessage.fromJson({'body' : 'ttego AED 63.05 AED ;jndfg', 'address' : 'Ibrahim', 'date' : 1640979000000})),
    Sms.fromSmsMessage(SmsMessage.fromJson({'body' : '63.05 AED ;jndfg', 'address' : 'Ibrahim', 'date' : 1640979000000})),
    Sms.fromSmsMessage(SmsMessage.fromJson({'body' : 'AED 63.05 ;jndfg', 'address' : 'Ibrahim', 'date' : 1640979000000})),
    Sms.fromSmsMessage(SmsMessage.fromJson({'body' : ';jndfg 63.05 AED', 'address' : 'Ibrahim', 'date' : 1640979000000})),
    Sms.fromSmsMessage(SmsMessage.fromJson({'body' : ';jndfg AED 10000.05', 'address' : 'Ibrahim', 'date' : 1640979000000})),

    ];
      log('/// SMS Messages Length:');
      log(smsMessageList.length.toString());
      for (int i = 0 ; i < smsMessageList.length ; i++) {
        isExpanded.add(false);
      }
      _emitIsLoadingState(false);
    } catch(e, stacktrace) {
      fetchFailed = true;
      log(e.toString());
      log(stacktrace.toString());
      _emitIsLoadingState(false);
    }
  }

  _fetchAllMessages({required SmsService smsService}) async {
    smsMessageList = await smsService.fetchMessages();
    smsMessageList.convertIntoEmptyListIfNull<SmsMessage>();
  }

  _fetchFilteredMessages({required SmsService smsService, String? keyword}) async {
    smsMessageList = await smsService.fetchMessages(keyword: keyword);
    smsMessageList.convertIntoEmptyListIfNull<SmsMessage>();
  }

  _checkPermissionAndFetchMessages() async {
    bool permissionStatus = await PermissionHandler.handleSmsPermission();
    if (permissionStatus == true) {
      this.permissionStatus = Permission.granted;
      fetchSmsMessages();
    } else {
      this.permissionStatus = Permission.denied;
      loadingErrorMessage =
      'You denied the permission of reading the SMS messages.\nRe-activate form the settings';
      _emitIsLoadingState(false);
    }
  }

  @override
  void onInit() {
    fetchFailed = false;
    _emitIsLoadingState(true);
    _checkPermissionAndFetchMessages();
    super.onInit();
  }
}

enum Permission {
  granted,
  denied,
}
