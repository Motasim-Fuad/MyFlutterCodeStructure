
// WHY: Reusable language selector component
// USAGE: Can be used anywhere in app (AppBar, Drawer, Settings)

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/config/localization/localization_config.dart';
import '../../core/utils/logger.dart';

class LanguageSelector extends StatelessWidget {
  final bool showLabel;
  final Color? iconColor;

  const LanguageSelector.dropdown({
    Key? key,
    this.showLabel = true,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final options = LocalizationConfig.getLocaleOptions();
    final currentLocale = Get.locale ?? LocalizationConfig.fallbackLocale;

    return PopupMenuButton<LocaleOption>(
      icon: Icon(Icons.language, color: iconColor),
      tooltip: 'Change Language',
      onSelected: _changeLanguage,
      itemBuilder: (context) => options.map((option) {
        return PopupMenuItem<LocaleOption>(
          value: option,
          child: Row(
            children: [
              Text(option.flag, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 12),
              Text(option.nativeName),
              const Spacer(),
              if (option.locale.languageCode == currentLocale.languageCode)
                const Icon(Icons.check, color: Colors.green, size: 20),
            ],
          ),
        );
      }).toList(),
    );
  }

  Future<void> _changeLanguage(LocaleOption option) async {
    try {
      await LocalizationConfig.changeLocale(option.locale);
      AppLogger.info('🌐 Language changed to: ${option.name}');

      Get.snackbar(
        'Success',
        'Language changed to ${option.nativeName}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      AppLogger.error('Failed to change language', e);
    }
  }
}


class LanguageSelectorButton extends StatelessWidget {
  const LanguageSelectorButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentName = LocalizationConfig.getCurrentLocaleName();

    return ElevatedButton.icon(
      onPressed: () => _showLanguageDialog(context),
      icon: const Icon(Icons.language),
      label: Text(currentName),
    );
  }

  Future<void> _showLanguageDialog(BuildContext context) async {
    final options = LocalizationConfig.getLocaleOptions();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((option) {
            return RadioListTile<String>(
              value: option.locale.languageCode,
              groupValue: Get.locale?.languageCode,
              onChanged: (_) async {
                await LocalizationConfig.changeLocale(option.locale);
                Navigator.pop(context);
                AppLogger.info('🌐 Language changed to: ${option.name}');
              },
              title: Row(
                children: [
                  Text(option.flag, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Text(option.nativeName),
                ],
              ),
              subtitle: Text(option.name),
            );
          }).toList(),
        ),
      ),
    );
  }
}


class LanguageSelectorListTile extends StatelessWidget {
  const LanguageSelectorListTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentName = LocalizationConfig.getCurrentLocaleName();

    return ListTile(
      leading: const Icon(Icons.language),
      title: const Text('Language'),
      subtitle: Text(currentName),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _showLanguageBottomSheet(context),
    );
  }

  Future<void> _showLanguageBottomSheet(BuildContext context) async {
    final options = LocalizationConfig.getLocaleOptions();

    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          const Text(
            'Select Language',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          ...options.map((option) {
            return ListTile(
              leading: Text(option.flag, style: const TextStyle(fontSize: 24)),
              title: Text(option.nativeName),
              subtitle: Text(option.name),
              trailing: option.isActive
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
              onTap: () async {
                await LocalizationConfig.changeLocale(option.locale);
                Navigator.pop(context);
                AppLogger.info('🌐 Language changed to: ${option.name}');
              },
            );
          }).toList(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}