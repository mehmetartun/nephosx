import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

Future<T?> showResponsiveBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
}) {
  if (kIsWeb) {
    return showDialog<T>(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (context) =>
          MaxWidthBox(maxWidth: 700, child: Dialog(child: builder(context))),
    );
  } else {
    return showModalBottomSheet<T>(
      isDismissible: barrierDismissible,
      context: context,
      builder: (context) => builder(context),
    );
  }
}
