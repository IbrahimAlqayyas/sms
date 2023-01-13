import 'package:flutter/material.dart';
import '../../theme/theme_constants.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({Key? key})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kBackgroundColor,
      // shadowColor: Colors.transparent,
      title: SizedBox(
        width: 75,
        child: Image.asset('assets/logo/logo.png'),
      ),
    );
  }
}
