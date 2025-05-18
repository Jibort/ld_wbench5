// lib/services/theme_service.dart
// Servei centralitzat per a la gesti  de temes de l'aplicaci
// Created: 2025/05/09 dv. JIQ
// Updated: 2025/05/16 dv. CLA - Correcci  de la implementaci  del servei de temes
// Updated: 2025/05/18 ds. GEM - Inclusi  de surfaceVariant a ThemeColors i ColorScheme
// Updated: 2025/05/18 ds. GEM - Substituci  de surfaceVariant (deprecated) per surfaceContainerHighest
// Updated: 2025/05/18 ds. GEM - Correcci  de refer ncies a colors surfaceContainer i outline en CardTheme/DialogTheme
// Updated: 2025/05/18 ds. GEM - Ajustaments finals a la creació del ColorScheme i temes de components
// Updated: 2025/05/18 ds. GEM - Definici  de la vora de focus del Checkbox al ThemeService.
// Updated: 2025/05/18 ds. GEM - Correcció d'errors de tipatge i assignació de tipus en InputDecorationTheme i CardTheme.

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ld_wbench5/core/ld_taggable_mixin.dart';
import 'package:ld_wbench5/core/event_bus/event_bus.dart';
import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/ld_typedefs.dart';
import 'package:ld_wbench5/utils/debug.dart';
import 'package:ld_wbench5/core/extensions/color_extensions.dart';
import 'package:ld_wbench5/core/map_fields.dart';

// Llista de temes disponibles per seleccionar. Cal afegir els temes aquí a mesura que s'implementin.
const LstStrings themes = [
  themeDexeusClear,
  themeDexeusDark,
  // themeSabina, // Afegir si s'implementa
  // themeNatura, // Afegir si s'implementa
  // etc.
];

/// Defineix els colors principals d'un tema personalitzat segons les nostres necessitats.
/// Aquests colors es mapejaran a les propietats de ColorScheme i altres ThemeDatas.
class ThemeColors {
  final Color primary;
  final Color secondary;
  final Color surface; // Fons de components (cards, sheets, etc.) i Scaffold
  final Color text; // Color de text principal (onSurface, onBackground)
  final Color textSecondary; // Color de text secundari (onSurfaceVariant, hints, captions)
  final Color accent; // Color d'accent (pot mapejar a tertiary)
  final Color error;
  final Color onError; // Color per a text/icones sobre fons d'error


  const ThemeColors({
    required this.primary,
    required this.secondary,
    required this.surface,
    required this.text,
    required this.textSecondary,
    required this.accent,
    required this.error,
    required this.onError,
  });
}


/// Servei centralitzat per a la gesti  de temes visuals i modes (clar/fosc/sistema).
class ThemeService with LdTaggableMixin {
  // MEMBRES ESTÀTICS =====================================
  /// Instància singleton
  static final ThemeService _inst = ThemeService._();

  // GETTERS/SETTERS ESTÀTICS =============================
  /// Retorna la instància estàtica de ThemeService
  static ThemeService get s => _inst;

  // MEMBRES ==============================================
  /// Mode del tema actual (System, Light, Dark)
  final ValueNotifier<ThemeMode> _themeModeNotifier = ValueNotifier(ThemeMode.system);
  /// Nom del tema actual (p.ex. "ThemeDexeusClear", "ThemeSabina")
  final ValueNotifier<String> _currentThemeNotifier = ValueNotifier(themeDexeusClear); // Tema per defecte
  /// Mapa de temes clars, indexats per nom
  final LdMap<ThemeData> _lightThemes = {};
  /// Mapa de temes foscos, indexats per nom
  final LdMap<ThemeData> _darkThemes = {};


  // CONSTRUCTORS/DESTRUCTORS =============================
  /// Constructor privat
  ThemeService._() {
    tag = className;
    _initialize();
  }

