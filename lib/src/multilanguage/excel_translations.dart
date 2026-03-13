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
/// El Excel debe tener una hoja llamada 'translations' con la columna 0 para las claves (VAR) y las siguientes para cada idioma (ES, EN, etc).
Future<List<MapLocale>> loadExcelTranslations() async {
  // 1) Carga el xlsx
  final data = await rootBundle.load('assets/translations/translations.xlsx');
  final bytes = data.buffer.asUint8List();
  final excel = Excel.decodeBytes(bytes);

  // 2) Obtén la hoja correcta
  final sheet = excel.tables['translations'];
  if (sheet == null) {
    throw Exception("No existe la hoja \"translations\" en el Excel");
  }

  // 3) Lee y limpia la cabecera
  final rawHeaders = sheet.row(0)
      .map((cell) => cell?.value.toString().trim() ?? '')
      .toList();
  // rawHeaders[0] == 'VAR', rawHeaders[1]=='ES', rawHeaders[2]=='EN', etc.

  // 4) Genera sólo los códigos no vacíos (skip la columna VAR)
  final languages = rawHeaders
      .skip(1)
      .map((h) => h.toLowerCase())
      .where((h) => h.isNotEmpty)
      .toList();

  // 5) Prepara un mapa vacío por cada idioma válido
  final perLang = <String, Map<String, String>>{
    for (var lang in languages) lang: <String, String>{},
  };

  // 6) Rellena traducciones
  for (var i = 1; i < sheet.maxRows; i++) {
    final row = sheet.row(i);
    if (row.isEmpty) continue;
    
    final key = row[0]?.value.toString().trim() ?? '';
    if (key.isEmpty) continue;
    
    for (var j = 0; j < languages.length; j++) {
      final lang = languages[j]; // e.g. 'es','en','ar',...
      if (row.length > j + 1) {
        final cell = row[j + 1]; // +1 porque la columna 0 es la clave
        perLang[lang]![key] = cell?.value.toString() ?? '';
      }
    }
  }

  // 7) Construye los MapLocale sin claves vacías
  return perLang.entries
      .map((e) => MapLocale(e.key, e.value))
      .toList();
}

/// PIZZACORN_UI CANDIDATE
/// Function: initMultilanguage
/// Motivo: Encapsula toda la lógica de inicialización de multiidioma:
/// Carga desde Excel, detecta idioma guardado o del dispositivo, e inicializa flutter_localization e intl.
Future<void> initMultilanguage({String defaultLang = 'es'}) async {
  final prefs = await SharedPreferences.getInstance();
  final String? savedLang = prefs.getString('language_code');

  final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
  final String deviceLang = deviceLocale.languageCode;

  // Carga los locales desde el Excel
  final List<MapLocale> locales = await loadExcelTranslations();

  bool hasLang(String langCode) {
    return locales.any((locale) => locale.languageCode == langCode);
  }

  String initialLangCode = defaultLang;

  // Prioridad: 1. Guardado en Prefs, 2. Idioma dispositivo, 3. Inglés, 4. Primero del Excel
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

  // Inicializa el formato de fechas de intl
  await initializeDateFormatting(initialLangCode, null);
}

/// PIZZACORN_UI CANDIDATE
/// Extension: StringTrans
/// Motivo: Facilita la traducción de strings directamente usando '.translate(context)'.
extension StringTrans on String {
  String translate(BuildContext context) => getString(context);
}

/// PIZZACORN_UI CANDIDATE
/// Widget: LanguageSelector
/// Motivo: Un selector de idiomas visual (para usar en BottomSheets o Modales) que detecta automáticamente los idiomas soportados.
class LanguageSelector extends StatefulWidget {
  final VoidCallback? onLanguageChanged;
  const LanguageSelector({super.key, this.onLanguageChanged});

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  final _loc = FlutterLocalization.instance;

  String _getLanguageName(String code) {
    try {
      return _nativeNames[code] ?? code.toUpperCase();
    } catch (e) {
      return code.toUpperCase();
    }
  }

  static const Map<String, String> _nativeNames = {
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
    'tr': 'Türkçe', 'uk': 'Українська', 'ur': 'اردو', 'uz': 'O‘zbekcha',
    'vi': 'Tiếng Việt', 'zh': '中文'
  };

  String _getFlagEmoji(String languageCode) {
    String countryCode = languageCode;
    if (languageCode == 'en') countryCode = 'us';
    if (languageCode == 'ar') countryCode = 'sa';

    return countryCode.toUpperCase().split('').map((char) {
      return String.fromCharCode(char.codeUnitAt(0) + 127397);
    }).join();
  }

  @override
  Widget build(BuildContext context) {
    final List<Locale> locales = _loc.supportedLocales.toList();

    return Column(
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
          _buildLanguageTile(locales[i])
      ],
    );
  }

  Widget _buildLanguageTile(Locale locale) {
    final code = locale.languageCode;
    final isCurrent = _loc.currentLocale?.languageCode == code;

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      decoration: BoxDecoration(
        color: isCurrent ? COLOR_ACCENT.withOpacity(0.08) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isCurrent ? Border.all(color: COLOR_ACCENT.withOpacity(0.2)) : null,
      ),
      child: InkWell(
        onTap: () async {
          _loc.translate(code);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('language_code', code);

          widget.onLanguageChanged?.call();
          if (mounted) Navigator.of(context).pop();
        },
        child: Row(
          children: [
            TextBody(
              _getFlagEmoji(code),
              fontSize: 24,
            ),

            Space(SPACE_SMALL),

            Expanded(
              child: TextBody(
                _getLanguageName(code),
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
