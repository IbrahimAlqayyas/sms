import 'package:flutter/material.dart';
import '../../theme/theme_constants.dart';
import '../../utils/constants.dart';

class VersionStripWidget extends StatelessWidget {
  const VersionStripWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      width: double.infinity,
      color: kPrimaryColor,
      child: const Align(
        alignment: Alignment.center,
        child: Text(
          kVersion,
          style: TextStyle(
              // fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
