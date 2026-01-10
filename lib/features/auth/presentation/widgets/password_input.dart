import 'package:empiricus_test/core/utils/validators.dart';
import 'package:flutter/material.dart';

class PasswordInput extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback? onSubmitted;

  const PasswordInput({super.key, required this.controller, this.onSubmitted});

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  final FocusNode _focusNode = FocusNode();
  String? _errorText;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      final text = widget.controller.text.trim();

      if (text.isNotEmpty && !Validators.isValidPassword(text)) {
        setState(() {
          _errorText = 'Mínimo 6 caracteres';
        });
      } else if (text.isEmpty) {
        setState(() {
          _errorText = 'Campo obrigatório';
        });
      }
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      obscureText: _obscureText,
      textInputAction: .done,
      decoration: InputDecoration(
        labelText: 'Digite sua senha',
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () => setState(() => _obscureText = !_obscureText),
        ),
        errorText: _errorText,
      ),
      onFieldSubmitted: (_) {
        if (widget.onSubmitted != null) widget.onSubmitted!();
      },
      onChanged: (value) {
        if (_errorText != null) {
          setState(() {
            _errorText = null;
          });
        }
      },
    );
  }
}
