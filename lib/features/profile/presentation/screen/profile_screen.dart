import 'package:ecom_app/app/routes/app_routes.dart';
import 'package:ecom_app/core/localization/translate_extension.dart';
import 'package:ecom_app/core/services/localization_provider.dart';
import 'package:ecom_app/core/services/theme_provider.dart';
import 'package:ecom_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'my_profile'.tr(context),
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'settings'.tr(context),
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          children: [
            // PROFILE HEADER
            Container(
              width: double.infinity,
              color: colors.surface,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 82,
                        height: 82,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.surfaceContainerHighest,
                          border: Border.all(color: colors.primary, width: 2),
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://i.pravatar.cc/300?img=12',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: colors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: colors.surface, width: 2),
                          ),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            size: 15,
                            color: colors.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Alex Johnson',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'alex.johnson@gmail.com',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () {},
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'edit_profile'.tr(context),
                                style: textTheme.labelLarge?.copyWith(
                                  color: colors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                                color: colors.primary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ACCOUNT STATISTICS
            Container(
              color: colors.surface,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Row(
                children: [
                  _buildStat(
                    context,
                    icon: Icons.inventory_2_outlined,
                    title: 'orders'.tr(context),
                    value: '12',
                  ),
                  _buildDivider(context),
                  _buildStat(
                    context,
                    icon: Icons.favorite_border,
                    title: 'wishlist'.tr(context),
                    value: '8',
                  ),
                  _buildDivider(context),
                  _buildStat(
                    context,
                    icon: Icons.location_on_outlined,
                    title: 'addresses'.tr(context),
                    value: '2',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // MY ORDERS
            _buildSection(
              context,
              title: 'my_orders'.tr(context),
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.shopping_bag_outlined,
                  title: 'my_orders'.tr(context),
                  subtitle: 'view_track_orders'.tr(context),
                  onTap: () {},
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.local_shipping_outlined,
                  title: 'track_order'.tr(context),
                  subtitle: 'track_current_delivery'.tr(context),
                  onTap: () {},
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.replay_outlined,
                  title: 'returns_refunds'.tr(context),
                  subtitle: 'manage_returns_refunds'.tr(context),
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ACCOUNT
            _buildSection(
              context,
              title: 'account'.tr(context),
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.person_outline,
                  title: 'personal_information'.tr(context),
                  subtitle: 'name_email_phone'.tr(context),
                  onTap: () {},
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.location_on_outlined,
                  title: 'shipping_addresses'.tr(context),
                  subtitle: 'manage_delivery_addresses'.tr(context),
                  onTap: () {},
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.credit_card_outlined,
                  title: 'payment_methods'.tr(context),
                  subtitle: 'manage_payment_methods'.tr(context),
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 12),

            // PREFERENCES
            _buildSection(
              context,
              title: 'preferences'.tr(context),
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.notifications_none_outlined,
                  title: 'notifications'.tr(context),
                  subtitle: 'manage_notification_preferences'.tr(context),
                  onTap: () {},
                ),

                _buildMenuItem(
                  context,
                  icon: Icons.dark_mode_outlined,
                  title: 'dark_mode'.tr(context),
                  subtitle: 'appearance_settings'.tr(context),
                  onTap: () {
                    final themeService = context.read<ThemeService>();
                    themeService.setTheme(
                      themeService.themeMode == ThemeMode.dark
                          ? ThemeMode.light
                          : ThemeMode.dark,
                    );
                  },
                  trailing: Switch.adaptive(
                    value:
                        context.watch<ThemeService>().themeMode ==
                        ThemeMode.dark,
                    onChanged: (value) {
                      context.read<ThemeService>().setTheme(
                        value ? ThemeMode.dark : ThemeMode.light,
                      );
                    },
                  ),
                ),

                _buildMenuItem(
                  context,
                  icon: Icons.language_outlined,
                  title: 'language'.tr(context),
                  subtitle: context.watch<LocalizationProvider>().isKhmer
                      ? 'khmer'.tr(context)
                      : 'english'.tr(context),
                  onTap: () => _showLanguageDialog(context),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // SUPPORT
            _buildSection(
              context,
              title: 'support'.tr(context),
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.help_outline,
                  title: 'help_center'.tr(context),
                  subtitle: 'get_help_account'.tr(context),
                  onTap: () {},
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.headset_mic_outlined,
                  title: 'contact_us'.tr(context),
                  subtitle: 'talk_support_team'.tr(context),
                  onTap: () {},
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.info_outline,
                  title: 'about_us'.tr(context),
                  subtitle: 'learn_about_store'.tr(context),
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 20),

            // LOGOUT
            Container(
              color: colors.surface,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 6,
                ),
                leading: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: colors.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.logout, color: colors.error),
                ),
                title: Text(
                  'logout'.tr(context),
                  style: textTheme.titleSmall?.copyWith(
                    color: colors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () => _showLogoutDialog(context),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              '${'version'.tr(context)} 1.0.0',
              style: textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 25, color: colors.primary),
          const SizedBox(height: 7),
          Text(
            value,
            style: textTheme.titleMedium?.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            title,
            textAlign: TextAlign.center,
            style: textTheme.labelSmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Container(
      width: 1,
      height: 45,
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      color: colors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
            child: Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                color: colors.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: colors.onSurfaceVariant, size: 22),
      ),
      title: Text(
        title,
        style: textTheme.titleSmall?.copyWith(
          color: colors.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Text(
          subtitle,
          style: textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
        ),
      ),
      trailing:
          trailing ??
          Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: colors.onSurfaceVariant,
          ),
      onTap: onTap,
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final localization = context.read<LocalizationProvider>();

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('select_language'.tr(context)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Text('🇬🇧'),
                title: Text('english'.tr(context)),
                trailing: localization.isEnglish
                    ? Icon(Icons.check_circle, color: colors.primary)
                    : null,
                onTap: () {
                  localization.setEnglish();
                  Navigator.pop(dialogContext);
                },
              ),
              ListTile(
                leading: const Text('🇰🇭'),
                title: Text('khmer'.tr(context)),
                trailing: localization.isKhmer
                    ? Icon(Icons.check_circle, color: colors.primary)
                    : null,
                onTap: () {
                  localization.setKhmer();
                  Navigator.pop(dialogContext);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        bool isLoading = false;

        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              icon: Icon(Icons.logout_rounded, color: colors.error, size: 32),
              title: Text('logout'.tr(context)),
              content: Text('logout_confirmation'.tr(context)),
              actions: [
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: Text('cancel'.tr(context)),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.error,
                    foregroundColor: colors.onError,
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                          setDialogState(() => isLoading = true);

                          try {
                            await context.read<AuthProvider>().signOut();

                            if (!context.mounted) return;

                            // Close the confirmation dialog.
                            Navigator.of(dialogContext).pop();

                            // Navigate by route PATH, not route name.
                            context.goNamed(AppRoutes.login);
                          } catch (error) {
                            if (!context.mounted) return;

                            setDialogState(() => isLoading = false);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Logout failed. Please try again.',
                                ),
                                backgroundColor: colors.error,
                              ),
                            );
                          }
                        },
                  child: isLoading
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colors.onError,
                          ),
                        )
                      : Text('logout'.tr(context)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
