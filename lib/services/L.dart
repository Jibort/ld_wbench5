// lib/services/L.dart
// Servei centralitzat per a la gesti  d'idiomes
// Updated: 2025/05/15 dc. GPT(JIQ)
// Updated: 2025/05/18 ds. CLA - Afegides claus per a TestPage2
// Updated: 2025/05/18 ds. GEM - Afegides claus per a contenidors anidats a TestPage2

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/L10n/string_tx.dart';
import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/ld_taggable_mixin.dart';
import 'package:ld_wbench5/core/event_bus/event_bus.dart';
import 'package:ld_wbench5/core/ld_typedefs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
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

  // Claus afegides per a TestPage2 (Contenidors de primer nivell)
  static const String sToggleAllContainers = "##sToggleAllContainers";
  static const String sBasicComponents = "##sBasicComponents";
  static const String sBasicComponentsSubtitle = "##sBasicComponentsSubtitle";
  static const String sInputComponents = "##sInputComponents";
  static const String sInputComponentsSubtitle = "##sInputComponentsSubtitle";
  static const String sMoreInputComponents = "##sMoreInputComponents";
  static const String sThemeComponents = "##sThemeComponents";
  static const String sThemeComponentsSubtitle = "##sThemeComponentsSubtitle";
  static const String sThemeComponentsPlaceholder = "##sThemeComponentsPlaceholder";
  static const String sAdvancedComponents = "##sAdvancedComponents";
  static const String sAdvancedComponentsSubtitle = "##sAdvancedComponentsSubtitle";
  static const String sAdvancedComponentsPlaceholder = "##sAdvancedComponentsPlaceholder";
  static const String sFoldableContainerDemo = "##sFoldableContainerDemo";
  static const String sFoldableContainerDemoSubtitle = "##sFoldableContainerDemoSubtitle";
  static const String sFoldableContainerDemoPlaceholder = "##sFoldableContainerDemoPlaceholder";

  // Claus afegides per a TestPage2 (Contenidors anidats)
  static const String sNestedContainerTitle1 = "##sNestedContainerTitle1";
  static const String sNestedContainerSubtitle1 = "##sNestedContainerSubtitle1";
  static const String sNestedContainerContent1 = "##sNestedContainerContent1";
  static const String sNestedContainerTitle2 = "##sNestedContainerTitle2";
  static const String sNestedContainerSubtitle2 = "##sNestedContainerSubtitle2";
  static const String sNestedContainerContent2 = "##sNestedContainerContent2";


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
    //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: Servei inicialitzat");
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

    // Emitir event de canvi d'idioma per notificar als components
    EventBus.s.emit(
      LdEvent(
        eType: EventType.languageChanged,
        srcTag: s.tag,
        eData: {
          efOldLocale: oldLocale?.languageCode,
          efNewLocale: s._currentLocale!.languageCode,
        },
      ),
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

      // Traduccions per a TestPage2 (Contenidors de primer nivell - Català)
      sToggleAllContainers: "Alternar Tots els Contenidors",
      sBasicComponents: "Components Bàsics",
      sBasicComponentsSubtitle: "Labels, Buttons, etc.",
      sInputComponents: "Components d'Entrada",
      sInputComponentsSubtitle: "TextField, Checkbox, etc.",
      sMoreInputComponents: "Més components d'entrada en desenvolupament...",
      sThemeComponents: "Components de Tema",
      sThemeComponentsSubtitle: "ThemeSelector, ThemeViewer, etc.",
      sThemeComponentsPlaceholder: "Components de tema en desenvolupament...",
      sAdvancedComponents: "Components Avançats",
      sAdvancedComponentsSubtitle: "Lists, Messages, etc.",
      sAdvancedComponentsPlaceholder: "Components avançats en desenvolupament...",
      sFoldableContainerDemo: "Demo de Contenidors Plegables",
      sFoldableContainerDemoSubtitle: "Diferents estils i configuracions",
      sFoldableContainerDemoPlaceholder: "Exemples de contenidors en desenvolupament...",

      // Traduccions per a TestPage2 (Contenidors anidats - Català)
      sNestedContainerTitle1: "Contenidor Anidat 1",
      sNestedContainerSubtitle1: "Primer exemple anidat",
      sNestedContainerContent1: "Contingut del primer contenidor anidat.",
      sNestedContainerTitle2: "Contenidor Anidat 2",
      sNestedContainerSubtitle2: "Segon exemple anidat",
      sNestedContainerContent2: "Contingut del segon contenidor anidat.",
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

      // Traduccions per a TestPage2 (Contenidors de primer nivell - Espanyol)
      sToggleAllContainers: "Alternar Todos los Contenedores",
      sBasicComponents: "Componentes Básicos",
      sBasicComponentsSubtitle: "Labels, Buttons, etc.",
      sInputComponents: "Componentes de Entrada",
      sInputComponentsSubtitle: "TextField, Checkbox, etc.",
      sMoreInputComponents: "Más componentes de entrada en desarrollo...",
      sThemeComponents: "Componentes de Tema",
      sThemeComponentsSubtitle: "ThemeSelector, ThemeViewer, etc.",
      sThemeComponentsPlaceholder: "Componentes de tema en desarrollo...",
      sAdvancedComponents: "Componentes Avanzados",
      sAdvancedComponentsSubtitle: "Lists, Messages, etc.",
      sAdvancedComponentsPlaceholder: "Componentes avanzados en desarrollo...",
      sFoldableContainerDemo: "Demo de Contenedores Plegables",
      sFoldableContainerDemoSubtitle: "Diferentes estilos y configuraciones",
      sFoldableContainerDemoPlaceholder: "Ejemplos de contenedores en desarrollo...",

      // Traduccions per a TestPage2 (Contenidors anidats - Espanyol)
      sNestedContainerTitle1: "Contenedor Anidado 1",
      sNestedContainerSubtitle1: "Primer ejemplo anidado",
      sNestedContainerContent1: "Contenido del primer contenedor anidado.",
      sNestedContainerTitle2: "Contenedor Anidado 2",
      sNestedContainerSubtitle2: "Segundo ejemplo anidado",
      sNestedContainerContent2: "Contenido del segundo contenedor anidado.",
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

      // Traduccions per a TestPage2 (Contenidors de primer nivell - Anglès)
      sToggleAllContainers: "Toggle All Containers",
      sBasicComponents: "Basic Components",
      sBasicComponentsSubtitle: "Labels, Buttons, etc.",
      sInputComponents: "Input Components",
      sInputComponentsSubtitle: "TextField, Checkbox, etc.",
      sMoreInputComponents: "More input components in development...",
      sThemeComponents: "Theme Components",
      sThemeComponentsSubtitle: "ThemeSelector, ThemeViewer, etc.",
      sThemeComponentsPlaceholder: "Theme components in development...",
      sAdvancedComponents: "Advanced Components",
      sAdvancedComponentsSubtitle: "Lists, Messages, etc.",
      sAdvancedComponentsPlaceholder: "Advanced components in development...",
      sFoldableContainerDemo: "Foldable Container Demo",
      sFoldableContainerDemoSubtitle: "Different styles and configurations",
      sFoldableContainerDemoPlaceholder: "Container examples in development...",

      // Traduccions per a TestPage2 (Contenidors anidats - Anglès)
      sNestedContainerTitle1: "Nested Container 1",
      sNestedContainerSubtitle1: "First nested example",
      sNestedContainerContent1: "Content of the first nested container.",
      sNestedContainerTitle2: "Nested Container 2",
      sNestedContainerSubtitle2: "Second nested example",
      sNestedContainerContent2: "Content of the second nested container.",
    });
  }

  // TRADUCCIÓ ===========================================
  static String tx(
    String key, [
    Strings? posArgs = const [],
    LdMap<String>? namedArgs = const {}
  ]) {
    posArgs ??= const [];
    namedArgs ??= const {};

    // Si no és una clau de traducció (no comença amb ##), només aplicar interpolació
    if (!key.startsWith("##")) {
      return StringTx.applyInterpolation(key, posArgs, namedArgs);
    }

    // És una clau de traducció
    Locale locale = getCurrentLocale();
    Dictionary? dictionary = s._dictionaries[locale.languageCode];
    String baseKey = key.extractKey;
    String translation = dictionary?.getOr(baseKey, errInText) ?? errInText;

    if (translation == errInText) {
      Debug.warn("L.tx: Translation key '$baseKey' not found in '${locale.languageCode}' dictionary");
    } else {
      //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("L.tx: Translated '$baseKey' to '$translation' in '${locale.languageCode}'");
    }

    // Aplicar interpolació a la traducció
    return StringTx.applyInterpolation(translation, posArgs, namedArgs);
  }

  // TOGGLE ==============================================
  static void toggleLanguage() {
    Locale current = getCurrentLocale();
    if (current.languageCode == 'ca') {
      setCurrentLocale(const Locale('es'));
    } else if (current.languageCode == 'es') {
       // Opcionalment, afegir 'en' si es vol rotar entre 3 idiomes
       // setCurrentLocale(const Locale('en'));
       setCurrentLocale(const Locale('ca')); // Tornar a català si només hi ha ca/es
    }
     // else if (current.languageCode == 'en') {
     //   setCurrentLocale(const Locale('ca'));
     // }
     else {
       // Fallback per a idiomes no gestionats
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
