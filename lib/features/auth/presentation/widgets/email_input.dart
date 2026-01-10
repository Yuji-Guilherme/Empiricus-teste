import 'package:empiricus_test/core/utils/validators.dart';
import 'package:flutter/material.dart';

class EmailInput extends StatefulWidget {
  final TextEditingController controller;

  const EmailInput({super.key, required this.controller});

  @override
  State<EmailInput> createState() => _EmailInputState();
}

class _EmailInputState extends State<EmailInput> {
  final FocusNode _focusNode = FocusNode();
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      final text = widget.controller.text;

      if (text.isEmpty) {
        setState(() {
          _errorText = 'Campo obrigatório';
        });
      }

      if (text.trim().isNotEmpty && !Validators.isValidEmail(text)) {
        setState(() {
          _errorText = 'E-mail inválido';
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
      keyboardType: .emailAddress,
      textInputAction: .next,
      decoration: InputDecoration(
        labelText: 'Digite seu e-mail',
        errorText: _errorText,
      ),
      onChanged: (_) {
        if (_errorText != null) {
          setState(() {
            _errorText = null;
          });
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) return 'Campo obrigatório';
        if (!Validators.isValidEmail(value)) return 'E-mail inválido';
        return null;
      },
    );
  }
}
