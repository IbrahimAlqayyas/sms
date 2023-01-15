import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:get/get.dart';
import 'package:sms/data_layer/services/sms_services.dart';
import 'package:sms/utils/list_extensions.dart';
import 'package:sms/utils/number_formatting_extension.dart';
import 'package:sms/utils/permission_handler.dart';
import 'package:sms/utils/string_utils.dart';
import '../../data_layer/models/sms.dart';
import '../../data_layer/services/fetch.dart';
import '../../data_layer/services/filter.dart';
import '../widgets/snackbar_widget.dart';

class SmsController extends GetxController {
  bool? isLoadingMessages;
  String? loadingErrorMessage;
  List<Sms> smsMessageList = [
    Sms.fromSmsMessage(SmsMessage.fromJson({
      'body': 'nnConfiguration confgu nn AED 2,563.05 ;jnndfg',
      'address': 'Ibrahim',
      'date': 1640979000000
    })),
    Sms.fromSmsMessage(SmsMessage.fromJson({
      'body': 'nnConfiguration confgu nn AED 2,563.05 ;jnndfg',
      'address': 'Ibrahim',
      'date': 1640979000000
    })),
    Sms.fromSmsMessage(SmsMessage.fromJson(
        {'body': 'Configuration AED 2574.05 ;jndfg', 'address': 'Mohamed', 'date': 1652486621000})),
    Sms.fromSmsMessage(SmsMessage.fromJson(
        {'body': 'Innovation AED 2,000.0 ;jndfg', 'address': 'Mohamed', 'date': 1647216221000})),
    Sms.fromSmsMessage(SmsMessage.fromJson(
        {'body': 'Innovation AED 63.05 ;jndfg', 'address': 'Ahmed', 'date': 1642118621000})),
    Sms.fromSmsMessage(SmsMessage.fromJson(
        {'body': 'Clarification AED 63.05 ;jndfgnn', 'address': 'Ahmed', 'date': 1642118621000})),
    Sms.fromSmsMessage(SmsMessage.fromJson(
        {'body': 'Clarification AED 63.05 AED ;jndfg', 'address': 'Rovan', 'date': 1636848221000})),
    Sms.fromSmsMessage(
        SmsMessage.fromJson({'body': '63.05 AED ;Encapsulation', 'address': 'Rovan', 'date': 1636848221000})),
    Sms.fromSmsMessage(
        SmsMessage.fromJson({'body': 'AED 63.05 ;Encapsulation', 'address': 'Rovan', 'date': 1636848221000})),
    Sms.fromSmsMessage(
        SmsMessage.fromJson({'body': ';Encapsulation 63.05 AED', 'address': 'Rovan', 'date': 1636848221000})),
    Sms.fromSmsMessage(
        SmsMessage.fromJson({'body': ';No hesitation 10000.05', 'address': 'Rovan', 'date': 1636848221000})),
  ];

  List<Sms> smsMessageListToShow = [];
  List<bool> isExpanded = [];
  Permission? permissionStatus;
  bool? fetchFailed;
  int monthCount = 0;
  TextEditingController searchKeywordController = TextEditingController();
  UniqueKey? expansionTileReRenderKey;
  bool isFiltered = false;

  addToMonthCount(List<Sms> smsList) {
    for (int i = 0; i < smsList.length; i++) {
      bool isFirstItem = i == 0;
      bool isNotFirstItem = i > 0;
      bool isSameYear = isNotFirstItem ? smsList[i].date?.year == smsList[i - 1].date?.year : true;
      bool isDifferentMonths = isNotFirstItem ? smsList[i].date?.month != smsList[i - 1].date?.month : false;
      bool isDifferentYears = isNotFirstItem ? smsList[i].date?.year != smsList[i - 1].date?.year : false;
      if (isFirstItem || isNotFirstItem && isSameYear && isDifferentMonths || isDifferentYears) {
        monthCount += 1;
      }
    }
  }

  clearFilter() {
    smsMessageListToShow = smsMessageList;
    isExpanded = [];
    searchKeywordController.clear();
    for (var item in smsMessageList) {
      isExpanded.add(false);
    }
    update();
    _expansionTileReRender();
  }

  getTextSpanLength(Sms item, String keyword) {
    return StringUtils.returnSplitLength(str: item.body!, keyword: keyword);
  }

  changeIsExpandedState(bool state, index) {
    isExpanded[index] = state;
    update();
  }

  changeIsFilteredState(bool state) {
    isFiltered = state;
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
    update();
    _expansionTileReRender();
  }

  List<String> getBodyText(Sms item, String keyword) {
    return StringUtils.split(str: item.body!, keyword: keyword);
  }

  String getTotalMonths(monthCount) {
    if (monthCount == 1) {
      return '$monthCount Month';
    }
    return '$monthCount Months';
  }

