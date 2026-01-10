import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final ValueNotifier<bool> isValidNotifier;
  final bool isLoading;
  final VoidCallback onPressed;

  const LoginButton({
    super.key,
    required this.isValidNotifier,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ValueListenableBuilder<bool>(
        valueListenable: isValidNotifier,
        builder: (context, isValid, _) {
          return FilledButton(
            onPressed: (isValid && !isLoading) ? onPressed : null,
            child: isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('ENTRAR'),
          );
        },
      ),
    );
  }
}
