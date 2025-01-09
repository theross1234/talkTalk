import 'package:chatchat/enums/enums.dart';
import 'package:flutter/material.dart';

class Grouptypelisttile extends StatelessWidget {
  Grouptypelisttile({
    super.key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });
  final String title;
  GroupType value;
  GroupType? groupValue;
  final Function(GroupType?) onChanged;

  @override
  Widget build(BuildContext context) {
    final capitaltitle = title[0].toUpperCase() + title.substring(1);
    return RadioListTile<GroupType>(
        title: Text(capitaltitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            )),
        value: value,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        tileColor: Colors.grey.withOpacity(0.7),
        contentPadding: EdgeInsets.zero,
        groupValue: groupValue,
        onChanged: onChanged);
  }
}