  /// Inicialitza els temes i configuració del servei.
  void _initialize() {
    Debug.info("$tag: Inicialitzant servei de temes");

    // Determinar el mode inicial basant-se en la plataforma
    // Comencem en mode sistema per defecte
    _themeModeNotifier.value = ThemeMode.system;

    _createAllThemes(); // Crear tots els temes definits

    // Seleccionar el tema actual inicial. Verifiquem si el tema guardat existeix.
     if(!_lightThemes.containsKey(_currentThemeNotifier.value) && !_darkThemes.containsKey(_currentThemeNotifier.value)){ // <-- CORRECCIÓ aplicada
        // Si el tema guardat no existeix (p.ex. s'ha eliminat o és la primera execució),
        // usem el primer tema de la llista de temes disponibles o un per defecte absolut.
        _currentThemeNotifier.value = themes.isNotEmpty ? themes.first : themeDexeusClear;
        Debug.warn("$tag: Tema guardat inicial '${_currentThemeNotifier.value}' no trobat. Restablint a '${_currentThemeNotifier.value}'.");
     }
     _updateCurrentTheme(); // Actualitzar el tema actual basant-se en el mode i nom inicials.


    // Subscripció a canvis de brillantor de la plataforma si ThemeMode.system està actiu.
    // Aquesta subscripció assegura que la UI s'actualitza si l'usuari canvia el mode del sistema
    // mentre l'app està en execució i el mode del tema és ThemeMode.system.
    PlatformDispatcher.instance.onPlatformBrightnessChanged = () {
       if (_themeModeNotifier.value == ThemeMode.system) {
         Debug.info("$tag: Canvi de brillantor de la plataforma detectat. Actualitzant tema.");
         _updateCurrentTheme(); // Actualitzar el tema si el mode és sistema
         _notifyThemeChanged(); // Notificar el canvi a tota l'aplicació
       }
    };

    Debug.info("$tag: Servei de temes inicialitzat. Mode inicial: ${_themeModeNotifier.value}. Tema inicial: ${_currentThemeNotifier.value}");
  }

  /// Crea tots els objectes ThemeData disponibles per a cada tema i mode.
  void _createAllThemes() {
    Debug.info("$tag: Creant tots els temes definits...");

    // Colors per al tema Dexeus Clar
    final dexeusClearColors = ThemeColors(
      primary: const Color(0xFF005CAA), // Blau Dexeus
      secondary: const Color(0xFF666666), // Gris
      surface: const Color(0xFFFFFFFF), // Blanc
      text: const Color(0xFF000000), // Negre per text principal (onSurface)
      textSecondary: const Color(0xFF666666), // Gris per text secundari (onSurfaceVariant)
      accent: const Color(0xFF4A90E2), // Blau més clar per accent (tertiary)
      error: const Color(0xFFD32F2F), // Vermell per error
      onError: const Color(0xFFFFFFFF), // Blanc sobre error
    );

    // Colors per al tema Dexeus Fosc
    final dexeusDarkColors = ThemeColors(
      primary: const Color(0xFF4A90E2), // Blau Dexeus (més clar per fosc)
      secondary: const Color(0xFFAAAAAA), // Gris clar
      surface: const Color(0xFF1E1E1E), // Fons fosc gairebé negre
      text: const Color(0xFFE0E0E0), // Gris clar per text principal (onSurface)
      textSecondary: const Color(0xFFA0A0A0), // Gris més fosc per text secundari (onSurfaceVariant)
      accent: const Color(0xFF005CAA), // Blau més fosc per accent (tertiary)
      error: const Color(0xFFFF5252), // Vermell per error
      onError: const Color(0xFF000000), // Negre sobre error (o un gris molt fosc)
    );

    // TODO: Afegir aquí altres temes (Sabina, Natura, Foc, Custom1, Custom2) definint els ThemeColors corresponents

    // Creem els temes clars
    _lightThemes[themeDexeusClear] = _createTheme(
      isDark: false,
      colors: dexeusClearColors,
    );
    // TODO: Afegir altres temes clars si n'hi hagués (Sabina, Natura, Foc, Custom1, Custom2)

    // Creem els temes foscos
    _darkThemes[themeDexeusDark] = _createTheme(
      isDark: true,
      colors: dexeusDarkColors,
    );
     // TODO: Afegir altres temes foscos si n'hi hagués (Sabina Dark, Natura Dark, Foc Dark, Custom1 Dark, Custom2 Dark)

    Debug.info("$tag: Temes creados: ${_lightThemes.length} clars, ${_darkThemes.length} foscos.");
  }

