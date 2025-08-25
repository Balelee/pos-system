import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowDialog {
  static Future<bool?> showdialog({
    required Widget title,
    required Widget content,
    required Widget cancelButton,
    required Widget actionButton,
  }) {
    return showDialog<bool>(
      context: Get.context!,
      builder: (_) => AlertDialog(
        title: title,
        content: content,
        actions: [
          actionButton,
          cancelButton,
        ],
      ),
    );
  }
}
