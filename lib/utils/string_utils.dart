import 'dart:developer';
import 'package:get/get.dart';

class StringUtils {
  static List<String> split({required String str, required String keyword}) {
    List<String> splitStrings = [];
    str = str.toLowerCase();
    keyword = keyword.toLowerCase();

    /// split string to list<string>
    for (int i = 0; i < str.split(keyword).length; i++) {
      splitStrings.add(str.split(keyword)[i]);
    }

    /// declare new list<string>
    List<String> stringListWithoutEmptyItems = [];

    /// concatenate all the items with the keyword except the conditions
    for (int i = 0; i < splitStrings.length; i++) {
      stringListWithoutEmptyItems.addIf(splitStrings[i].isNotEmpty, splitStrings[i]);
    }

    /// Declare the return list
    List<String> returnListOfStrings = [];

    /// Add all the items concatenated with the keyword
    for (int i = 0; i < stringListWithoutEmptyItems.length; i++) {
      returnListOfStrings.add(stringListWithoutEmptyItems[i]);
      returnListOfStrings.addIf(i < stringListWithoutEmptyItems.length - 1, keyword);
    }

    /// add the keyword in the beginning and the ending if the original list has these items in the beginning and ni the last
    if (splitStrings.first.isEmpty) returnListOfStrings.insert(0, keyword);
    if (splitStrings.last.isEmpty) returnListOfStrings.add(keyword);

    return returnListOfStrings;
  }

  static returnSplitLength({required String str, required String keyword}) {
    return split(str: str, keyword: keyword).length;
  }
}
