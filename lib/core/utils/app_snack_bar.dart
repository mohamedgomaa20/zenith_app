import 'package:flutter/material.dart';

class AppSnackBar {
  static void success(BuildContext context, String message) {
    show(
      context: context,
      message: message,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      icon: Icons.check_circle_outline,
    );
  }

  static void error(BuildContext context, String message) {
    show(
      context: context,
      message: message,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      icon: Icons.error_outline,
    );
  }

  static void warning(BuildContext context, String message) {
    show(
      context: context,
      message: message,
      backgroundColor: Colors.orange,
      textColor: Colors.black,
      icon: Icons.warning_amber_rounded,
    );
  }

  static void show({
    required BuildContext context,
    required String message,
    Color backgroundColor = const Color(0xff282828),
    Color textColor = const Color(0xff6D6D6D),
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
  }) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(

        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(top: 20,right: 20,left: 20,bottom: MediaQuery.of(context).size.height - 160,),
        dismissDirection: DismissDirection.horizontal,
        duration: duration,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: textColor),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(message, style: TextStyle(color: textColor)),
            ),
          ],
        ),
      ),
    );
  }
}
