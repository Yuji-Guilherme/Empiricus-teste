import 'package:empiricus_test/core/di/service_locator.dart';
import 'package:empiricus_test/core/theme/app_colors.dart';
import 'package:empiricus_test/core/utils/validators.dart';
import 'package:empiricus_test/features/auth/presentation/cubit/login_cubit.dart';
import 'package:empiricus_test/features/auth/presentation/widgets/email_input.dart';
import 'package:empiricus_test/features/auth/presentation/widgets/login_button.dart';
import 'package:empiricus_test/features/auth/presentation/widgets/password_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LoginCubit>(),
      child: const _LoginForm(),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final ValueNotifier<bool> _isFormValid = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();

    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final isValid =
        Validators.isValidEmail(email) && Validators.isValidPassword(password);

    if (_isFormValid.value != isValid) _isFormValid.value = isValid;
  }

  void _submitLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (Validators.isValidEmail(email) &&
        Validators.isValidPassword(password)) {
      FocusScope.of(context).unfocus();
      context.read<LoginCubit>().loginSubmitted(
        email: _emailController.text,
        password: _passwordController.text,
      );
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message, style: TextStyle(fontWeight: .bold)),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  void dispose() {
    _emailController.removeListener(_validateForm);
    _passwordController.removeListener(_validateForm);
    _emailController.dispose();
    _passwordController.dispose();
    _isFormValid.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) _showSnackbar(state.message);
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  Text(
                    'Acesse sua conta',
                    style: TextStyle(
                      fontWeight: .bold,
                      color: AppColors.contrast,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 32),
                  EmailInput(controller: _emailController),
                  const SizedBox(height: 16),
                  PasswordInput(
                    controller: _passwordController,
                    onSubmitted: _submitLogin,
                  ),
                  const SizedBox(height: 32),
                  LoginButton(
                    isValidNotifier: _isFormValid,
                    isLoading: state is LoginLoading,
                    onPressed: _submitLogin,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
