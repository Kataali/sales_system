import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';
import 'package:sales_system/shared/presentation/ui/loading_overlay.dart';
import 'package:sales_system/shared/presentation/utils/app_top_snackbar.dart';
import 'package:sales_system/src/core/constants/scaffold_key.dart';
import 'package:sales_system/src/features/authentication/presentation/providers/auth_provider.dart';
import 'package:sales_system/widgets/app_text_field.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sales_system/src/features/authentication/domain/entities/user.dart';

class ChangePasswordView extends ConsumerStatefulWidget {
  const ChangePasswordView({super.key});

  @override
  ConsumerState<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends ConsumerState<ChangePasswordView> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    final navKey = ref.read(navigatorKey);
    if (_newPasswordController.text != _confirmPasswordController.text) {
      showAppTopSnackBar(navKey, 'Passwords do not match', type: 'error');
      return;
    }

    if (_currentPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty) {
      showAppTopSnackBar(navKey, 'Please fill in all fields', type: 'error');
      return;
    }

    ref.read(authControllerProvider.notifier).changePassword(
          _currentPasswordController.text,
          _newPasswordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    ref.listen<AsyncValue<User?>>(authControllerProvider, (previous, next) {
      final navKey = ref.read(navigatorKey);
      next.whenOrNull(
        data: (user) {
          if (previous?.isLoading == true) {
            showAppTopSnackBar(navKey, 'Password updated successfully');
            context.go('/login');
          }
        },
        error: (e, _) {
          showAppTopSnackBar(navKey, e.toString(), type: 'error');
        },
      );
    });

    return ScaffoldPage(
      header: PageHeader(
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: IconButton(
            icon: const Icon(FluentIcons.back),
            onPressed: () => context.pop(),
          ),
        ),
        title: const Text('Change Password'),
      ),
      content: Stack(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 32),
                    Icon(IconlyBold.password,
                        size: 64, color: theme.accentColor),
                    const SizedBox(height: 16),
                    Text('Reset Security', style: theme.typography.titleLarge),
                    const SizedBox(height: 8),
                    Text('Update your account password',
                        style: theme.typography.bodyLarge),
                    const SizedBox(height: 32),
                    _PasswordField(
                      controller: _currentPasswordController,
                      label: 'Current Password',
                    ),
                    const SizedBox(height: 20),
                    _PasswordField(
                      controller: _newPasswordController,
                      label: 'New Password',
                    ),
                    const SizedBox(height: 20),
                    _PasswordField(
                      controller: _confirmPasswordController,
                      label: 'Confirm New Password',
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: isLoading ? null : _submit,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text('Update Password'),
                        ),
                      ),
                    ),
                  ].animate(interval: 100.ms).fade(duration: 400.ms).slideY(
                      begin: 0.1, duration: 400.ms, curve: Curves.easeOutCubic),
                ),
              ),
            ),
          ),
          if (isLoading) const LoadingOverlay(),
        ],
      ),
    );
  }
}

class _PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String label;

  const _PasswordField({required this.controller, required this.label});

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: widget.controller,
      label: widget.label,
      prefixIcon: const Icon(IconlyLight.password),
      obscureText: _isObscure,
      suffixIcon: IconButton(
        icon: Icon(_isObscure ? IconlyLight.show : IconlyLight.hide),
        onPressed: () => setState(() => _isObscure = !_isObscure),
      ),
    );
  }
}
