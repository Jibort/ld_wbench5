// lib/services/L.dart
// Servei centralitzat per a la gestió d'idiomes
// Updated: 2025/05/15 dc. GPT(JIQ)

import 'package:flutter/material.dart';
import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/ld_taggable_mixin.dart';
import 'package:ld_wbench5/core/event_bus/event_bus.dart';
import 'package:ld_wbench5/core/ld_typedefs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/ui/app/sabina_app.dart';
import 'package:ld_wbench5/ui/ui_consts.dart';
import 'package:ld_wbench5/core/extensions/map_extensions.dart';
import 'package:ld_wbench5/utils/debug.dart';
import 'package:ld_wbench5/core/extensions/string_extensions.dart';

typedef Strings = List<String>;
typedef Dictionary = LdMap<String>;

class L with LdTaggableMixin {
  // CLAUS DE TRADUCCIÓ ===================================
  static const String sSabina = "##sSabina";
  static const String sAppSabina = "##sAppSabina";
  static const String sWelcome = "##sWelcome";
  static const String sChangeLanguage = "##sChangeLanguage";
  static const String sChangeTheme = "##sChangeTheme";
  static const String sToggleThemeButtonVisibility = "##sToggleThemeButtonVisibility";
  static const String sToggleLanguageButtonEnabled = "##sToggleLanguageButtonEnabled";
  static const String sCounter = "##sCounter";
  static const String sCurrentLanguage = "##sCurrentLanguage";
  static const String sFeaturesDemo = "##sFeaturesDemo";
  static const String sTextField = "##sTextField";
  static const String sTextFieldHelp = "##sTextFieldHelp";

  static const String sCurrentTime = "##sCurrentTime";

  // SINGLETON ===========================================
  static final L _inst = L._();
  static L get s => _inst;

  // MEMBRES =============================================
  Locale _deviceLocale = const Locale('ca');
  Locale? _currentLocale;
  final LdMap<Dictionary> _dictionaries = {};

  // CONSTRUCTOR PRIVAT ==================================
  L._() {
    tag = className;
    _loadDictionaries();
    Debug.info("$tag: Servei inicialitzat");
  }

  // IDIOMES =============================================
  static Locale get deviceLocale => s._deviceLocale;
  static set deviceLocale(Locale locale) {
    s._deviceLocale = locale;
    Debug.info("${s.tag}: Idioma del dispositiu detectat: ${locale.languageCode}");
    if (s._currentLocale == null) {
      setCurrentLocale(locale);
    }
  }

  static Locale getCurrentLocale() {
    if (s._currentLocale == null) {
      s._currentLocale = s._deviceLocale;
      if (!s._dictionaries.containsKey(s._currentLocale!.languageCode)) {
        s._currentLocale = const Locale('es');
      }
    }
    return s._currentLocale!;
  }

  static void setCurrentLocale(Locale locale) {
    String languageCode = locale.languageCode;
    if (!s._dictionaries.containsKey(languageCode)) {
      languageCode = 'es';
      Debug.info("${s.tag}: Idioma $languageCode no disponible, usant 'es' per defecte");
    }

    Locale? oldLocale = s._currentLocale;
    if (oldLocale?.languageCode == languageCode) {
      Debug.info("${s.tag}: L'idioma ja és $languageCode, no cal canviar");
      return;
    }

    s._currentLocale = Locale(languageCode);
    Debug.info("${s.tag}: Idioma canviat de ${oldLocale?.languageCode ?? 'null'} a $languageCode");

    List<String> textComponents = [SabinaApp.s.tag];

    EventBus.s.emitTargeted(
      LdEvent(
        eType: EventType.languageChanged,
        srcTag: s.tag,
        eData: {
          efOldLocale: oldLocale?.languageCode,
          efNewLocale: s._currentLocale!.languageCode,
        },
      ),
      targets: textComponents,
    );
  }

