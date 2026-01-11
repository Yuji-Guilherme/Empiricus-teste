import 'package:empiricus_test/core/di/service_locator.dart';
import 'package:empiricus_test/core/theme/app_colors.dart';
import 'package:empiricus_test/core/theme/app_typography.dart';
import 'package:empiricus_test/core/utils/app_alert.dart';
import 'package:empiricus_test/core/utils/validators.dart';
import 'package:empiricus_test/features/auth/presentation/bloc/login_cubit.dart';
import 'package:empiricus_test/features/auth/presentation/widgets/email_input.dart';
import 'package:empiricus_test/features/auth/presentation/widgets/login_button.dart';
import 'package:empiricus_test/features/auth/presentation/widgets/password_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  final String? redirectUrl;

  const LoginPage({super.key, this.redirectUrl});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LoginCubit>(),
      child: _LoginForm(redirectUrl: redirectUrl),
    );
  }
}

class _LoginForm extends StatefulWidget {
  final String? redirectUrl;

  const _LoginForm({this.redirectUrl});

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
      context.read<LoginCubit>().loginSubmitted(
        email: _emailController.text,
        password: _passwordController.text,
      );
    }
  }

  void _onLoginSuccess() {
    FocusScope.of(context).unfocus();
    debugPrint(widget.redirectUrl);
    if (widget.redirectUrl == null) return context.go('/');

    context.go(widget.redirectUrl!);
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
      listener: (_, state) {
        if (state is LoginFailure) {
          AppAlert.show(context, state.message, type: .error);
        }
        if (state is LoginSuccess) _onLoginSuccess();
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    SvgPicture.asset(
                      'assets/images/logotype.svg',
                      height: 36,
                      fit: .fitHeight,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Acesse sua conta',
                      style: AppTypography.subtitle.copyWith(
                        color: AppColors.contrast,
                      ),
                    ),
                    const SizedBox(height: 16),
                    EmailInput(controller: _emailController),
                    const SizedBox(height: 16),
                    PasswordInput(
                      controller: _passwordController,
                      onSubmitted: _submitLogin,
                    ),
                    const SizedBox(height: 24),
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
          ),
        );
      },
    );
  }
}
