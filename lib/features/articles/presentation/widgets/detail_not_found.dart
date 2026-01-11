import 'package:empiricus_test/core/components/error_button.dart';
import 'package:empiricus_test/core/components/error_icon_widget.dart';
import 'package:empiricus_test/core/theme/app_colors.dart';
import 'package:empiricus_test/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DetailNotFound extends StatelessWidget {
  const DetailNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const .all(32.0),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            ErrorIconWidget(icon: Icons.search_off_rounded),
            const SizedBox(height: 24),
            const Text(
              'Ops! Artigo não encontrado.',
              textAlign: .center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: .bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'O link que você tentou acessar pode estar quebrado ou o artigo foi removido.',
              textAlign: .center,
              style: AppTypography.secondaryText.copyWith(height: 1.5),
            ),
            const SizedBox(height: 28),
            ErrorButton(
              onPress: () => context.go('/'),
              icon: Icons.home_filled,
              text: 'Voltar para o Início',
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
