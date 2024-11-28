import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import 'package:neighborly_flutter_app/l10n/bloc/app_localization_bloc.dart';
import 'package:neighborly_flutter_app/l10n/language.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageBottomSheet extends StatefulWidget {
  const LanguageBottomSheet({super.key});

  @override
  LanguageBottomSheetState createState() => LanguageBottomSheetState();
}

class LanguageBottomSheetState extends State<LanguageBottomSheet> {
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
  }

  Future<void> _loadSelectedLanguage() async {
    _selectedLanguage = ShardPrefHelper.getLanguage() ?? 'en';
    setState(() {});
  }

  void _onLanguageSelected(String language) {
    setState(() {
      _selectedLanguage = language;
    });
    if (_selectedLanguage == 'en') {
      context
          .read<AppLocalizationBloc>()
          .add(ChangeAppLocalization(selectedLocale: Language[0]));
    } else {
      context
          .read<AppLocalizationBloc>()
          .add(ChangeAppLocalization(selectedLocale: Language[1]));
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocalizations.of(context)!.language,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Divider(
            height: 25,
          ),
          ListTile(
            leading: Radio<String>(
              value: 'en',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                if (value != null) _onLanguageSelected(value);
              },
            ),
            title: Text(AppLocalizations.of(context)!.english),
          ),
          ListTile(
            leading: Radio<String>(
              value: 'hi',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                if (value != null) _onLanguageSelected(value);
              },
            ),
            title: Text(AppLocalizations.of(context)!.hindi),
          ),
        ],
      ),
    );
  }
}
