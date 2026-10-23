import 'package:ecom_app/core/services/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/translate_extension.dart';
import '../../../core/services/localization_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeService>();
    final localization = context.watch<LocalizationProvider>();
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text('settings'.tr(context))),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'theme'.tr(context),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          SegmentedButton<ThemeMode>(
            segments: [
              ButtonSegment(
                value: ThemeMode.light,
                icon: const Icon(Icons.light_mode_outlined),
                label: Text('light'.tr(context)),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                icon: const Icon(Icons.dark_mode_outlined),
                label: Text('dark'.tr(context)),
              ),
              ButtonSegment(
                value: ThemeMode.system,
                icon: const Icon(Icons.settings_brightness_outlined),
                label: Text('system'.tr(context)),
              ),
            ],
            selected: {theme.themeMode},
            onSelectionChanged: (selected) {
              theme.setTheme(selected.first);
            },
          ),
          const SizedBox(height: 28),
          Text(
            'language'.tr(context),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('English'),
                  trailing: localization.isEnglish
                      ? Icon(Icons.check_circle, color: colors.primary)
                      : null,
                  onTap: localization.setEnglish,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.translate),
                  title: const Text('ភាសាខ្មែរ'),
                  trailing: localization.isKhmer
                      ? Icon(Icons.check_circle, color: colors.primary)
                      : null,
                  onTap: localization.setKhmer,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
