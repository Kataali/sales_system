import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_iconly_plus/flutter_iconly_plus.dart';
import 'package:sales_system/shared/presentation/utils/app_top_snackbar.dart';
import 'package:sales_system/src/core/constants/scaffold_key.dart';
import 'package:sales_system/src/features/authentication/presentation/providers/auth_provider.dart';

class ManageEmployeesView extends ConsumerWidget {
  const ManageEmployeesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeesAsync = ref.watch(employeeManagementProvider);
    final navKey = ref.read(navigatorKey);

    return ScaffoldPage(
      header: PageHeader(
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: IconButton(
            icon: const Icon(FluentIcons.back, size: 20),
            onPressed: () => context.pop(),
          ),
        ),
        title: const Text('Manage Employees'),
        commandBar: CommandBar(
          mainAxisAlignment: MainAxisAlignment.end,
          primaryItems: [
            CommandBarButton(
              icon: const Icon(IconlyLight.user),
              label: const Text('Add Employee'),
              onPressed: () => context.push('/add-employee'),
            ),
          ],
        ),
      ),
      content: employeesAsync.when(
        data: (employees) => ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: employees.length,
          itemBuilder: (context, index) {
            final employee = employees[index];
            return _EmployeeTile(
              employee: employee,
              onToggleStatus: (val) async {
                try {
                  await ref
                      .read(employeeManagementProvider.notifier)
                      .toggleEmployeeStatus(employee.id, employee.isActive);
                  showAppTopSnackBar(navKey, "Status updated for ${employee.name}");
                } catch (e) {
                  showAppTopSnackBar(navKey, e.toString(), type: 'error');
                }
              },
              onResetPassword: () async {
                final result = await showDialog<bool>(
                  context: context,
                  builder: (context) => ContentDialog(
                    title: const Text('Reset Password?'),
                    content: Text(
                      'Are you sure you want to reset the password for ${employee.name}? This will generate a new system password.',
                    ),
                    actions: [
                      Button(
                        child: const Text('Cancel'),
                        onPressed: () => Navigator.pop(context, false),
                      ),
                      FilledButton(
                        child: const Text('Reset'),
                        onPressed: () => Navigator.pop(context, true),
                      ),
                    ],
                  ),
                );

                if (result == true) {
                  try {
                    final newPassword = await ref
                        .read(employeeManagementProvider.notifier)
                        .resetEmployeePassword(employee.id);
                    
                    if (context.mounted) {
                      await showDialog(
                        context: context,
                        builder: (context) => ContentDialog(
                          title: const Text('Password Reset Successful'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('The new password for ${employee.name} is:'),
                              const SizedBox(height: 12),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: FluentTheme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: FluentTheme.of(context).resources.dividerStrokeColorDefault,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        newPassword,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ),
                                    Tooltip(
                                      message: 'Copy to clipboard',
                                      child: IconButton(
                                        icon: const Icon(FluentIcons.copy),
                                        onPressed: () {
                                          Clipboard.setData(ClipboardData(text: newPassword));
                                          showAppTopSnackBar(navKey, "Password copied to clipboard");
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Please provide this password to the employee. They will be required to change it on their next login.',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          actions: [
                            FilledButton(
                              child: const Text('Close'),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      );
                    }
                  } catch (e) {
                    showAppTopSnackBar(navKey, e.toString(), type: 'error');
                  }
                }
              },
            ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: 0.05);
          },
        ),
        loading: () => const Center(child: ProgressRing()),
        error: (e, s) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $e'),
              const SizedBox(height: 12),
              Button(
                child: const Text('Retry'),
                onPressed: () =>
                    ref.read(employeeManagementProvider.notifier).getEmployees(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmployeeTile extends StatelessWidget {
  final dynamic employee; // Use the User entity
  final ValueChanged<bool> onToggleStatus;
  final VoidCallback onResetPassword;

  const _EmployeeTile({
    required this.employee,
    required this.onToggleStatus,
    required this.onResetPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: FluentTheme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: FluentTheme.of(context).resources.dividerStrokeColorDefault,
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: employee.role == 'admin' 
              ? Colors.orange.withValues(alpha: 0.2) 
              : Colors.blue.withValues(alpha: 0.2),
          child: Icon(
            employee.role == 'admin' ? IconlyLight.shield_done : IconlyLight.user,
            color: employee.role == 'admin' ? Colors.orange : Colors.blue,
          ),
        ),
        title: Text(
          employee.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(employee.email),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: (employee.isActive ? Colors.green : Colors.red)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                employee.isActive ? 'Active' : 'Inactive',
                style: TextStyle(
                  color: employee.isActive ? Colors.green : Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 24),
            IconButton(
              icon: Icon(
                FluentIcons.reset,
                color: FluentTheme.of(context).accentColor,
              ),
              onPressed: onResetPassword,
            ),
            const SizedBox(width: 12),
            ToggleSwitch(
              checked: employee.isActive,
              onChanged: onToggleStatus,
            ),
          ],
        ),
      ),
    );
  }
}
