import 'package:flutter/material.dart';

class ErrorButton extends StatelessWidget {
  final VoidCallback onPress;
  final IconData icon;
  final String text;

  const ErrorButton({
    super.key,
    required this.onPress,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: FilledButton.icon(
        onPressed: onPress,
        icon: Icon(icon),
        label: Text(text),
      ),
    );
  }
}
