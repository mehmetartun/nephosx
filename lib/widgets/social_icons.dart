import 'package:flutter/material.dart';

class GoogleIcon extends StatelessWidget {
  final TextStyle? iconStyle;
  const GoogleIcon({super.key, this.iconStyle});

  @override
  Widget build(BuildContext context) {
    return Text(
      "\uF1A0",
      style: iconStyle == null
          ? TextStyle(fontFamily: "SocialIcons", fontSize: 24)
          : iconStyle!.copyWith(fontFamily: "SocialIcons"),
    );
  }
}

class AppleIcon extends StatelessWidget {
  final TextStyle? iconStyle;
  const AppleIcon({super.key, this.iconStyle});

  @override
  Widget build(BuildContext context) {
    return Text(
      "\uF179",
      style: iconStyle == null
          ? TextStyle(fontFamily: "SocialIcons", fontSize: 24)
          : iconStyle!.copyWith(fontFamily: "SocialIcons"),
    );
  }
}
