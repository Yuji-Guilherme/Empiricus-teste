import 'package:flutter/material.dart';

class ErrorButton extends StatelessWidget {
  final VoidCallback onPress;
  final IconData icon;
  final String text;
  final bool? isLoading;

  const ErrorButton({
    super.key,
    required this.onPress,
    required this.icon,
    required this.text,
    this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 250,
      child: FilledButton(
        onPressed: onPress,
        child: isLoading ?? false
            ? Row(
                mainAxisSize: .min,
                children: [
                  const SizedBox(
                    height: 12,
                    width: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('Carregando...'),
                ],
              )
            : FittedBox(
                fit: .scaleDown,
                child: Row(
                  mainAxisSize: .min,
                  children: [Icon(icon), const SizedBox(width: 8), Text(text)],
                ),
              ),
      ),
    );
  }
}
