import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

class Toast {
  static void toast({
    Widget? title,
    String? description,
    Color? primaryColor,
    ToastificationType? type,
    ToastificationStyle? style,
    void Function(ToastificationItem)? onTap,
    void Function(ToastificationItem)? onCloseButtonTap,
    AlignmentGeometry? alignment,
  }) {
    toastification.show(
      context: Get.context,
      type: type,
      style: style,
      autoCloseDuration: const Duration(seconds: 3),
      title: title,
      description: RichText(
        text: TextSpan(
          text: description,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      alignment: alignment ?? Alignment.topRight,
      direction: TextDirection.ltr,
      showIcon: true,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        )
      ],
      callbacks: ToastificationCallbacks(
        onTap: onTap,
        onCloseButtonTap: onCloseButtonTap,
      ),
      showProgressBar: false,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
    );
  }
}
