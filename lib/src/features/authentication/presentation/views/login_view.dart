import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_iconly_plus/flutter_iconly_plus.dart';
import 'package:sales_system/shared/presentation/ui/loading_overlay.dart';
import 'package:sales_system/shared/presentation/utils/app_top_snackbar.dart';
import 'package:sales_system/src/core/constants/scaffold_key.dart';
import 'package:sales_system/src/features/authentication/domain/entities/user.dart';
import 'package:sales_system/src/features/authentication/presentation/providers/auth_provider.dart';
import 'package:sales_system/widgets/app_text_field.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isObscure = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    // Listen for state changes to show SnackBars
    ref.listen<AsyncValue<User?>>(authControllerProvider, (previous, next) {
      final navKey = ref.read(navigatorKey);
      next.whenOrNull(
        data: (user) {
          if (user != null) {
            showAppTopSnackBar(navKey, "Login Successful! Logged in as ${user.name}");
          }
        },
        error: (error, stack) {
          showAppTopSnackBar(navKey, error.toString(), type: 'error');
        },
      );
    });
    
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: Center(
        child: Stack(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 32),
                      Icon(IconlyBold.login,
                          size: 64, color: theme.accentColor),
                      const SizedBox(height: 16),
                      Text('Welcome Back', style: theme.typography.titleLarge),
                      const SizedBox(height: 8),
                      Text('Login to your account',
                          style: theme.typography.bodyLarge),
                      const SizedBox(height: 32),
                      AppTextField(
                        controller: emailController,
                        label: 'Email',
                        prefixIcon: const Icon(IconlyLight.message),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 20),
                      AppTextField(
                        controller: passwordController,
                        label: 'Password',
                        prefixIcon: const Icon(IconlyLight.password),
                        suffixIcon: IconButton(
                          icon: Icon(
                              _isObscure ? IconlyLight.show : IconlyLight.hide),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                        obscureText: _isObscure,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) {
                          ref
                              .read(authControllerProvider.notifier)
                              .login(emailController.text, passwordController.text);
                        },
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            ref.read(authControllerProvider.notifier).login(
                                  emailController.text,
                                  passwordController.text
                                );
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text('Login'),
                          ),
                        ),
                      ),
                    ].animate(interval: 100.ms).fade(duration: 400.ms).slideY(
                        begin: 0.1, duration: 400.ms, curve: Curves.easeOutCubic),
                  ),
                ),
              ),
            ),
            if (isLoading)
              const LoadingOverlay()
          ],
        ),
      ),
    );
  }
}
