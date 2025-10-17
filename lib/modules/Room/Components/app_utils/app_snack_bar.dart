import 'package:flutter/material.dart';
import 'package:get/get.dart';

showSnackBarWidget({
  required String message,
  Color color = Colors.red,
  Color textColor = Colors.white,
  SnackPosition? snackPosition,
  int? second,
}) {
  return Get.showSnackbar(
    GetSnackBar(
      messageText: Text(
        message,
        style: Get.textTheme.bodyMedium!.copyWith(
          color: textColor,
          fontSize: 14,
        ),
      ),
      duration: Duration(seconds: second ?? 3),
      backgroundColor: color,
      snackStyle: SnackStyle.FLOATING,
      snackPosition: snackPosition ?? SnackPosition.BOTTOM,
    ),
  );
}

showAppLoadingDialog({bool barrierDismissible = false}) {
  Get.dialog(
    Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: PopScope(
        canPop: barrierDismissible,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    ),
    barrierDismissible: barrierDismissible,
  );
}
