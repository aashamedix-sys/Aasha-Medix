import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';

class LanguageSelector extends StatefulWidget {
  const LanguageSelector({super.key});

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.selectLanguage),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLanguageOption(
            context,
            localeProvider,
            'en',
            l10n.english,
            Icons.language,
          ),
          const SizedBox(height: 8),
          _buildLanguageOption(
            context,
            localeProvider,
            'te',
            l10n.telugu,
            Icons.language,
          ),
          const SizedBox(height: 8),
          _buildLanguageOption(
            context,
            localeProvider,
            'hi',
            l10n.hindi,
            Icons.language,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
      ],
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    LocaleProvider localeProvider,
    String code,
    String name,
    IconData icon,
  ) {
    final isSelected = localeProvider.locale.languageCode == code;

    return InkWell(
      onTap: () async {
        final newLocale = Locale(code);
        await localeProvider.setLocale(newLocale);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('$name selected')));
            Navigator.of(context).pop();
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF2E7D32).withValues(alpha: 0.1)
              : Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF2E7D32) : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF2E7D32) : Colors.grey[600],
            ),
            const SizedBox(width: 12),
            Text(
              name,
              style: TextStyle(
                color: isSelected ? const Color(0xFF2E7D32) : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (isSelected) ...[
              const Spacer(),
              const Icon(
                Icons.check_circle,
                color: Color(0xFF2E7D32),
                size: 20,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Simple language selector button for app bar or settings
class LanguageSelectorButton extends StatelessWidget {
  const LanguageSelectorButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.language, color: Color(0xFF2E7D32)),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => const LanguageSelector(),
        );
      },
      tooltip: 'Select Language',
    );
  }
}
