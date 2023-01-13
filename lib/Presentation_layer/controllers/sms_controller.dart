import 'dart:developer';

import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:get/get.dart';
import 'package:sms/data_layer/services/sms_services.dart';
import 'package:sms/utils/list_extensions.dart';
import 'package:sms/utils/permission_handler.dart';
import '../../data_layer/services/fetch.dart';
import '../../data_layer/services/filter.dart';

class SmsController extends GetxController {
  bool? isLoadingMessages;
  String? loadingErrorMessage;
  List<SmsMessage> smsMessageList = [];
  Permission? permissionStatus;
  bool? fetchFailed;

  _emitIsLoadingState(bool state) {
    isLoadingMessages = state;
    update();
  }

  fetchSmsMessages({String? keyword}) async {
    try {
      if (keyword == null || keyword.removeAllWhitespace == '') {
        await _fetchAllMessages(smsService: Fetch());
      } else {
        await _fetchFilteredMessages(smsService: Filter(), keyword: keyword);
      }
      log('/// SMS Messages Length:');
      log(smsMessageList.length.toString());
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
