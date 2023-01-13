import 'dart:developer';

import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:get/get.dart';
import 'package:sms/data_layer/services/sms_services.dart';
import 'package:sms/utils/list_extensions.dart';
import 'package:sms/utils/permission_handler.dart';
import '../../data_layer/models/sms.dart';
import '../../data_layer/services/fetch.dart';
import '../../data_layer/services/filter.dart';

class SmsController extends GetxController {
  bool? isLoadingMessages;
  String? loadingErrorMessage;
  List<SmsMessage> smsMessageList = [];

  _emitIsLoadingState(bool state) {
    isLoadingMessages = state;
    update();
  }

  fetchSmsMessages({String? keyword}) async {
    _emitIsLoadingState(true);
    if (keyword == null || keyword.removeAllWhitespace == '') {
      await _fetchAllMessages(smsService: Fetch());
    } else {
      await _fetchFilteredMessages(smsService: Filter(), keyword: keyword);
    }
    log(smsMessageList.length.toString());
    _emitIsLoadingState(false);
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
    dynamic permissionStatus = await PermissionHandler.handleSmsPermission();
    if (permissionStatus is bool) {
      if (permissionStatus == true) {
        fetchSmsMessages();
      } else {
        loadingErrorMessage = 'Permission Error!';
      }
    } else if (permissionStatus is String) {
      loadingErrorMessage =
          'You denied to give the permission of reading the SMS messages permanently, re-activate form the settings';
    } else {
      loadingErrorMessage = 'Loading Error!';
    }
    log('/// Sms Permission Status: $permissionStatus');
  }

  @override
  void onInit() {
    _checkPermissionAndFetchMessages();
    super.onInit();
  }
}
