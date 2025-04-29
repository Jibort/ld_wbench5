// L.dart
// Servei d'internacionalització simplificat
// Created: 2025/04/29 dt. CLA[JIQ]

import 'package:flutter/material.dart';
import 'package:ld_wbench5/core/ld_taggable_mixin.dart';
import 'package:ld_wbench5/core/event_system.dart';
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
  static L get inst => _inst;
  
  /// Idioma detectat al dispositiu
  late Locale _deviceLocale;
  
  /// Idioma actual de l'aplicació
  Locale? _currentLocale;
  
  /// Diccionaris disponibles
  final Map<String, Dictionary> _dictionaries = {};
  
  /// Constructor privat
  L._() {
    tag = className;
    _loadDictionaries();
    Debug.info("$tag: Servei inicialitzat");
  }
  
  /// Retorna l'idioma del dispositiu
  static Locale get deviceLocale => inst._deviceLocale;
  
  /// Estableix l'idioma del dispositiu
  static set deviceLocale(Locale locale) {
    inst._deviceLocale = locale;
    Debug.info("${inst.tag}: Idioma del dispositiu detectat: ${locale.languageCode}");
    if (inst._currentLocale == null) {
      setCurrentLocale(locale);
    }
  }
  
  /// Retorna l'idioma actual
  static Locale getCurrentLocale() {
    if (inst._currentLocale == null) {
      inst._currentLocale = inst._deviceLocale;
      // Si el diccionari de l'idioma del dispositiu no existeix, usa espanyol
      if (!inst._dictionaries.containsKey(inst._currentLocale!.languageCode)) {
        inst._currentLocale = const Locale('es');
      }
    }
    return inst._currentLocale!;
  }
  
  /// Estableix l'idioma actual
  static void setCurrentLocale(Locale locale) {
    String languageCode = locale.languageCode;
    if (!inst._dictionaries.containsKey(languageCode)) {
      languageCode = 'es'; // Fallback a espanyol si l'idioma no està disponible
      Debug.info("${inst.tag}: Idioma $languageCode no disponible, usant 'es' per defecte");
    }
    
    Locale? oldLocale = inst._currentLocale;
    inst._currentLocale = Locale(languageCode);
    Debug.info("${inst.tag}: Idioma canviat de ${oldLocale?.languageCode ?? 'null'} a $languageCode");
    
    // Notifica del canvi d'idioma
    EventBus().emit(LdEvent(
      type: EventType.languageChanged,
      srcTag: inst.tag,
      data: {
        mfOldLocale: oldLocale?.languageCode,
        mfNewLocale: inst._currentLocale!.languageCode,
      },
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
    Dictionary? dictionary = inst._dictionaries[locale.languageCode];
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