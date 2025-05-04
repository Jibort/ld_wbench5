// L.dart
// Servei d'internacionalització simplificat
// Created: 2025/04/29 dt. CLA[JIQ]

import 'package:flutter/material.dart';
import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/ld_taggable_mixin.dart';
import 'package:ld_wbench5/core/event_bus/event_bus.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/utils/map_extensions.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Servei centralitzat per a la gestió d'idiomes
class L 
with  LdTaggableMixin {
  /// Constants de les claus de text
  static const String sSabina = "sSabina";
  static const String sAppSabina = "sAppSabina";
  static const String sWelcome = "sWelcome";
  static const String sChangeLanguage = "sChangeLanguage";
  static const String sChangeTheme = "sChangeTheme";
  
  /// Instància singleton
  static final L _inst = L._();
  static L get s => _inst;
  
  /// Idioma detectat al dispositiu
  late Locale _deviceLocale;
  
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
    s._currentLocale = Locale(languageCode);
    Debug.info("${s.tag}: Idioma canviat de ${oldLocale?.languageCode ?? 'null'} a $languageCode");
    
    // Notifica del canvi d'idioma
    EventBus.s.emit(LdEvent(
      eType: EventType.languageChanged,
      srcTag: s.tag,
      eData: {
        mfOldLocale: oldLocale?.languageCode,
        mfNewLocale: s._currentLocale!.languageCode,
      },
    ));

    // NOVA línia: Emetre event de reconstrucció global
    EventBus.s.emit(LdEvent(
      eType: EventType.rebuildUI,
      srcTag: s.tag,
    ));
  }
  
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
    };
    
    // Espanyol
    _dictionaries['es'] = {
      sSabina: "Sabina",
      sAppSabina: "Aplicación Sabina",
      sWelcome: "Bienvenido/a",
      sChangeLanguage: "Cambiar Idioma",
      sChangeTheme: "Cambiar Tema",
    };
    
    // Anglès
    _dictionaries['en'] = {
      sSabina: "Sabina",
      sAppSabina: "Sabina Application",
      sWelcome: "Welcome",
      sChangeLanguage: "Change Language",
      sChangeTheme: "Change Theme",
    };
  }
  
  /// Obté la traducció d'una clau
  static String tx(String key) {
    Locale locale = getCurrentLocale();
    Dictionary? dictionary = s._dictionaries[locale.languageCode];
    return dictionary?.getOr(key, '!?') ?? '!?';
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