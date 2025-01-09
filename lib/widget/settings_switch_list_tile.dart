import 'package:flutter/material.dart';

class SettingsSwitchListTile extends StatelessWidget {
  const SettingsSwitchListTile({
    super.key,
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.containerColor,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subTitle;
  final IconData icon;
  final Color containerColor;
  final bool value;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subTitle),
      value: value,
      secondary: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: containerColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        //color: containerColor,
      ),
      onChanged: (value) {
        onChanged(value);
      },
    );
  }
}