  String getTotalAmount() {
    double amount = 0.0;
    for (int i = 0; i < smsMessageListToShow.length; i++) {
      amount += smsMessageListToShow[i].amount!.toDouble();
    }

    return amount.formatThousands();
  }

  _showMessagesOnScreen(List<Sms> listToShow, bool expandAll) {
    smsMessageListToShow = listToShow;
    for (int i = 0; i < smsMessageListToShow.length; i++) {
      expandAll ? isExpanded.add(true) : isExpanded.add(false);
    }
    _emitIsLoadingState(false);
    _expansionTileReRender();
  }

  _expansionTileReRender() {
    expansionTileReRenderKey = UniqueKey();
    update();
  }

  _emitIsLoadingState(bool state) {
    isLoadingMessages = state;
    update();
  }


  /// fetch from cellphone
  /// fetch after filter with keyword
  /// fetch after filter with parameters
  fetchSmsMessages({String? keyword, Map<String, dynamic>? params}) async {
    try {
      monthCount = 0;
      smsMessageListToShow = [];
      isExpanded = [];
      fetchFailed = false;
      if ((keyword == null || keyword.removeAllWhitespace == '') && params == null) {
        await _fetchSmsMessagesFromCellphone(smsService: Fetch());
      } else if (keyword!.removeAllWhitespace.isNotEmpty) {
        _filter(keyword: keyword);
      } else if (params != null) {
        _filter(params: params);
      } else {
        showSnackBar('[DEV]', message: 'Un-managed Fetch State');
      }

    } catch (e, stacktrace) {
      fetchFailed = true;
      log(e.toString());
      log(stacktrace.toString());
      _emitIsLoadingState(false);
    }
  }

  _filter({String? keyword, Map<String, dynamic>? params}) {
    if ((keyword == null || keyword.removeAllWhitespace == '') && params == null) {
      smsMessageListToShow = smsMessageList;
    } else if (keyword != null) {
      _filterUsingKeyword(keyword);
    } else if (params != null) {
      _filterUsingParameters(params);
    }

    update();
    _expansionTileReRender();
  }

  _filterUsingKeyword(String keyword) {
    smsMessageListToShow = [];
    isExpanded = [];
    for (var item in smsMessageList) {
      if (item.body!.toLowerCase().contains(keyword.toLowerCase()) ||
          item.sender!.toLowerCase().contains(keyword.toLowerCase())) {
        smsMessageListToShow.add(item);
        isExpanded.add(true);
      }
    }
    addToMonthCount(smsMessageListToShow);
    _showMessagesOnScreen(smsMessageListToShow, true);
  }

  _filterUsingParameters(Map<String, dynamic> params) {
    // todo: remove
    log(params.toString());

    if (params['sender'] == null &&
        params['amountFrom'] == null &&
        params['amountTo'] == null &&
        params['dateFrom'] == null &&
        params['dateTo'] == null &&
        params['dateTo'] == null &&
        params['onlyTransactions'] == false) {
      isFiltered = false;
      fetchSmsMessages();
    } else {
      for (var item in smsMessageList) {
        if ((params['sender'] != null &&
                    item.sender!.toLowerCase().contains(params['sender'].toString().toLowerCase())) ||
                (params['amountFrom'] != null &&
                    params['amountTo'] == null &&
                    item.amount! >= params['amountFrom']) ||
                (params['amountFrom'] == null &&
                    params['amountTo'] != null &&
                    item.amount! <= params['amountTo']) ||
                (params['amountFrom'] != null &&
                    params['amountTo'] != null &&
                    item.amount! >= params['amountFrom'] &&
                    item.amount! <= params['amountTo']) ||
                (params['dateFrom'] != null &&
                    params['dateTo'] != null &&
                    item.date!.compareTo(params['dateFrom']) >= 0 &&
                    item.date!.compareTo(params['dateTo']) <= 0)

            // (params['onlyTransactions'] != null && item.amount! > 0.0)

            ) {
          smsMessageListToShow.add(item);
          isExpanded.add(true);
        }
      }
    }
    addToMonthCount(smsMessageListToShow);
    _showMessagesOnScreen(smsMessageListToShow, true);
  }

  _fetchSmsMessagesFromCellphone({required SmsService smsService}) async {
    smsMessageList = await smsService.fetchMessages();
    smsMessageList.convertIntoEmptyListIfNull<SmsMessage>();
    addToMonthCount(smsMessageList);
    _showMessagesOnScreen(smsMessageList, false);
  }

  _checkPermissionAndFetchMessages() async {
    bool permissionStatus = await PermissionHandler.handleSmsPermission();
    if (permissionStatus == true) {
      this.permissionStatus = Permission.granted;
      _fetchSmsMessagesFromCellphone(smsService: Fetch());
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