  // DICCIONARIS ==========================================
  void _loadDictionaries() {
    Debug.info("$tag: Carregant diccionaris");

    _dictionaries['ca'] = Dictionary.from({
      sSabina: "Sabina",
      sAppSabina: "Aplicació Sabina",
      sWelcome: "Benvingut/da",
      sChangeLanguage: "Canviar l'Idioma",
      sChangeTheme: "Canviar el Tema",
      sToggleThemeButtonVisibility: "Alternar visibilitat botó tema",
      sToggleLanguageButtonEnabled: "Alternar estat botó idioma",
      sCounter: "[ca] Comptador: {0}",
      sCurrentLanguage: "[ca] Idioma actual: {0}",
      sFeaturesDemo: "Demostració de característiques:",
      sTextField: "Camp de text",
      sTextFieldHelp: "Introdueix un text",
      sCurrentTime: "[ca] Hora actual: {0}",
     });

    _dictionaries['es'] = Dictionary.from({
      sSabina: "Sabina",
      sAppSabina: "Aplicación Sabina",
      sWelcome: "Bienvenido/a",
      sChangeLanguage: "Cambiar Idioma",
      sChangeTheme: "Cambiar Tema",
      sToggleThemeButtonVisibility: "Alternar visibilidad botón tema",
      sToggleLanguageButtonEnabled: "Alternar estado botón idioma",
      sCounter: "[es] Contador: {0}",
      sCurrentLanguage: "[es] Idioma actual: {0}",
      sFeaturesDemo: "Demostración de características:",
      sTextField: "Campo de texto",
      sTextFieldHelp: "Introduce un texto",
      sCurrentTime: "[es] Hora actual: {0}",
    });

    _dictionaries['en'] = Dictionary.from({
      sSabina: "Sabina",
      sAppSabina: "Sabina Application",
      sWelcome: "Welcome",
      sChangeLanguage: "Change Language",
      sChangeTheme: "Change Theme",
      sToggleThemeButtonVisibility: "Toggle theme button visibility",
      sToggleLanguageButtonEnabled: "Toggle language button enabled state",
      sCounter: "[en] Counter: {0}",
      sCurrentLanguage: "Current language: {0}",
      sFeaturesDemo: "Features demonstration:",
      sTextField: "Text field",
      sTextFieldHelp: "Enter text",
      sCurrentTime: "[en] Current time: {0}",

    });
  }

// TRADUCCIÓ ===========================================
  static String tx(
    String key, [
      Strings? posArgs = const [], 
      LdMap<String>? namedArgs = const {}
    ]) 
  { posArgs ??= const [];
    namedArgs ??= const {};

    Locale locale = getCurrentLocale();
    Dictionary? dictionary = s._dictionaries[locale.languageCode];
    String baseKey = key.extractKey;

    String translation = dictionary?.getOr(baseKey, errInText) ?? errInText;

    if (translation == errInText) {
      Debug.warn("L.tx: Translation key '$baseKey' not found in '${locale.languageCode}' dictionary");
    } else {
      Debug.info("L.tx: Translated '$baseKey' to '$translation' in '${locale.languageCode}'");
    }

    // Substituir valors posicionals
    for (int i = 0; i < posArgs.length; i++) {
      translation = translation.replaceAll('{$i}', posArgs[i]);
    }

    // Substituir valors amb nom
    namedArgs.forEach((k, v) {
      translation = translation.replaceAll('{$k}', v);
    });

    return translation;
  }

  // TOGGLE ==============================================
  static void toggleLanguage() {
    Locale current = getCurrentLocale();
    if (current.languageCode == 'ca') {
      setCurrentLocale(const Locale('es'));
    } else {
      setCurrentLocale(const Locale('ca'));
    }
  }
}

// RICHTEXT DYNAMIC INTERPOLATION (OPCIONAL) =============
extension TranslateExtension on String {
  /// Tradueix la cadena i hi aplica interpolació si cal
  String tx([
    Strings posArgs = const [],
    LdMap<String> namedArgs = const {},
  ]) => L.tx(this, posArgs, namedArgs);
}
