import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:excel/excel.dart' hide Border;
import 'package:flutter_localization/flutter_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../pizzacorn_ui.dart';

/// PIZZACORN_UI CANDIDATE
/// Function: loadExcelTranslations
/// Motivo: Carga traducciones desde un archivo Excel (.xlsx) y las convierte al formato de flutter_localization.
Future<List<MapLocale>> loadExcelTranslations() async {
  final data = await rootBundle.load('assets/translations/translations.xlsx');
  final bytes = data.buffer.asUint8List();
  final excel = Excel.decodeBytes(bytes);

  final sheet = excel.tables['translations'];
  if (sheet == null) {
    throw Exception("No existe la hoja \"translations\" en el Excel");
  }

  final rawHeaders = sheet.row(0)
      .map((cell) => cell?.value.toString().trim() ?? '')
      .toList();

  final languages = rawHeaders
      .skip(1)
      .map((h) => h.toLowerCase())
      .where((h) => h.isNotEmpty)
      .toList();

  final perLang = <String, Map<String, String>>{
    for (var lang in languages) lang: <String, String>{},
  };

  for (int i = 1; i < sheet.maxRows; i++) {
    final row = sheet.row(i);
    if (row.isEmpty) continue;
    
    final key = row[0]?.value.toString().trim() ?? '';
    if (key.isEmpty) continue;
    
    for (int j = 0; j < languages.length; j++) {
      final lang = languages[j];
      if (row.length > j + 1) {
        final cell = row[j + 1];
        perLang[lang]![key] = cell?.value.toString() ?? '';
      }
    }
  }

  return perLang.entries
      .map((e) => MapLocale(e.key, e.value))
      .toList();
}

/// PIZZACORN_UI CANDIDATE
/// Function: initMultilanguage
/// Motivo: Encapsula toda la lógica de inicialización de multiidioma.
Future<void> initMultilanguage({String defaultLang = 'es'}) async {
  final prefs = await SharedPreferences.getInstance();
  final String? savedLang = prefs.getString('language_code');

  final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
  final String deviceLang = deviceLocale.languageCode;

  final List<MapLocale> locales = await loadExcelTranslations();

  bool hasLang(String langCode) {
    return locales.any((locale) => locale.languageCode == langCode);
  }

  String initialLangCode = defaultLang;

  if (savedLang != null && hasLang(savedLang)) {
    initialLangCode = savedLang;
  } else if (hasLang(deviceLang)) {
    initialLangCode = deviceLang;
  } else if (hasLang('en')) {
    initialLangCode = 'en';
  } else if (locales.isNotEmpty) {
    initialLangCode = locales.first.languageCode;
  }

  final FlutterLocalization localization = FlutterLocalization.instance;
  await localization.ensureInitialized();
  
  localization.init(
    mapLocales: locales,
    initLanguageCode: initialLangCode,
  );

  await initializeDateFormatting(initialLangCode, null);
}

/// PIZZACORN_UI CANDIDATE
/// Extension: StringTrans
/// Motivo: Facilita la traducción de strings directamente usando '.translate(context)'.
extension StringTrans on String {
  String translate(BuildContext context) => getString(context);
}

/// Helper global para obtener el emoji de la bandera
String getFlagEmoji(String languageCode) {
  String countryCode = languageCode;
  if (languageCode == 'en') countryCode = 'us';
  if (languageCode == 'ar') countryCode = 'sa';

  return countryCode.toUpperCase().split('').map((char) {
    return String.fromCharCode(char.codeUnitAt(0) + 127397);
  }).join();
}

/// Mapeo nativo de idiomas
const Map<String, String> nativeNames = {
  'af': 'Afrikaans', 'ar': 'العربية', 'az': 'Azərbaycanca', 'be': 'Беларуская',
  'bg': 'Български', 'bn': 'বাংলা', 'bs': 'Bosanski', 'ca': 'Català',
  'cs': 'Čeština', 'cy': 'Cymraeg', 'da': 'Dansk', 'de': 'Deutsch',
  'el': 'Ελληνικά', 'en': 'English', 'es': 'Español', 'et': 'Eesti',
  'eu': 'Euskara', 'fa': 'فارسی', 'fi': 'Suomi', 'fr': 'Français',
  'gl': 'Galego', 'he': 'עברית', 'hi': 'हिन्दी', 'hr': 'Hrvatski',
  'hu': 'Magyar', 'hy': 'Հայերén', 'id': 'Bahasa Indonesia', 'is': 'Íslenska',
  'it': 'Italiano', 'ja': '日本語', 'ka': 'ქართული', 'kk': 'Қазақ тілі',
  'km': 'ខ្មែر', 'ko': '한국어', 'ky': 'Кыргызча', 'lo': 'ລາว',
  'lt': 'Lietuvių', 'lv': 'Latviešu', 'mk': 'Македонски', 'mn': 'Монгол',
  'ms': 'Bahasa Melayu', 'my': 'မြန်မာ', 'ne': 'नेपाली', 'nl': 'Nederlands',
  'no': 'Norsk', 'pa': 'ਪੰਜਾਬੀ', 'pl': 'Polski', 'pt': 'Português',
  'ro': 'Română', 'ru': 'Русский', 'si': 'සිංහල', 'sk': 'Slovenčina',
  'sl': 'Slovenščina', 'sq': 'Shqip', 'sr': 'Српски', 'sv': 'Svenska',
  'sw': 'Kiswahili', 'ta': 'தமிழ்', 'te': 'తెలుగు', 'th': 'ไทย',
  'tr': 'Türkçe', 'uk': 'Українська', 'ur': 'اردu', 'uz': 'O‘zbekcha',
  'vi': 'Tiếng Việt', 'zh': '中文'
};

