import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';
import 'package:sales_system/shared/presentation/ui/loading_overlay.dart';
import 'package:sales_system/shared/presentation/utils/app_top_snackbar.dart';
import 'package:sales_system/src/core/constants/scaffold_key.dart';
import 'package:sales_system/src/features/authentication/domain/entities/user.dart';
import 'package:sales_system/src/features/authentication/presentation/providers/auth_provider.dart';
import 'package:sales_system/widgets/app_text_field.dart';

class LoginView extends ConsumerWidget {
  LoginView({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    // Listen for state changes to show SnackBars
    ref.listen<AsyncValue<User?>>(authControllerProvider, (previous, next) {
      // Passed as a parameter for showing the top snacknbar
      // Initially declared in Gorouter
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
    
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 500, vertical: 24),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                Icon(IconlyBold.login,
                    size: 64, color: theme.colorScheme.primary),
                const SizedBox(height: 16),
                Text('Welcome Back', style: theme.textTheme.displayMedium),
                const SizedBox(height: 8),
                Text('Login to your account', style: theme.textTheme.bodyMedium),
                const SizedBox(height: 32),
                AppTextField(
                  controller: emailController,
                  maxLines: 20,
                  label: 'Email',
                  prefixIcon: const Icon(IconlyLight.message),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                AppTextField(
                  controller: passwordController,
                  label: 'Password',
                  prefixIcon: const Icon(IconlyLight.password),
                  suffixIcon: const Icon(IconlyLight.show),
                  obscureText: true,
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('Forgot Password?'),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(authControllerProvider.notifier).login(
                            emailController.text,
                            passwordController.text
                          );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Login'),
                  ),
                ),
                // Handle State changes here
                // authState.when(
                //   data: (user) {
                //     if (user == null) {
                //       return const SizedBox();
                //     }
                //     return Text('Logged in as: ${user.name.capitalize()}');
                //   },
                //   loading: () => const LoadingIndicator(indicatorType: Indicator.ballPulse, ),
                //   error: (e, _) => Text("Error: $e"),
                // ),
              ],
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
