import 'dart:io';

import 'package:chatchat/utils/assetManager.dart';
import 'package:flutter/material.dart';

class Displayuserimage extends StatelessWidget {
  const Displayuserimage({
    super.key,
    required this.finalfileImage,
    required this.radius,
    required this.onTap,
  });

  final File? finalfileImage;
  final double radius;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return finalfileImage == null
        ? Stack(
            children: [
              CircleAvatar(
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                radius: radius,
                backgroundImage:
                    const AssetImage(AssetsManager.userDefaultIcon2),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: onTap,
                  child: const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.add,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
              )
            ],
          )
        : Stack(
            children: [
              CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  radius: 50,
                  backgroundImage: FileImage(File(finalfileImage!.path))),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: onTap,
                  child: const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.add,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
              )
            ],
          );
  }
}