/// PIZZACORN_UI CANDIDATE
/// Widget: LanguageSelector
/// Motivo: Un selector de idiomas visual wrapped en Material.
class LanguageSelector extends StatefulWidget {
  final VoidCallback? onLanguageChanged;
  LanguageSelector({super.key, this.onLanguageChanged});

  @override
  State<LanguageSelector> createState() => LanguageSelectorState();
}

class LanguageSelectorState extends State<LanguageSelector> {
  final localization = FlutterLocalization.instance;

  String getLanguageName(String code) {
    try {
      return nativeNames[code] ?? code.toUpperCase();
    } catch (e) {
      return code.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Locale> locales = localization.supportedLocales.toList();

    return Material(
      color: COLOR_BACKGROUND,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          for (int i = 0; i < locales.length; i++)
            buildLanguageTile(locales[i])
        ],
      ),
    );
  }

  Widget buildLanguageTile(Locale locale) {
    final code = locale.languageCode;
    final isCurrent = localization.currentLocale?.languageCode == code;

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      decoration: BoxDecoration(
        color: isCurrent ? COLOR_ACCENT.withValues(alpha: 0.08) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isCurrent ? Border.all(color: COLOR_ACCENT.withValues(alpha: 0.2)) : null,
      ),
      child: InkWell(
        onTap: () async {
          localization.translate(code);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('language_code', code);

          widget.onLanguageChanged?.call();
          if (mounted) Navigator.of(context).pop();
        },
        child: Row(
          children: [
            TextBody(getFlagEmoji(code), fontSize: 24),
            Space(SPACE_SMALL),
            Expanded(
              child: TextBody(
                getLanguageName(code),
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                color: isCurrent ? COLOR_ACCENT : COLOR_TEXT,
              ),
            ),
            if (isCurrent)
              Icon(Icons.check_circle_rounded, color: COLOR_ACCENT, size: 22),
          ],
        ),
      ),
    );
  }
}

/// PIZZACORN_UI CANDIDATE
/// Widget: LanguageSmallSelector
/// Motivo: Un selector de idioma compacto que se actualiza automáticamente.
class LanguageSmallSelector extends StatefulWidget {
  final VoidCallback? onLanguageChanged;
  final Color? backgroundColor;
  final Color? textColor;
  final double fontSize;

  LanguageSmallSelector({
    super.key,
    this.onLanguageChanged,
    this.backgroundColor,
    this.textColor,
    this.fontSize = 14,
  });

  @override
  State<LanguageSmallSelector> createState() => LanguageSmallSelectorState();
}

class LanguageSmallSelectorState extends State<LanguageSmallSelector> {
  @override
  Widget build(BuildContext context) {
    final String currentLang = FlutterLocalization.instance.currentLocale?.languageCode ?? 'es';

    return GestureDetector(
      onTap: () => openBottomSheet(
        context, 
        LanguageSelector(
          onLanguageChanged: () {
            if (mounted) setState(() {});
            widget.onLanguageChanged?.call();
          }
        ),
        height: 300,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? Colors.black.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: (widget.textColor ?? Colors.white).withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextBody(getFlagEmoji(currentLang), fontSize: widget.fontSize + 4),
            Space(8),
            TextBody(
              currentLang.toUpperCase(), 
              color: widget.textColor ?? Colors.white, 
              fontWeight: FontWeight.bold,
              fontSize: widget.fontSize,
            ),
            Space(4),
            Icon(Icons.keyboard_arrow_down, color: widget.textColor ?? Colors.white, size: widget.fontSize + 4),
          ],
        ),
      ),
    );
  }
}