  /// Crea un objecte ThemeData complet per a un mode (clar/fosc) basant-se en ThemeColors.
  /// Configura ColorScheme i altres temes de components comuns.
  ThemeData _createTheme({
    required bool isDark,
    required ThemeColors colors,
  }) {
    Debug.info("$tag: Creant ThemeData ${isDark ? 'fosc' : 'clar'} amb Primary: ${colors.primary.toHex()}");

    // Definició dels colors surfaceContainer (substitueixen surfaceVariant en molts casos)
    // Es calculen a partir del color `surface` base i ajustos de brillantor.
    final Color surfaceContainerLowest = isDark ? colors.surface.darker(0.1) : colors.surface.lighter(0.1);
    final Color surfaceContainerLow = isDark ? colors.surface.darker(0.05) : colors.surface.lighter(0.05);
    final Color surfaceContainer = colors.surface; // surfaceContainer pot ser igual a surface
    final Color surfaceContainerHigh = isDark ? colors.surface.lighter(0.05) : colors.surface.darker(0.05);
    final Color surfaceContainerHighest = isDark ? colors.surface.lighter(0.1) : colors.surface.darker(0.1); // Usat sovint per camps de text o superfícies elevades

    // Definició dels colors outline i outlineVariant
     final Color outlineColor = colors.textSecondary.setOpacity(0.5);
     final Color outlineVariantColor = colors.textSecondary.setOpacity(0.2);


    return ThemeData(
      brightness: isDark ? Brightness.dark : Brightness.light,
      primaryColor: colors.primary,
      // Utilitzem scaffoldBackgroundColor com a fons principal de les pantalles
      scaffoldBackgroundColor: colors.surface, // Utilitzem surface com a fons principal

      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: colors.primary,
        onPrimary: colors.onError, // Text/icones sobre primary (potser millor colors.text o colors.surface depenent del disseny exacte)
        primaryContainer: colors.primary.lighter(isDark ? 0.2 : 0.1), // Un to de primary per a contenidors
        onPrimaryContainer: colors.onError, // Text/icones sobre primaryContainer

        secondary: colors.secondary,
        onSecondary: colors.text, // Text/icones sobre secondary
        secondaryContainer: colors.secondary.lighter(isDark ? 0.2 : 0.1),
        onSecondaryContainer: colors.text,

        tertiary: colors.accent, // Utilitzem l'accent com a tertiary
        onTertiary: colors.surface, // Text/icones sobre tertiary
        tertiaryContainer: colors.accent.lighter(isDark ? 0.2 : 0.1),
        onTertiaryContainer: colors.surface,

        error: colors.error,
        onError: colors.onError, // Text/icones sobre error
        errorContainer: colors.error.lighter(isDark ? 0.2 : 0.1),
        onErrorContainer: colors.onError,

        surface: colors.surface, // Fons de components (cards, sheets, etc.)
        onSurface: colors.text, // Text/icones sobre surface

        // COLORS surfaceContainer (substitueixen surfaceVariant en molts casos)
        surfaceContainerLowest: surfaceContainerLowest,
        surfaceContainerLow: surfaceContainerLow,
        surfaceContainer: surfaceContainer,
        surfaceContainerHigh: surfaceContainerHigh,
        surfaceContainerHighest: surfaceContainerHighest,
        // surfaceVariant: ELIMINAT - ja no s'usa directament en ColorScheme
        onSurfaceVariant: colors.textSecondary, // Text/icones sobre surfaceContainer (sovint s'usa textSecondary)

        // background: colors.surface, // Background és deprecada, s'usa surface/scaffoldBackgroundColor
        // onBackground: colors.text, // onBackground és deprecada, s'usa onSurface

        // COLORS outline
        outline: outlineColor, // Utilitzem la variable local
        outlineVariant: outlineVariantColor, // Utilitzem la variable local

        shadow: Colors.black.setOpacity(0.3),
        scrim: Colors.black.setOpacity(0.6),
        inverseSurface: isDark ? colors.surface.lighter(0.3) : colors.surface.darker(0.3), // Invers de surface
        onInverseSurface: isDark ? colors.text.darker(0.3) : colors.text.lighter(0.3), // Text sobre inverseSurface
        inversePrimary: isDark ? colors.primary.darker(0.3) : colors.primary.lighter(0.3), // Invers de primary
        // Afegir altres colors si calgués segons l'especificació de ColorScheme de Material 3
      ),

      // TextTheme (utilitzant els colors text i textSecondary de ThemeColors)
      // Es mapegen els nostres colors text i textSecondary a les diferents jerarquies de text.
      textTheme: TextTheme(
        displayLarge: TextStyle( color: colors.text, fontSize: 24.sp, fontWeight: FontWeight.bold ),
        displayMedium: TextStyle( color: colors.text, fontSize: 22.sp, fontWeight: FontWeight.bold ),
        displaySmall: TextStyle( color: colors.text, fontSize: 20.sp, fontWeight: FontWeight.bold ),

        headlineLarge: TextStyle( color: colors.text, fontSize: 18.sp, fontWeight: FontWeight.w600 ),
        headlineMedium: TextStyle( color: colors.textSecondary, fontSize: 16.sp, fontWeight: FontWeight.w500 ), // Potser textSecondary per headlines menors
        headlineSmall: TextStyle( color: colors.textSecondary, fontSize: 14.sp, fontWeight: FontWeight.w500 ),


        titleLarge: TextStyle( color: colors.text, fontSize: 16.sp, fontWeight: FontWeight.bold ),
        titleMedium: TextStyle( color: colors.text, fontSize: 14.sp, fontWeight: FontWeight.w500 ),
        titleSmall: TextStyle( color: colors.textSecondary, fontSize: 12.sp, fontWeight: FontWeight.w500 ),


        bodyLarge: TextStyle( color: colors.text, fontSize: 14.sp ),
        bodyMedium: TextStyle( color: colors.textSecondary, fontSize: 12.sp ), // Potser textSecondary per body menors
        bodySmall: TextStyle( color: colors.textSecondary, fontSize: 10.sp ),


        labelLarge: TextStyle( color: colors.text, fontSize: 12.sp, fontWeight: FontWeight.bold ), // Botons, etc.
        labelMedium: TextStyle( color: colors.textSecondary, fontSize: 10.sp ),
        labelSmall: TextStyle( color: colors.textSecondary, fontSize: 8.sp ),

      ),

      // Exemples d'altres temes de components (adaptant a ThemeColors i ColorScheme)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(colors.primary), // Fons amb primary
          foregroundColor: WidgetStatePropertyAll(colors.onError), // Text/icones amb onError
          textStyle: WidgetStatePropertyAll(
             TextStyle(
               color: colors.onError, // El color del text es defineix a foregroundColor, però per consistència el posem aquí també.
               fontWeight: FontWeight.bold
             )
           ),
           // Afegir padding, shape, elevation, etc. si calgués (usant ThemeUtils o directament WidgetStateProperty)
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: colors.primary), // Etiqueta flotant amb primary
        hintStyle: TextStyle(color: colors.textSecondary), // Hint amb textSecondary
        filled: true,  // Afegim aquesta propietat
        fillColor: colors.surface, // colors.surface,  // Afegim aquesta propietat
        // Estils de vora
        border: OutlineInputBorder(
          borderSide: BorderSide(color: outlineColor), // <-- CORRECCIÓ: utilitzar borderSide
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
           borderSide: BorderSide(color: outlineColor), // <-- CORRECCIÓ: utilitzar borderSide
           borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colors.primary, width: 2), // <-- CORRECCIÓ: utilitzar borderSide
          borderRadius: BorderRadius.circular(8.0),
        ),
        errorBorder: OutlineInputBorder(
           borderSide: BorderSide(color: colors.error, width: 2), // <-- CORRECCIÓ: utilitzar borderSide
           borderRadius: BorderRadius.circular(8.0),
         ),
         focusedErrorBorder: OutlineInputBorder(
           borderSide: BorderSide(color: colors.error.darker(0.2), width: 2), // Aquesta propietat sí que es diu side
           borderRadius: BorderRadius.circular(8.0),
         ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: outlineColor.setOpacity(0.4)), // <-- CORRECCIÓ: utilitzar borderSide
           borderRadius: BorderRadius.circular(8.0),
        ),
         // Colors de farciment
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: colors.primary, // Fons de l'AppBar amb primary
        foregroundColor: colors.onError, // Color dels icones i text de l'AppBar amb onError
        titleTextStyle: TextStyle(
          color: colors.onError, // Color del títol amb onError
          fontSize: 20.sp,
          fontWeight: FontWeight.bold
        ),
         // Afegir altres propietats de l'AppBarTheme si calgués (iconTheme, actionsIconTheme, systemOverlayStyle, etc.)
      ),

      // CheckboxTheme (utilitzant primary i textSecondary/onSurface)
       checkboxTheme: CheckboxThemeData(
         fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.selected)) {
               return colors.primary; // Fons quan seleccionat amb primary
            }
            return outlineColor; // Utilitzem la variable local outlineColor per la vora no seleccionada per defecte
         }),
          checkColor: WidgetStateProperty.all<Color?>(colors.onError), // Color del "check" interior amb onError
          side:  BorderSide(color: outlineColor, width: 1.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)), // Forma
          // Podríem afegir altres propietats del tema del Checkbox (overlayColor, splashRadius, etc.)
       ),
       // Podríem afegir altres temes de components (Radio, Switch, Slider, Card, Dialog, etc.)
        cardTheme: CardTheme(
           color: surfaceContainerLow, // Utilitzem la variable local surfaceContainerLow
           elevation: 1.0,
           shape: RoundedRectangleBorder(
             side: BorderSide( // <-- CORRECCIÓ: La propietat dins de RoundedRectangleBorder es diu side. Correcte aquí.
                 color: outlineColor, // Utilitzem la variable local outlineColor
                 width: 1.0
             ),
             borderRadius: BorderRadius.circular(8.0),
           ),
        ),
         dialogTheme: DialogTheme(
            backgroundColor: surfaceContainerHigh, // Utilitzem la variable local surfaceContainerHigh
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
             titleTextStyle: TextStyle(color: colors.text, fontSize: 18.sp, fontWeight: FontWeight.bold),
             contentTextStyle: TextStyle(color: colors.textSecondary, fontSize: 14.sp),
         )
    );
  }


  /// Getters per accedir als temes (retornen el ThemeData complet)
  ThemeData get darkTheme {
    final themeName = _currentThemeNotifier.value;
    // Retorna el tema fosc seleccionat o el per defecte si no es troba
    return _darkThemes.containsKey(themeName)
       ? _darkThemes[themeName]!
       : _darkThemes[themeDexeusDark]!; // Fallback al tema fosc per defecte
  }

  ThemeData get lightTheme {
    final themeName = _currentThemeNotifier.value;
     // Retorna el tema clar seleccionat o el per defecte si no es troba
    return _lightThemes.containsKey(themeName)
       ? _lightThemes[themeName]!
       : _lightThemes[themeDexeusClear]!; // Fallback al tema clar per a defecte
  }


  /// Getters d'estat del servei de temes
  ThemeMode get themeMode => _themeModeNotifier.value;
  String get currentThemeName => _currentThemeNotifier.value;
  // La propietat isDarkMode depèn del themeMode i de la brillantor de la plataforma si el mode és system
  bool get isDarkMode {
     if (themeMode == ThemeMode.system) { // Correcte ús del getter themeMode
       return PlatformDispatcher.instance.platformBrightness == Brightness.dark;
     }
     return themeMode == ThemeMode.dark; // Correcte ús del getter themeMode
  }


  // FUNCIONALITAT ========================================
  /// Canvia el mode del tema (system, light, dark)
  void changeThemeMode(ThemeMode mode) {
    Debug.info("$tag: Canviant mode de tema a ${mode.toString()}");
    if (_themeModeNotifier.value == mode) return; // No fer res si ja és el mode actual

    _themeModeNotifier.value = mode;
    _updateCurrentTheme(); // Actualitzar el tema actual basant-se en el nou mode
    _notifyThemeChanged(); // Notificar canvi als subscriptors
  }

  /// Estableix el tema actual (per nom)
  void setCurrentTheme(String themeName) {
    Debug.info("$tag: Canviant tema a '$themeName'");
    if (_currentThemeNotifier.value == themeName) return; // No fer res si ja és el tema actual

    // Verificar que el tema existeix en ALGUN dels mapes de temes (clars o foscos)
    if (!_lightThemes.containsKey(themeName) && !_darkThemes.containsKey(themeName)) { // <-- CORRECCIÓ aplicada
      Debug.warn("$tag: El tema '$themeName' no existeix en els mapes de temes definits. No s'aplica el canvi.");
      return;
    }

    _currentThemeNotifier.value = themeName;
    _updateCurrentTheme(); // Actualitzar el ThemeData actual (encara que Flutter ho gestiona, mantenim la crida per claredat)
    _notifyThemeChanged(); // Notificar canvi
  }

  /// Alterna entre temes (si el mode és system, alterna light/dark segons la plataforma,
  /// si és light/dark, alterna entre light i dark)
  void toggleTheme() {
     Debug.info("$tag: Alternant tema...");
     if (themeMode == ThemeMode.system) {
       // Si estem en mode sistema, alternem el mode a light o dark
       changeThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
     } else {
       // Si estem en mode light/dark, simplement alternem entre light i dark
       changeThemeMode(themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
     }
  }

  /// Passa al tema següent en la llista predefinida de temes (la llista 'themes')
  void nextTheme() {
    Debug.info("$tag: Passant al tema següent en la llista definida...");
    // Cercar l'índex del tema actual en la llista 'themes'
    int currentIndex = themes.indexOf(_currentThemeNotifier.value);

    if (currentIndex == -1) {
       // Si el tema actual no és a la llista 'themes', anar al primer de la llista
       Debug.warn("$tag: Tema actual '${_currentThemeNotifier.value}' no trobat a la llista 'themes'. Anant al primer tema de la llista.");
       setCurrentTheme(themes.isNotEmpty ? themes.first : themeDexeusClear); // Anar al primer o al per defecte
    } else {
      // Calcular l'índex del següent tema (circular)
      int nextIndex = (currentIndex + 1) % themes.length;
      // Establir el següent tema
      setCurrentTheme(themes[nextIndex]);
    }
  }

   /// Actualitza el ThemeData actual basant-se en el mode i nom de tema seleccionats
   /// Nota: Flutter ja gestiona quin ThemeData (lightTheme o darkTheme) utilitzar
   /// basant-se en themeMode i la brillantor de la plataforma. Aquest mètode
   /// principalment crida a _notifyThemeChanged per forçar les reconstruccions de la UI.
   void _updateCurrentTheme() {
     Debug.info("$tag: Actualitzant tema actiu a mode ${themeMode.toString()} i nom $currentThemeName.");
     // Notificar canvi per forçar la UI a utilitzar el nou tema
     // _notifyThemeChanged() ja es crida des de changeThemeMode i setCurrentTheme
   }


  /// Notifica canvis de tema a través de l'EventBus
  void _notifyThemeChanged() {
    Debug.info("$tag: Notificant canvi de tema via EventBus.");
    EventBus.s.emit(LdEvent(
      eType: EventType.themeChanged,
      srcTag: tag,
      eData: {
        efIsDarkMode: isDarkMode, // Notifiquem si el tema resultant és fosc o clar
        efThemeMode: themeMode.toString(), // Notifiquem el mode seleccionat (system, light, dark)
        efThemeName: currentThemeName, // Notifiquem el nom del tema seleccionat (Sabina, DexeusClar, etc.)
      },
    ));
  }

  // Podríem afegir mètodes per carregar/guardar la preferència de tema a SharedPreferences o similar
  // Future<void> loadThemePreference() async { ... }
  // Future<void> saveThemePreference() async { ... }

  // Mètode dispose per alliberar recursos si calgués (p.ex., cancel·lar timers, listeners externs)
  // @override
  // void dispose() {
  //   PlatformDispatcher.instance.onPlatformBrightnessChanged = null; // Eliminar listener
  //   Debug.info("$tag: Servei de temes alliberat.");
  // }

}