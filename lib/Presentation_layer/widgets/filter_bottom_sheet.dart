import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sms/Presentation_layer/widgets/text_field_widget.dart';
import '../theme/theme_constants.dart';

showFilterBottomSheet({required Function onFilter}) {
  return Get.bottomSheet(
    ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: Get.height * 0.9,
      ),
      child: FilterBottomSheet(onFilter: onFilter),
    ),
    isScrollControlled: true,
    enableDrag: true,
    isDismissible: true,
    enterBottomSheetDuration: const Duration(milliseconds: 800),
  );
}

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key, this.onFilter});
  final Function? onFilter;
  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  TextEditingController sender = TextEditingController();
  TextEditingController amountFrom = TextEditingController();
  TextEditingController amountTo = TextEditingController();
  DateTime? dateFrom;
  String? dateFromString = 'Select ..';
  String? dateToString = 'Select ..';
  DateTime? dateTo;
  bool onlyTransactions = false;

  getDateFrom(context) async {
    showDatePickerWidget(context, type: DatePickerType.from).then((value) {
      _updateDateFrom(value);
    });
  }

  getDateTo(context) {
    showDatePickerWidget(context, type: DatePickerType.to).then((value) {
      _updateDateTo(value);
    });
  }

  _updateDateFrom(DateTime? date) {
    setState(() {
      dateFrom = date;
      date == null
          ? dateFromString = 'Select ..'
          : dateFromString = '${date.day} / ${date.month} / ${date.year}';
    });
  }

  _updateDateTo(DateTime? date) {
    setState(() {
      dateTo = date;
      date == null ? dateToString = 'Select ..' : dateToString = '${date.day} / ${date.month} / ${date.year}';
    });
  }

  /// Date From-To Interlock Methods
  getInitialDate(type) {
    DateTime? returnDate;
    if (type == DatePickerType.from) {
      dateTo == null ? returnDate = DateTime.now() : returnDate = dateTo;
    } else if (type == DatePickerType.to) {
      returnDate = DateTime.now();
    }
    return returnDate;
  }

  getFirstDate(type) {
    DateTime? returnDate;
    if (type == DatePickerType.from) {
      returnDate = DateTime(2000);
    } else if (type == DatePickerType.to) {
      dateFrom == null ? returnDate = DateTime(2000) : returnDate = dateFrom;
    }
    return returnDate;
  }

  getLastDate(type) {
    DateTime? returnDate;
    if (type == DatePickerType.from) {
      dateTo == null ? returnDate = DateTime.now() : returnDate = dateTo;
    } else if (type == DatePickerType.to) {
      returnDate = DateTime.now();
    }
    return returnDate;
  }

  showDatePickerWidget(context, {DatePickerType? type}) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now(),
      locale: const Locale.fromSubtags(countryCode: 'ae'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.dark(
            primary: kPrimaryColor,
            onPrimary: kBackgroundColor,
            surface: kBackgroundLighterColor,
            onSurface: kBlackColor,
          )),
          child: DatePickerDialog(
            initialDate: getInitialDate(type),
            firstDate: getFirstDate(type),
            lastDate: getLastDate(type),
          ),
        );
      },
    );

    return date;
  }

  @override
  Widget build(BuildContext context) {
    double spacing = 16.0;
    double txtSizedBoxWidth = 100.0;
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: kBackgroundLighterColor,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(14),
            topLeft: Radius.circular(14),
          ),
          boxShadow: const [
            BoxShadow(
              color: kShadowColor,
              blurRadius: 4,
              spreadRadius: 1,
              offset: Offset(0, -3),
            ),
          ],
          border: Border.all(
            color: kPrimaryColor.withOpacity(0.15),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              height: 3,
              width: 50,
              decoration: BoxDecoration(
                color: kGreyColor.withOpacity(0.4),
                borderRadius: BorderRadius.circular(2),
                boxShadow: [
                  BoxShadow(color: kShadowColor.withOpacity(0.2), blurRadius: 4, spreadRadius: 1),
                ],
              ),
            ),
            const Text(
              'Choose Filter Parameters',
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: kTitleFontSize,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
              decoration: const BoxDecoration(
                color: kBackgroundColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(14),
                  topLeft: Radius.circular(14),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      /// Sender
                      SizedBox(
                        width: txtSizedBoxWidth,
                        child: const Text(
                          'Sender',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: kTitleFontSize,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width - 200,
                        child: TextFieldWidget(
                          controller: sender,
                          hintText: 'Sender ..',
                          onChanged: (String keyword) {
                            if (keyword.removeAllWhitespace.isNotEmpty) {
                              //   controller.filter(keyword: keyword);
                              // } else {
                              //   controller.clearFilter();
                            }
                          },
                          suffix: const Icon(
                            Icons.person,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: kBodyFontSize,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: spacing),

                  /// Amount From
                  Row(
                    children: [
                      SizedBox(
                        width: txtSizedBoxWidth,
                        child: const Text(
                          'Amount from',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: kTitleFontSize,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width - 200,
                        child: TextFieldWidget(
                          height: 50,
                          controller: amountFrom,
                          hintText: '0.0',
                          onChanged: (String keyword) {
                            if (keyword.removeAllWhitespace.isNotEmpty) {
                              //   controller.filter(keyword: keyword);
                              // } else {
                              //   controller.clearFilter();
                            }
                          },
                          suffix: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                            child: Text(
                              'AED',
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: kBodyFontSize,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: spacing),

                  /// Amount To
                  Row(
                    children: [
                      SizedBox(
                        width: txtSizedBoxWidth,
                        child: const Text(
                          'Amount to',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: kTitleFontSize,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width - 200,
                        child: TextFieldWidget(
                          controller: amountTo,
                          hintText: '0.0',
                          onChanged: (String keyword) {
                            if (keyword.removeAllWhitespace.isNotEmpty) {
                              //   controller.filter(keyword: keyword);
                              // } else {
                              //   controller.clearFilter();
                            }
                          },
                          suffix: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                            child: Text(
                              'AED',
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: kBodyFontSize,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: spacing),

                  /// DateFrom
                  Row(
                    children: [
                      SizedBox(
                        width: txtSizedBoxWidth,
                        child: const Text(
                          'Date from',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: kTitleFontSize,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      InkWell(
                        onTap: () => getDateFrom(context),
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width - 200,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            // color: kBackgroundColor,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: kPrimaryColor,
                              width: 1,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: kShadowColor,
                              ),
                              BoxShadow(
                                color: kBackgroundColor,
                                spreadRadius: -6.0,
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                dateFromString!,
                                style: const TextStyle(
                                  color: kGreyColor,
                                  height: 1.4,
                                ),
                              ),
                              const Icon(
                                Icons.date_range,
                                color: kPrimaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: kBodyFontSize,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: spacing),

                  /// Date To
                  Row(
                    children: [
                      SizedBox(
                        width: txtSizedBoxWidth,
                        child: const Text(
                          'Date to',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: kTitleFontSize,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      InkWell(
                        onTap: () => getDateTo(context),
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width - 200,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            // color: kBackgroundColor,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: kPrimaryColor,
                              width: 1,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: kShadowColor,
                              ),
                              BoxShadow(
                                color: kBackgroundColor,
                                spreadRadius: -6.0,
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                dateToString!,
                                style: const TextStyle(
                                  color: kGreyColor,
                                  height: 1.4,
                                ),
                              ),
                              const Icon(
                                Icons.date_range,
                                color: kPrimaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: kBodyFontSize,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: spacing),

                  /// Transaction Switch
                  Row(
                    children: [
                      SizedBox(
                        width: txtSizedBoxWidth,
                        child: const Text(
                          'Transactions',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: kTitleFontSize,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      CupertinoSwitch(
                        value: onlyTransactions,
                        activeColor: kPrimaryColor,
                        onChanged: (value) {
                          setState(() {
                            onlyTransactions = value;
                          });
                        },
                      ),
                    ],
                  ),

                  /// Apply Button
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    height: 45,
                    width: 150,
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: kPrimaryColor,
                        width: 1,
                      ),
                    ),
                    child: IconButton(
                        onPressed: () {
                          Map<String, dynamic> params;
                          params = {
                            'sender': sender.text.isNotEmpty ? sender.text : null,
                            'onlyTransactions': onlyTransactions,
                            'amountFrom': amountFrom.text.isNotEmpty ? double.parse(amountFrom.text) : null,
                            'amountTo': amountTo.text.isNotEmpty ? double.parse(amountTo.text) : null,
                            'dateFrom': dateFrom,
                            'dateTo': dateTo,
                          };
                          Get.back(result: params);
                          widget.onFilter!(params);
                        },
                        icon: const Text(
                          'Apply',
                          style: TextStyle(
                            color: kBackgroundColor,
                            fontSize: kTitleFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum DatePickerType {
  from,
  to,
}
