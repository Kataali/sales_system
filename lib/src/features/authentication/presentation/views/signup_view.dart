import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:sales_system/widgets/app_text_field.dart';
class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}
 
class _SignupViewState extends State<SignupView> {
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  String? _selectedGender;
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 500, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              Icon(IconlyBold.add_user, size: 64, color: theme.colorScheme.primary),
              const SizedBox(height: 16),
              Text('Create Account', style: theme.textTheme.displayMedium),
              const SizedBox(height: 8),
              Text('Sign up to get started', style: theme.textTheme.bodyMedium),
              const SizedBox(height: 32),
              const AppTextField(
                label: 'First Name',
                prefixIcon: Icon(IconlyLight.profile),
              ),
              const SizedBox(height: 20),
              const AppTextField(
                label: 'Last Name',
                prefixIcon: Icon(IconlyLight.profile),
              ),
              const SizedBox(height: 20),
              AppTextField(
                controller: _emailController,
                label: 'Email',
                prefixIcon: const Icon(IconlyLight.message),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              AppTextField(
                obscureText: _obscurePassword,
                label: 'Password',
                prefixIcon: const Icon(IconlyLight.password),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? IconlyLight.show : IconlyLight.hide),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              const SizedBox(height: 20),
              AppTextField(
                obscureText: _obscureConfirm,
                label: 'Confirm Password',
                prefixIcon: const Icon(IconlyLight.password),
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirm ? IconlyLight.show : IconlyLight.hide),
                  onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: InputDecoration(
                  labelText: 'Gender',
                  prefixIcon: const Icon(IconlyLight.user),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: const [
                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                ],
                onChanged: (val) => setState(() => _selectedGender = val),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final email = _emailController.text.trim();
                    Navigator.of(context).pushNamed(
                      '/otp',
                      arguments: email.isNotEmpty ? email : 'your email',
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Sign Up'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
