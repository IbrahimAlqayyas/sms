import 'package:flutter/material.dart';
import '../theme/theme_constants.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({Key? key, this.actions})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  final List<Widget>? actions;
  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kBackgroundColor,
      shadowColor: Colors.transparent,
      actions: actions,
      title: SizedBox(
        width: 80,
        child: Image.asset('assets/logo/logo.png'),
      ),
    );
  }
}
