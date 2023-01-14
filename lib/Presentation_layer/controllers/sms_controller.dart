import 'dart:developer';
import 'package:flutter/cupertino.dart';
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
  List<Sms> smsMessageListToShow = [];
  List<bool> isExpanded = [];
  Permission? permissionStatus;
  bool? fetchFailed;
  int monthCount = 0;
  TextEditingController searchFieldController = TextEditingController();
  UniqueKey? expansionTileReRenderKey;

  /// to refresh the expansion tile for new expansion states
  void _expansionTileReRender() {
    expansionTileReRenderKey = UniqueKey();
    update();
  }

  _emitIsLoadingState(bool state) {
    isLoadingMessages = state;
    update();
  }

  changeIsExpandedState(bool state, index) {
    isExpanded[index] = state;
    update();
  }

  expandAllMessages() {
    isExpanded = [];
    for (var item in smsMessageListToShow) {
      isExpanded.add(true);
    }
    _expansionTileReRender();
  }

  collapseAllMessages() {
    isExpanded = [];
    for (var item in smsMessageListToShow) {
      isExpanded.add(false);
    }
    _expansionTileReRender();
    update();
  }

  String getTotalAmount() {
    double amount = 0.0;
    for (int i = 0; i < smsMessageListToShow.length; i++) {
      amount += smsMessageListToShow[i].amount!.toDouble();
    }

    return amount.formatThousands();
  }

  addToMonthCount() {
    monthCount += 1;
  }

  String getTotalMonths() {
    if (monthCount == 1) {
      return '$monthCount Month';
    }
    return '$monthCount Months';
  }

  filter(String keyword) {
    smsMessageListToShow = [];
    isExpanded = [];

    for (var item in smsMessageList) {
      if (item.body!.toLowerCase().contains(keyword.toLowerCase())) {
        smsMessageListToShow.add(item);
        isExpanded.add(true);
      }
    }
    update();
    _expansionTileReRender();
  }

  clearFilter() {
    smsMessageListToShow = smsMessageList;
    isExpanded = [];
    searchFieldController.clear();
    for (var item in smsMessageList) {
      isExpanded.add(false);
    }
    update();
    _expansionTileReRender();
  }

  fetchSmsMessages({String? keyword}) async {
    try {
      monthCount = 0;
      smsMessageList = [];
      isExpanded = [];
      fetchFailed = false;
      if (keyword == null || keyword.removeAllWhitespace == '') {
        await _fetchAllMessages(smsService: Fetch());
      }
      // else {
      //   await _fetchFilteredMessages(smsService: Filter(), keyword: keyword);
      // }

      // TODO: remove this declaration

      smsMessageList = [
        Sms.fromSmsMessage(SmsMessage.fromJson(
            {'body': 'Configuration AED 2,563.05 ;jndfg', 'address': 'Ibrahim', 'date': 1640979000000})),
        Sms.fromSmsMessage(SmsMessage.fromJson(
            {'body': 'Innovation AED 2,563.05 ;jndfg', 'address': 'Ibrahim', 'date': 1640979000000})),
        Sms.fromSmsMessage(SmsMessage.fromJson(
            {'body': 'Innovation 2574.05 ;jndfg', 'address': 'Ibrahim', 'date': 1652486621000})),
        Sms.fromSmsMessage(SmsMessage.fromJson(
            {'body': 'Configuration AED 2574.05 ;jndfg', 'address': 'Mohamed', 'date': 1652486621000})),
        Sms.fromSmsMessage(SmsMessage.fromJson(
            {'body': 'Innovation AED 2,000.0 ;jndfg', 'address': 'Mohamed', 'date': 1647216221000})),
        Sms.fromSmsMessage(SmsMessage.fromJson(
            {'body': 'Configuration 2,000.0 ;jndfg', 'address': 'Mohamed', 'date': 1647216221000})),
        Sms.fromSmsMessage(SmsMessage.fromJson(
            {'body': 'Innovation AED 63.05 ;jndfg', 'address': 'Ahmed', 'date': 1642118621000})),
        Sms.fromSmsMessage(SmsMessage.fromJson(
            {'body': 'Clarification AED 63.05 ;jndfg', 'address': 'Ahmed', 'date': 1642118621000})),
        Sms.fromSmsMessage(SmsMessage.fromJson(
            {'body': 'Clarification AED 63.05 AED ;jndfg', 'address': 'Ahmed', 'date': 1636848221000})),
        Sms.fromSmsMessage(SmsMessage.fromJson(
            {'body': 'Clarification AED 63.05 AED ;jndfg', 'address': 'Ahmed', 'date': 1636848221000})),
        Sms.fromSmsMessage(SmsMessage.fromJson(
            {'body': 'Clarification AED 63.05 AED ;jndfg', 'address': 'Rovan', 'date': 1636848221000})),
        Sms.fromSmsMessage(SmsMessage.fromJson(
            {'body': '63.05 AED ;Encapsulation', 'address': 'Rovan', 'date': 1636848221000})),
        Sms.fromSmsMessage(SmsMessage.fromJson(
            {'body': 'AED 63.05 ;Encapsulation', 'address': 'Rovan', 'date': 1636848221000})),
        Sms.fromSmsMessage(SmsMessage.fromJson(
            {'body': ';Encapsulation 63.05 AED', 'address': 'Rovan', 'date': 1636848221000})),
        Sms.fromSmsMessage(SmsMessage.fromJson(
            {'body': ';No hesitation AED 10000.05', 'address': 'Rovan', 'date': 1636848221000})),
      ];

      smsMessageListToShow = smsMessageList;
      for (int i = 0; i < smsMessageList.length; i++) {
        isExpanded.add(false);
        if (i == 0 || i > 0 && smsMessageList[i].date?.month != smsMessageList[i - 1].date?.month) {
          addToMonthCount();
        }
      }
      _emitIsLoadingState(false);
    } catch (e, stacktrace) {
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

  // _fetchFilteredMessages({required SmsService smsService, String? keyword}) async {
  //   smsMessageList = await smsService.fetchMessages(keyword: keyword);
  //   smsMessageList.convertIntoEmptyListIfNull<SmsMessage>();
  // }

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
