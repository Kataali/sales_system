import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';
import 'package:sales_system/shared/presentation/utils/app_top_snackbar.dart';
import 'package:sales_system/src/core/constants/scaffold_key.dart';
import 'package:sales_system/src/features/authentication/presentation/providers/auth_provider.dart';
import 'package:sales_system/widgets/app_text_field.dart';

class AddEmployeeView extends ConsumerStatefulWidget {
  const AddEmployeeView({super.key});

  @override
  ConsumerState<AddEmployeeView> createState() => _AddEmployeeViewState();
}

class _AddEmployeeViewState extends ConsumerState<AddEmployeeView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController(text: 'Sales@123'); // Default password
  String _selectedRole = 'employee';
  bool _isObscure = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final navKey = ref.read(navigatorKey);

    try {
      await ref.read(authControllerProvider.notifier).registerEmployee(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            role: _selectedRole,
          );

      if (mounted) {
        showAppTopSnackBar(navKey, "Employee added successfully!");
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        showAppTopSnackBar(navKey, e.toString(), type: 'error');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      header: PageHeader(
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: IconButton(
            icon: const Icon(FluentIcons.back, size: 20),
            onPressed: () => context.pop(),
          ),
        ),
        title: const Text('Add New Employee'),
      ),
      children: [
        Form(
          key: _formKey,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  hint: 'Enter employee full name',
                  prefixIcon: const Icon(IconlyLight.profile),
                  validator: (v) => v == null || v.isEmpty ? 'Name is required' : null,
                ),
                const SizedBox(height: 20),
                AppTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  hint: 'Enter employee email',
                  prefixIcon: const Icon(IconlyLight.message),
                  validator: (v) => v == null || v.isEmpty ? 'Email is required' : null,
                ),
                const SizedBox(height: 20),
                AppTextField(
                  controller: _passwordController,
                  label: 'Temporary Password',
                  hint: 'Enter a temporary password',
                  prefixIcon: const Icon(IconlyLight.password),
                  suffixIcon: IconButton(
                    icon: Icon(_isObscure ? IconlyLight.show : IconlyLight.hide),
                    onPressed: () => setState(() => _isObscure = !_isObscure),
                  ),
                  obscureText: _isObscure,
                  readOnly: true, // Default password is fixed, but toggle is available
                  validator: (v) => v == null || v.length < 6 ? 'Min 6 characters' : null,
                ),
                const SizedBox(height: 20),
                InfoLabel(
                  label: 'Select Role',
                  child: ComboBox<String>(
                    value: _selectedRole,
                    items: const [
                      ComboBoxItem(value: 'employee', child: Text('Employee')),
                      ComboBoxItem(value: 'admin', child: Text('Administrator')),
                    ],
                    onChanged: (v) => setState(() => _selectedRole = v ?? 'employee'),
                    placeholder: const Text('Select a role'),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: 200,
                  child: Button(
                    onPressed: _isLoading ? null : _submit,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: _isLoading 
                        ? const SizedBox(height: 20, width: 20, child: ProgressRing())
                        : const Text('Add Employee'),
                    ),
                  ),
                ),
              ].animate(interval: 50.ms).fade().slideX(begin: 0.1),
            ),
          ),
        ),
      ],
    );
  }
}
