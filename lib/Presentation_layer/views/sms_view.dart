import 'package:flutter/material.dart';
import 'package:sms/Presentation_layer/controllers/sms_controller.dart';
import 'package:sms/theme/theme_constants.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/version_strip.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';

class SmsView extends StatelessWidget {
  const SmsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchFieldController = TextEditingController();

    return Material(
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: const AppBarWidget(),
        bottomNavigationBar: const VersionStripWidget(),
        body: Padding(
          padding: const EdgeInsets.all(16),
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
                    else if (controller.smsMessageList.isEmpty) {
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
                      return Column(
                        children: [
                          // /// Search field
                          // TextFormField(
                          //   controller: searchFieldController,
                          //   decoration: const InputDecoration(
                          //     suffixIcon: Icon(Icons.search),
                          //   ),
                          // ),
                          //
                          // /// Checkboxes
                          //
                          //
                          // /// SMS messages list
                          // ListView.builder(),
                        ],
                      );
                    }
                  }
                }
                return Container();
              }),
        ),
      ),
    );
  }
}
