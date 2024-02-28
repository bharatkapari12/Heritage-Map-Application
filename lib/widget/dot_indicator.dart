import 'package:flutter/material.dart';
class Dotindicator extends StatelessWidget {
  const Dotindicator({
    Key? key,
    this.isActive = false,
  }) : super(key: key);
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 10,
      backgroundColor: Colors.white,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 15,
        width: 15,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              color: isActive ? Colors.black : Colors.white, width: 2.5),
          color: Colors.white,
        ),
      ),
    );
  }
}