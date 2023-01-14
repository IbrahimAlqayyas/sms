import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:sms/Presentation_layer/controllers/sms_controller.dart';
import 'package:sms/theme/theme_constants.dart';
import 'package:sms/utils/date_time_parse.dart';
import 'package:sms/utils/number_formatting_extension.dart';
import '../../data_layer/models/sms.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/version_strip.dart';
import 'package:get/get.dart';

class SmsView extends StatelessWidget {
  const SmsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: const AppBarWidget(),
        bottomNavigationBar: const VersionStripWidget(),
        body: Padding(
          padding: const EdgeInsets.all(0),
          child: GetBuilder<SmsController>(
              init: SmsController(),
              builder: (controller) {
                /// Screen States:
                /// 01- Loading state
                /// 02- Permission denied state
                /// 03- Permission granted & error in fetching data state
                /// 04- Permission granted but no data state
                /// 05- Permission granted & have data state

                /// 01-Loading state
                if (controller.isLoadingMessages ?? false) {
                  return const Center(child: LoadingIndicator());
                } else {
                  /// 02- Permission denied state
                  if (controller.permissionStatus == Permission.denied) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 25),
                            child: Image.asset(
                              'assets/images/loading_error.png',
                              height: 100,
                            ),
                          ),
                          Text(
                            controller.loadingErrorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: kPrimaryColor,
                            ),
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    );
                  } else if (controller.permissionStatus == Permission.granted) {
                    /// 03- Permission granted & error in fetching data state
                    if (controller.fetchFailed!) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 25),
                              child: Image.asset(
                                'assets/images/loading_error.png',
                                height: 100,
                              ),
                            ),
                            const Text(
                              'Failed to fetch the SMS messages',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: kPrimaryColor,
                              ),
                            ),
                            const SizedBox(height: 50),
                          ],
                        ),
                      );
                    }

                    /// 04- Permission granted but no data state
                    else if (controller.smsMessageListToShow.isEmpty && controller.smsMessageList.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 25),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(17),
                                child: Image.asset(
                                  'assets/gif/flip_book.gif',
                                  height: 150,
                                ),
                              ),
                            ),
                            const Text(
                              'You don\'t have any messages yet.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 50),
                          ],
                        ),
                      );
                    }

                    /// 05- Permission granted & have data state
                    else if (controller.smsMessageList.isNotEmpty) {
                      return SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              decoration: const BoxDecoration(
                                color: kBackgroundColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: kShadowColor,
                                    blurRadius: 4,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      /// Search field
                                      Container(
                                        height: 50,
                                        width: Get.width - 90,
                                        decoration: BoxDecoration(
                                          // color: kBackgroundColor,
                                          borderRadius: BorderRadius.circular(14),
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
                                        child: TextFormField(
                                          onChanged: (keyword) {
                                            if (keyword.removeAllWhitespace.isNotEmpty) {
                                              controller.filter(keyword);
                                            } else {
                                              controller.clearFilter();
                                            }
                                          },
                                          controller: controller.searchFieldController,
                                          cursorColor: kPrimaryColor,
                                          cursorHeight: 20,
                                          textAlign: TextAlign.start,
                                          maxLines: 1,
                                          style: const TextStyle(color: kPrimaryColor),
                                          decoration: const InputDecoration(
                                            hintText: 'Search ..',
                                            hintStyle: TextStyle(
                                              color: kGreyColor,
                                              height: 0.75,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: kPrimaryColor,
                                                width: 1,
                                              ),
                                              borderRadius: BorderRadius.all(Radius.circular(14)),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: kPrimaryColor,
                                                width: 1,
                                              ),
                                              borderRadius: BorderRadius.all(Radius.circular(14)),
                                            ),
                                            suffixIcon: Icon(
                                              Icons.search,
                                              color: kPrimaryColor,
                                            ),
                                          ),
                                        ),
                                      ),

                                      /// Filter button
                                      Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: kPrimaryColor,
                                          borderRadius: BorderRadius.circular(14),
                                          border: Border.all(
                                            color: kPrimaryColor,
                                            width: 1,
                                          ),
                                        ),
                                        child: IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.tune,
                                            color: kBackgroundColor,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  /// Checkboxes
                                  ///
                                  ///
                                ],
                              ),
                            ),

                            /// SMS messages list
                            Padding(
                              padding: const EdgeInsets.only(top: 9),
                              child: Container(
                                height: Get.height - 290,
                                decoration: const BoxDecoration(
                                  color: kBackgroundColor,
                                ),
                                child: ListView.builder(
                                  itemCount: controller.smsMessageListToShow.length,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    List<Sms> listToShow = controller.smsMessageListToShow;
                                    Sms item = listToShow[index];
                                    Sms prevItem = index > 0 ? listToShow[index - 1] : item;
                                    bool isExpanded = controller.isExpanded[index];
                                    // Color color = (colorSwatch..shuffle()).first;
                                    // Color color = kPrimaryColor;
                                    Color backColor = kBackgroundColor;
                                    Color textColor = kPrimaryColor;

                                    return Column(
                                      children: [
                                        if (index == 0 ||
                                            index > 0 && item.date?.month != prevItem.date?.month)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 8),
                                            child: Text(
                                              DateTimeParse.parseDateTimeReturnMonthString(
                                                      item.date.toString())
                                                  .toString()
                                                  .toUpperCase(),
                                              style: const TextStyle(
                                                color: kPrimaryColor,
                                                fontSize: kBodyFontSize,
                                              ),
                                            ),
                                          ),

                                        /// SMS item
                                        Container(
                                          margin: const EdgeInsets.only(bottom: 8, right: 8, left: 8),
                                          decoration: BoxDecoration(
                                            color: backColor,
                                            borderRadius: BorderRadius.circular(14),
                                            // borderRadius: BorderRadius.only(
                                            //   bottomLeft: Radius.circular(14),
                                            //   bottomRight: Radius.circular(14),
                                            // ),
                                            border: Border.all(
                                              color: kPrimaryColor,
                                              width: 1,
                                            ),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: kShadowColor,
                                                blurRadius: 4,
                                                spreadRadius: 1,
                                                offset: Offset(0, 0),
                                              ),
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(13),
                                            child: ExpansionTile(
                                              collapsedBackgroundColor: kBackgroundColor,
                                              collapsedIconColor: kPrimaryColor,
                                              collapsedTextColor: kPrimaryColor,
                                              textColor: textColor,
                                              backgroundColor: kPrimaryColor,
                                              initiallyExpanded: controller.isExpanded[index],
                                              // initiallyExpanded: true,
                                              onExpansionChanged: (state) {
                                                controller.changeIsExpandedState(state, index);
                                              },
                                              maintainState: true,
                                              title: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item.sender!,
                                                    style: TextStyle(
                                                      fontSize: kBodyFontSize,
                                                      color: isExpanded ? kBackgroundColor : textColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${item.amount!.formatThousands()} AED',
                                                    style: TextStyle(
                                                      fontSize: kBodyFontSize,
                                                      color: isExpanded ? kBackgroundColor : textColor,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              trailing: Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    DateTimeParse.parseDateTimeReturnDateString(
                                                      item.date.toString(),
                                                    ),
                                                    style: TextStyle(
                                                      fontSize: kBodyFontSize,
                                                      color: isExpanded ? kBackgroundColor : textColor,
                                                    ),
                                                  ),
                                                  Icon(
                                                    controller.isExpanded[index]
                                                        ? Icons.keyboard_arrow_up
                                                        : Icons.keyboard_arrow_down,
                                                    color: isExpanded ? kBackgroundColor : textColor,
                                                  ),
                                                ],
                                              ),
                                              children: [
                                                Container(
                                                  width: double.infinity,
                                                  padding: const EdgeInsets.all(8),
                                                  decoration: const BoxDecoration(
                                                    color: kBackgroundColor,
                                                    borderRadius: BorderRadius.only(
                                                      bottomLeft: Radius.circular(10),
                                                      bottomRight: Radius.circular(10),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        item.body!,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: kBodyFontSize,
                                                          color: textColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),

                            /// Totalling
                            Container(
                              decoration: const BoxDecoration(
                                color: kBackgroundColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: kShadowColor,
                                    blurRadius: 4,
                                    offset: Offset(0, -4),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Total',
                                          style: TextStyle(
                                            fontSize: kTitleFontSize,
                                            color: kPrimaryColor,
                                          ),
                                        ),
                                        Text(
                                          '${controller.smsMessageListToShow.length} Messages',
                                          style: const TextStyle(
                                            fontSize: kBodyFontSize,
                                            color: kPrimaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${controller.getTotalAmount()} AED',
                                          style: const TextStyle(
                                            fontSize: kBodyFontSize,
                                            color: kPrimaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          controller.getTotalMonths(),
                                          style: const TextStyle(
                                            fontSize: kBodyFontSize,
                                            color: kPrimaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                }
                return const Center(
                  child: Text('[DEV]: un-managed state', style: TextStyle(
                    color: kWhiteColor,
                  ),)
                );
              }),
        ),
      ),
    );
  }
}
