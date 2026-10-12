import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_iconly_plus/flutter_iconly_plus.dart';
import 'package:sales_system/shared/presentation/utils/confirmation_dialog.dart';
import 'package:sales_system/src/core/providers/theme_provider.dart';
import 'package:sales_system/src/features/authentication/presentation/providers/auth_provider.dart';
import 'package:sales_system/src/features/settings/presentation/widgets/settings_tile.dart';
import 'package:sales_system/src/features/settings/presentation/widgets/switch_tile.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScaffoldPage(
      padding: EdgeInsets.all(24),
      header: PageHeader(title: _Header()),
      content: _SettingsContent(),
    );
  }
}

// HEADER
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: FluentTheme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(IconlyLight.setting, size: 28),
        ),
        const SizedBox(width: 12),
        const Text(
          'Settings',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// CONTENT
class _SettingsContent extends ConsumerStatefulWidget {
  const _SettingsContent();

  @override
  ConsumerState<_SettingsContent> createState() => _SettingsContentState();
}

class _SettingsContentState extends ConsumerState<_SettingsContent> {
  bool notificationsEnabled = false;

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;
    final authState = ref.watch(authControllerProvider);
    final isAdmin = authState.value?.role == 'admin';

    return ListView(
      children: [
        SectionCard(
          title: 'Account',
          children: [
            SettingsTile(
              icon: IconlyLight.profile,
              title: 'Profile',
              subtitle: 'Update personal details',
              onTap: () => context.push('/profile'),
            ),
            SettingsTile(
              icon: IconlyLight.lock,
              title: 'Change Password',
              subtitle: 'Update your credentials',
              onTap: () => context.push('/change-password'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (isAdmin) ...[
          SectionCard(
            title: 'Admin',
            children: [
              SettingsTile(
                icon: IconlyLight.user,
                title: 'Add Employee',
                subtitle: 'Register a new staff member',
                onTap: () => context.push('/add-employee'),
              ),
              SettingsTile(
                icon: IconlyLight.user_1,
                title: 'Manage Employees',
                subtitle: 'View and manage staff status',
                onTap: () => context.push('/manage-employees'),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
        const SectionCard(
          title: 'Business',
          children: [
            SettingsTile(
              icon: IconlyLight.work,
              title: 'Store Info',
              subtitle: 'Manage business details',
            ),
            SettingsTile(
              icon: IconlyLight.wallet,
              title: 'Payment Methods',
              subtitle: 'Configure payment options',
            ),
          ],
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: 'Preferences',
          children: [
            SwitchTile(
              icon: IconlyLight.notification,
              title: 'Notifications',
              value: notificationsEnabled,
              onChanged: (val) => setState(() => notificationsEnabled = val),
            ),
            SwitchTile(
              icon: IconlyLight.show,
              title: 'Dark Mode',
              value: isDarkMode,
              onChanged: (val) {
                ref.read(themeProvider.notifier).state =
                    val ? ThemeMode.dark : ThemeMode.light;
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: 'System',
          children: [
            const SettingsTile(
              icon: IconlyLight.info_circle,
              title: 'About',
              subtitle: 'App version and info',
            ),
            SettingsTile(
              icon: IconlyLight.logout,
              title: 'Logout',
              isDestructive: true,
              onTap: () async {
                final confirmed = await showCustomDialog(
                  context: context,
                  title: 'Confirm Logout',
                  content: 'Are you sure you want to logout?',
                  type: DialogType.confirmation,
                );
                
                if (confirmed == true) {
                  ref.read(authControllerProvider.notifier).logout();
                }
              },
            ),
          ],
        ),
      ].animate(interval: 50.ms).fade(duration: 400.ms).slideX(begin: -0.05, duration: 400.ms, curve: Curves.easeOutCubic),
    );
  }
}

// REUSABLE SECTION CARD
class SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SectionCard({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FluentTheme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

