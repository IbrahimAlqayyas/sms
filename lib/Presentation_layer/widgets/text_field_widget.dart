import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/theme_constants.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    Key? key,
    this.onChanged,
    this.controller,
    this.hintText,
    this.suffix,
    this.prefix,
    this.height,
    this.width,
  }) : super(key: key);
  final num? height;
  final num? width;
  final Function? onChanged;
  final TextEditingController? controller;
  final String? hintText;
  final Widget? suffix;
  final Widget? prefix;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height == null ? 50 : height!.toDouble(),
      width: width == null ? double.infinity : width!.toDouble(),
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
        onChanged: (value) => onChanged!(value),
        controller: controller,
        cursorColor: kPrimaryColor,
        cursorHeight: 20,
        textAlign: TextAlign.start,
        maxLines: 1,
        style: const TextStyle(color: kPrimaryColor),
        decoration: InputDecoration(
          fillColor: kBackgroundLighterColor,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: kGreyColor,
            height: 0.75,
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: kPrimaryColor,
              width: 1,
            ),
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: kPrimaryColor,
              width: 1,
            ),
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
          suffixIcon: suffix,
          prefixIcon: prefix,
        ),
      ),
    );
  }
}
