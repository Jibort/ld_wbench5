// L.dart
// Servei d'internacionalització simplificat
// Created: 2025/04/29 dt. CLA[JIQ]

import 'package:flutter/material.dart';
import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/ld_taggable_mixin.dart';
import 'package:ld_wbench5/core/event_bus/event_bus.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/ui/app/sabina_app.dart';
import 'package:ld_wbench5/ui/ui_consts.dart';
import 'package:ld_wbench5/ui/extensions/map_extensions.dart';
import 'package:ld_wbench5/utils/debug.dart';
import 'package:ld_wbench5/ui/extensions/string_extensions.dart';

/// Servei centralitzat per a la gestió d'idiomes
class L 
with  LdTaggableMixin {
  /// Constants de les claus de text
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

  /// Instància singleton
  static final L _inst = L._();
  static L get s => _inst;
  
  /// Idioma detectat al dispositiu
  Locale _deviceLocale = const Locale('ca');
  
  /// Idioma actual de l'aplicació
  Locale? _currentLocale;
  
  /// Diccionaris disponibles
  final LdMap<Dictionary> _dictionaries = {};
  
  /// Constructor privat
  L._() {
    tag = className;
    _loadDictionaries();
    Debug.info("$tag: Servei inicialitzat");
  }
  
  /// Retorna l'idioma del dispositiu
  static Locale get deviceLocale => s._deviceLocale;
  
  /// Estableix l'idioma del dispositiu
  static set deviceLocale(Locale locale) {
    s._deviceLocale = locale;
    Debug.info("${s.tag}: Idioma del dispositiu detectat: ${locale.languageCode}");
    if (s._currentLocale == null) {
      setCurrentLocale(locale);
    }
  }
  
  /// Retorna l'idioma actual
  static Locale getCurrentLocale() {
    if (s._currentLocale == null) {
      s._currentLocale = s._deviceLocale;
      // Si el diccionari de l'idioma del dispositiu no existeix, usa espanyol
      if (!s._dictionaries.containsKey(s._currentLocale!.languageCode)) {
        s._currentLocale = const Locale('es');
      }
    }
    return s._currentLocale!;
  }
  
  /// Estableix l'idioma actual
  static void setCurrentLocale(Locale locale) {
    String languageCode = locale.languageCode;
    if (!s._dictionaries.containsKey(languageCode)) {
      languageCode = 'es'; // Fallback a espanyol si l'idioma no està disponible
      Debug.info("${s.tag}: Idioma $languageCode no disponible, usant 'es' per defecte");
    }
    
    Locale? oldLocale = s._currentLocale;
    
    // Verificar si l'idioma realment canvia
    if (oldLocale?.languageCode == languageCode) {
      Debug.info("${s.tag}: L'idioma ja és $languageCode, no cal canviar");
      return;  // Sortir si l'idioma no canvia
    }
    
    s._currentLocale = Locale(languageCode);
    Debug.info("${s.tag}: Idioma canviat de ${oldLocale?.languageCode ?? 'null'} a $languageCode");
    
    // Obtenir la llista de components que mostren text
    // En una aplicació real, podríem tenir un registre de components que utilitzen text
    List<String> textComponents = [
      SabinaApp.s.tag,
      // Afegir aquí altres components que mostren text
    ];
    
    // Notificar només als components que mostren text
    EventBus.s.emitTargeted(
      LdEvent(
        eType: EventType.languageChanged,
        srcTag: s.tag,
        eData: {
          efOldLocale: oldLocale?.languageCode,
          efNewLocale: s._currentLocale!.languageCode,
        },
      ),
      targets: textComponents
    );
  }

  // CAL_01:/// Estableix l'idioma actual
  // CAL_01:static void setCurrentLocale(Locale locale) {
  // CAL_01:  String languageCode = locale.languageCode;
  // CAL_01:  if (!s._dictionaries.containsKey(languageCode)) {
  // CAL_01:    languageCode = 'es'; // Fallback a espanyol si l'idioma no està disponible
  // CAL_01:    Debug.info("${s.tag}: Idioma $languageCode no disponible, usant 'es' per defecte");
  // CAL_01:  }
  // CAL_01:
  // CAL_01:  Locale? oldLocale = s._currentLocale;
  // CAL_01:  s._currentLocale = Locale(languageCode);
  // CAL_01:  Debug.info("${s.tag}: Idioma canviat de ${oldLocale?.languageCode ?? 'null'} a $languageCode");
  // CAL_01:
  // CAL_01:  // Notifica del canvi d'idioma amb un sol event
  // CAL_01:  // Aquest event hauria de ser suficient per actualitzar tota l'aplicació
  // CAL_01:  EventBus.s.emit(LdEvent(
  // CAL_01:    eType: EventType.languageChanged,
  // CAL_01:    srcTag: s.tag,
  // CAL_01:    eData: {
  // CAL_01:      efOldLocacle: oldLocale?.languageCode,
  // CAL_01:      efNewLocale: s._currentLocale!.languageCode,
  // CAL_01:    },
  // CAL_01:  ));
  // CAL_01:}
  
  /// Carrega tots els diccionaris disponibles
  void _loadDictionaries() {
    Debug.info("$tag: Carregant diccionaris");
    
    // Català
    _dictionaries['ca'] = {
      sSabina: "Sabina",
      sAppSabina: "Aplicació Sabina",
      sWelcome: "Benvingut/da",
      sChangeLanguage: "Canvia l'Idioma",
      sChangeTheme: "Canvia el Tema",
      sToggleThemeButtonVisibility: "Alternar visibilitat botó tema",
      sToggleLanguageButtonEnabled: "Alternar estat botó idioma",
      sCounter: "[ca] Comptador: {0}",
      sCurrentLanguage: "[ca] Idioma actual: {0}",
      sFeaturesDemo: "Demostració de característiques:",
      sTextField: "Camp de text",
      sTextFieldHelp: "Introdueix un text",
    };
    
    // Espanyol
    _dictionaries['es'] = {
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
    };
    
    // Anglès
    _dictionaries['en'] = {
      sSabina: "Sabina",
      sAppSabina: "Sabina Application",
      sWelcome: "Welcome",
      sChangeLanguage: "Change Language",
      sChangeTheme: "Change Theme",
      sToggleThemeButtonVisibility: "Toggle theme button visibility",
      sToggleLanguageButtonEnabled: "Toggle language button enabled state",
      sCounter: "Counter: {0}",
      sCurrentLanguage: "Current language: {0}",
      sFeaturesDemo: "Features demonstration:",
      sTextField: "Text field",
      sTextFieldHelp: "Enter text",
    };
  }
  
  /// Obté la traducció d'una clau
  // Modificació a lib/services/L.dart

  // Afegir a les imports

  // Modificar el mètode tx per utilitzar extractKey
  /// Obté la traducció d'una clau i aplica format si s'especifiquen arguments
  static String tx(String key, [List<dynamic>? args]) {
    Locale locale = getCurrentLocale();
    Dictionary? dictionary = s._dictionaries[locale.languageCode];
    
    // Extreure només la clau base si conté símbol o espai
    String baseKey = key.extractKey;
    
    String translation = dictionary?.getOr(baseKey, errInText) ?? errInText;
    
    if (translation == errInText) {
      Debug.warn("L.tx: Translation key '$baseKey' not found in '${locale.languageCode}' dictionary");
    } else {
      Debug.info("L.tx: Translated '$baseKey' to '$translation' in '${locale.languageCode}'");
      
      // Si hi ha arguments, aplicar el format
      if (args != null && args.isNotEmpty) {
        String original = translation;
        translation = original.format(args);
        Debug.info("L.tx: Formatted '$original' with args $args to '$translation'");
      }
    }
    
    return translation;
  }

  // Afegir un nou mètode per format
  static String txFormat(String key, List<dynamic> args) {
    return tx(key).format(args);
  }
  
  /// Alternativa l'idioma entre català i espanyol
  static void toggleLanguage() {
    Locale current = getCurrentLocale();
    if (current.languageCode == 'ca') {
      setCurrentLocale(const Locale('es'));
    } else {
      setCurrentLocale(const Locale('ca'));
    }
  }
}

/// Extensió per a facilitar la traducció de textos
extension TranslateExtension on String {
  /// Retorna la traducció d'aquest string
  String get tx => L.tx(this);
}