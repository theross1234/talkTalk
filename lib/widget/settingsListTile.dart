import 'dart:io';

import 'package:flutter/material.dart';

class Settingslisttile extends StatelessWidget {
  const Settingslisttile({
    super.key,
    required this.title,
    required this.onTap,
    required this.icon,
    required this.IconColor,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final Color IconColor;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      leading: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: IconColor,
          ),
          child: Icon(
            icon,
            color: Colors.white,
          )),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      trailing: Icon(Platform.isAndroid
          ? Icons.arrow_forward_ios
          : Icons.arrow_forward_ios_outlined),
    );
  }
}
