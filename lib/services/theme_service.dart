// lib/services/theme_service.dart
// Servei centralitzat per a la gestió de temes de l'aplicació
// Created: 2025/05/09 dv. JIQ
// Updated: 2025/05/16 dv. CLA - Correcció de la implementació del servei de temes

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:ld_wbench5/core/ld_taggable_mixin.dart';
import 'package:ld_wbench5/core/event_bus/event_bus.dart';
import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/ld_typedefs.dart';
import 'package:ld_wbench5/utils/debug.dart';

const String themeDexeusClear  = "ThemeDexeusClear";
const String themeDexeusDark   = "ThemeDexeusDark";

const LstStrings themes = [
  themeDexeusClear,
  themeDexeusDark,
];

class ThemeColors {
  final Color primary;
  final Color secondary;
  final Color surface;
  final Color surfaceVariant;
  final Color text;
  final Color textSecondary;
  final Color accent;
  final Color error;

  const ThemeColors({
    required this.primary,
    required this.secondary,
    required this.surface,
    required this.surfaceVariant,
    required this.text,
    required this.textSecondary,
    required this.accent,
    required this.error,
  });
}

class ThemeService with LdTaggableMixin {
  // MEMBRES ESTÀTICS =====================================
  /// Instància singleton
  static final ThemeService _inst = ThemeService._();
  
  // GETTERS/SETTERS ESTÀTICS =============================
  /// Retorna la instància estàtica de ThemeService
  static ThemeService get s => _inst;

  // Constructor privat
  ThemeService._() {
    tag = className;
    _initialize();
  }

  // MEMBRES ==============================================
  /// Mode del tema actual
  final ValueNotifier<ThemeMode> _themeModeNotifier = ValueNotifier(ThemeMode.system);
  
  /// Nom del tema actual
  final ValueNotifier<String> _currentThemeNotifier = ValueNotifier(themeDexeusClear);
  
  /// Mapa de temes clars
  final LdMap<ThemeData> _lightThemes = {};
  
  /// Mapa de temes foscos
  final LdMap<ThemeData> _darkThemes = {};

  /// Inicialitza els temes
  void _initialize() {
    Debug.info("$tag: Inicialitzant servei de temes");
    
    final platformBrightness = PlatformDispatcher.instance.platformBrightness;
    _themeModeNotifier.value = platformBrightness == Brightness.dark 
      ? ThemeMode.dark 
      : ThemeMode.light;
    
    _createAllThemes();
    Debug.info("$tag: Servei de temes inicialitzat");
  }

  /// Crea tots els temes disponibles
  void _createAllThemes() {
    final dexeusClearColors = ThemeColors(
      primary: const Color(0xFF005CAA),     
      secondary: const Color(0xFF666666),   
      surface: const Color(0xFFFFFFFF),     
      surfaceVariant: const Color(0xFFF2F2F2), 
      text: const Color(0xFF000000),        
      textSecondary: const Color(0xFF666666), 
      accent: const Color(0xFF4A90E2),      
      error: const Color(0xFFD32F2F),       
    );

    final dexeusDarkColors = ThemeColors(
      primary: const Color(0xFF4A90E2),     
      secondary: const Color(0xFFAAAAAA),   
      surface: const Color(0xFF1E1E1E),     
      surfaceVariant: const Color(0xFF2C2C2C), 
      text: const Color(0xFFE0E0E0),        
      textSecondary: const Color(0xFFA0A0A0), 
      accent: const Color(0xFF005CAA),      
      error: const Color(0xFFFF5252),       
    );
    
    _lightThemes[themeDexeusClear] = _createTheme(
      isDark: false,
      colors: dexeusClearColors,
    );
    
    _darkThemes[themeDexeusDark] = _createTheme(
      isDark: true,
      colors: dexeusDarkColors,
    );
  }

  /// Getters per accedir als temes
  ThemeData get darkTheme {
    final themeName = _currentThemeNotifier.value;
    return _darkThemes.containsKey(themeName) 
      ? _darkThemes[themeName]! 
      : _darkThemes[themeDexeusDark]!;
  }

  ThemeData get lightTheme {
    final themeName = _currentThemeNotifier.value;
    return _lightThemes.containsKey(themeName) 
      ? _lightThemes[themeName]! 
      : _lightThemes[themeDexeusClear]!;
  }
  // CLA[JIQ]_11: ThemeData get darkTheme => _darkThemes[_currentThemeNotifier.value]!;
  // CLA[JIQ]_11: ThemeData get lightTheme => _lightThemes[_currentThemeNotifier.value]!;

  /// Getters d'estat
  ThemeMode get themeMode => _themeModeNotifier.value;
  String get currentThemeName => _currentThemeNotifier.value;
  bool get isDarkMode => themeMode == ThemeMode.dark;

  /// Canvia el mode del tema
  void changeThemeMode(ThemeMode mode) {
    if (_themeModeNotifier.value == mode) return;
    
    _themeModeNotifier.value = mode;
    _notifyThemeChanged();
  }

  /// Estableix el tema actual
  void setCurrentTheme(String themeName) {
    if (_currentThemeNotifier.value == themeName) return;
    
    _currentThemeNotifier.value = themeName;
    _notifyThemeChanged();
  }

  /// Alterna entre temes
  void toggleTheme() {
    if (themeMode == ThemeMode.system) {
      changeThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
    } else {
      changeThemeMode(themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
    }
  }

  /// Passa al tema següent
  void nextTheme() {
    int currentIndex = themes.indexOf(_currentThemeNotifier.value);
    int nextIndex = (currentIndex + 1) % themes.length;
    setCurrentTheme(themes[nextIndex]);
  }

  /// Notifica canvis de tema
  void _notifyThemeChanged() {
    EventBus.s.emit(LdEvent(
      eType: EventType.themeChanged,
      srcTag: tag,
      eData: {
        'themeMode': themeMode.toString(),
        'themeName': currentThemeName,
        'isDarkMode': isDarkMode,
      },
    ));
  }

  /// Crea un tema personalitzat
  ThemeData _createTheme({
    required bool isDark,
    required ThemeColors colors,
  }) {
    return ThemeData(
      brightness: isDark ? Brightness.dark : Brightness.light,
      primaryColor: colors.primary,
      
      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: colors.primary,
        secondary: colors.secondary,
        surface: colors.surface,
        error: colors.error,
        
        onPrimary: colors.surface,
        onSecondary: colors.text,
        onSurface: colors.text,
        onError: colors.surface,
      ),
      
      scaffoldBackgroundColor: colors.surface,
      
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: colors.text, 
          fontSize: 24.sp, 
          fontWeight: FontWeight.bold
        ),
        displayMedium: TextStyle(
          color: colors.text, 
          fontSize: 22.sp, 
          fontWeight: FontWeight.bold
        ),
        displaySmall: TextStyle(
          color: colors.text, 
          fontSize: 20.sp, 
          fontWeight: FontWeight.bold
        ),
        headlineLarge: TextStyle(
          color: colors.text, 
          fontSize: 18.sp, 
          fontWeight: FontWeight.w600
        ),
        headlineMedium: TextStyle(
          color: colors.textSecondary, 
          fontSize: 16.sp, 
          fontWeight: FontWeight.w500
        ),
        bodyLarge: TextStyle(
          color: colors.text, 
          fontSize: 14.sp
        ),
        bodyMedium: TextStyle(
          color: colors.textSecondary, 
          fontSize: 12.sp
        ),
        bodySmall: TextStyle(
          color: colors.textSecondary, 
          fontSize: 10.sp
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(colors.primary),
          foregroundColor: WidgetStatePropertyAll(colors.surface),
          textStyle: WidgetStatePropertyAll(
            TextStyle(
              color: colors.surface, 
              fontWeight: FontWeight.bold
            )
          ),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: colors.primary),
        hintStyle: TextStyle(color: colors.textSecondary),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: colors.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colors.secondary),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
      ),
      
      appBarTheme: AppBarTheme(
        backgroundColor: colors.primary,
        foregroundColor: colors.surface,
        titleTextStyle: TextStyle(
          color: colors.surface, 
          fontSize: 20.sp, 
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}

// // lib/services/theme_service.dart
// // Servei centralitzat per a la gestió de temes de l'aplicació
// // Created: 2025/05/16 dv. CLA
// // Updated: 2025/05/16 dv. CLA - Refactorització del servei de temes

// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import 'package:ld_wbench5/core/ld_taggable_mixin.dart';
// import 'package:ld_wbench5/core/event_bus/event_bus.dart';
// import 'package:ld_wbench5/core/event_bus/ld_event.dart';
// import 'package:ld_wbench5/core/ld_typedefs.dart';
// import 'package:ld_wbench5/core/map_fields.dart';
// import 'package:ld_wbench5/utils/debug.dart';

// /// Classe que defineix els colors principals d'un tema
// class ThemeColors {
//   final Color primary;
//   final Color primaryDark;
//   final Color secondary;
//   final Color secondaryDark;
//   final Color background;
//   final Color backgroundDark;
//   final Color surface;
//   final Color surfaceDark;
//   final Color error;
//   final Color errorDark;

//   const ThemeColors({
//     required this.primary,
//     required this.primaryDark,
//     required this.secondary,
//     required this.secondaryDark, 
//     required this.background,
//     required this.backgroundDark,
//     required this.surface,
//     required this.surfaceDark,
//     required this.error,
//     required this.errorDark,
//   });
// }

// /// Servei centralitzat per a la gestió de temes visuals
// class ThemeService 
// with  LdTaggableMixin {
//   // MEMBRES ESTÀTICS =====================================
//   /// Instància singleton
//   static final ThemeService _inst = ThemeService._();
  
//   // GETTERS/SETTERS ESTÀTICS =============================
//   /// Retorna la instància estàtica de ThemeService.
//   static ThemeService get s => _inst;

//   // MEMBRES ==============================================
//   /// Mode del tema actual
//   ThemeMode _themeMode = ThemeMode.system;
  
//   /// Flag que indica si el tema actual és fosc
//   bool _isDarkMode = false;

//   /// Nom del tema actual
//   String _currentThemeName = themeSabina;

//   /// Tema actual
//   late ThemeData _currentTheme;
  
//   /// Temes clars per nom
//   final LdMap<ThemeData> _lightThemes = {};
  
//   /// Temes foscos per nom
//   final LdMap<ThemeData> _darkThemes = {};

//   // CONSTRUCTORS/DESTRUCTORS =============================
//   /// Constructor privat
//   ThemeService._() {
//     tag = className;
//     _initialize();
//   }

//   /// Inicialitza els temes i configuració
//   void _initialize() {
//     Debug.info("$tag: Inicialitzant servei de temes");
    
//     final platformBrightness = PlatformDispatcher.instance.platformBrightness;
//     _isDarkMode = platformBrightness == Brightness.dark;
    
//     _themeMode = _isDarkMode ? ThemeMode.dark : ThemeMode.light;
    
//     _createAllThemes();
    
//     _currentTheme = _isDarkMode ? darkTheme : lightTheme;
    
//     _notifyThemeChanged(null, _currentTheme);
    
//     Debug.info("$tag: Servei de temes inicialitzat");
//   }

//   /// Crea tots els temes disponibles
//   void _createAllThemes() {
//     final sabinaColors = ThemeColors(
//       primary: const Color(0xFF4B70A5),
//       primaryDark: const Color(0xFF2D3B57),
//       secondary: const Color(0xFFE8C074),
//       secondaryDark: const Color(0xFFD9A440),
//       background: const Color(0xFFF5F5F5),
//       backgroundDark: const Color(0xFF273042),
//       surface: const Color(0xFFFFFFFF),
//       surfaceDark: const Color(0xFF2F3A52),
//       error: const Color(0xFFB00020),
//       errorDark: const Color(0xFFCF6679),
//     );
    
//     _createThemeSet(themeSabina, sabinaColors);
//     _createThemeSet(themeNatura, _buildNaturalTheme());
//     _createThemeSet(themeFire, _buildFireTheme());
//     _createThemeSet(themeNight, _buildNightTheme());
//     _createThemeSet(themeCustom1, sabinaColors);
//     _createThemeSet(themeCustom2, sabinaColors);
//   }

//   /// Crea un conjunt de temes (clar i fosc) per a un tema específic
//   void _createThemeSet(String pName, ThemeColors pColors) {
//     _lightThemes[pName] = _createTheme(
//       isDark: false,
//       primary: pColors.primary,
//       primaryDark: pColors.primaryDark,
//       secondary: pColors.secondary,
//       secondaryDark: pColors.secondaryDark,
//       background: pColors.background,
//       backgroundDark: pColors.backgroundDark,
//       surface: pColors.surface,
//       surfaceDark: pColors.surfaceDark,
//       error: pColors.error,
//       errorDark: pColors.errorDark,
//     );
    
//     _darkThemes[pName] = _createTheme(
//       isDark: true,
//       primary: pColors.primaryDark,
//       primaryDark: pColors.primaryDark,
//       secondary: pColors.secondaryDark,
//       secondaryDark: pColors.secondaryDark,
//       background: pColors.backgroundDark,
//       backgroundDark: pColors.backgroundDark,
//       surface: pColors.surfaceDark,
//       surfaceDark: pColors.surfaceDark,
//       error: pColors.errorDark,
//       errorDark: pColors.errorDark,
//     );
//   }

//   // GETTERS/SETTERS ======================================
//   /// Mode del tema actual
//   ThemeMode get themeMode => _themeMode;
  
//   /// Si el tema actual és fosc
//   bool get isDarkMode => _isDarkMode;
  
//   /// Nom del tema actual
//   String get currentThemeName => _currentThemeName;
  
//   /// Tema actual
//   ThemeData get currentTheme => _currentTheme;
  
//   /// Tema clar actual
//   ThemeData get lightTheme => _lightThemes[_currentThemeName]!;
  
//   /// Tema fosc actual
//   ThemeData get darkTheme => _darkThemes[_currentThemeName]!;

//   /// Estableix el mode del tema
//   set themeMode(ThemeMode pMode) => changeThemeMode(pMode);
  
//   /// Estableix el nom del tema
//   set currentThemeName(String pName) {
//     if (_currentThemeName != pName) {
//       _currentThemeName = pName;
//       _updateCurrentTheme();
//     }
//   }

//   // FUNCIONALITAT ========================================
//   /// Canvia el mode del tema
//   void changeThemeMode(ThemeMode pMode) {
//     if (_themeMode == pMode) return;
    
//     _themeMode = pMode;
//     _isDarkMode = (pMode == ThemeMode.system)
//         ? PlatformDispatcher.instance.platformBrightness == Brightness.dark
//         : (pMode == ThemeMode.dark);
    
//     ThemeData oldTheme = _currentTheme;
//     _currentTheme = _isDarkMode ? darkTheme : lightTheme;
    
//     _notifyThemeChanged(oldTheme, _currentTheme);
//   }

//   /// Alterna entre temes clar i fosc
//   void toggleTheme() {
//     if (themeMode == ThemeMode.system) {
//       changeThemeMode(_isDarkMode ? ThemeMode.light : ThemeMode.dark);
//     } else {
//       changeThemeMode(themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
//     }
//   }

//   /// Passa al tema següent
//   void nextTheme() {
//     int currentIndex = themes.indexOf(_currentThemeName);
//     int nextIndex = (currentIndex + 1) % themes.length;
//     currentThemeName = themes[nextIndex];
//   }

//   /// Actualitza un tema personalitzat
//   void updateCustomTheme(String pThemeName, ThemeColors pColors) {
//     if (pThemeName != themeCustom1 && pThemeName != themeCustom2) {
//       Debug.error("$tag: No es pot modificar un tema predefinit");
//       return;
//     }
    
//     _createThemeSet(pThemeName, pColors);
    
//     if (_currentThemeName == pThemeName) {
//       _updateCurrentTheme();
//     }
//   }

//   /// Notifica el canvi de tema
//   void _notifyThemeChanged(ThemeData? pOld, ThemeData pNew) {
//     EventBus.s.emit(LdEvent(
//       eType: EventType.themeChanged,
//       srcTag: tag,
//       eData: {
//         'isDarkMode': _isDarkMode,
//         'themeMode': _themeMode.toString(),
//         'themeName': _currentThemeName,
//       },
//     ));
//   }

//   /// Actualitza el tema actual
//   void _updateCurrentTheme() {
//     ThemeData oldTheme = _currentTheme;
//     _currentTheme = _isDarkMode ? darkTheme : lightTheme;
    
//     _notifyThemeChanged(oldTheme, _currentTheme);
//   }

//   // MÈTODES PRIVATS DE CONSTRUCCIÓ DE TEMES ==============
//   /// Construeix tema de natura
//   ThemeColors _buildNaturalTheme() {
//     return ThemeColors(
//       primary: const Color(0xFF2E7D32),
//       primaryDark: const Color(0xFF1B5E20),
//       secondary: const Color(0xFFFDD835),
//       secondaryDark: const Color(0xFFF9A825),
//       background: const Color(0xFFF1F8E9),
//       backgroundDark: const Color(0xFF1B2A1B),
//       surface: const Color(0xFFFFFFFF),
//       surfaceDark: const Color(0xFF263226),
//       error: const Color(0xFFB00020),
//       errorDark: const Color(0xFFCF6679),
//     );
//   }

//   /// Construeix tema de foc
//   ThemeColors _buildFireTheme() {
//     return ThemeColors(
//       primary: const Color(0xFFE64A19),
//       primaryDark: const Color(0xFFBF360C),
//       secondary: const Color(0xFFFFD54F),
//       secondaryDark: const Color(0xFFFFB300),
//       background: const Color(0xFFFBE9E7),
//       backgroundDark: const Color(0xFF2D1A16),
//       surface: const Color(0xFFFFFFFF),
//       surfaceDark: const Color(0xFF3E2723),
//       error: const Color(0xFFB00020),
//       errorDark: const Color(0xFFCF6679),
//     );
//   }

//   /// Construeix tema de nit
//   ThemeColors _buildNightTheme() {
//     return ThemeColors(
//       primary: const Color(0xFF512DA8),
//       primaryDark: const Color(0xFF311B92),
//       secondary: const Color(0xFF7C4DFF),
//       secondaryDark: const Color(0xFF651FFF),
//       background: const Color(0xFFF3E5F5),
//       backgroundDark: const Color(0xFF1A1221),
//       surface: const Color(0xFFFFFFFF),
//       surfaceDark: const Color(0xFF2A1D36),
//       error: const Color(0xFFB00020),
//       errorDark: const Color(0xFFCF6679),
//     );
//   }

//   /// Crea un tema personalitzat
//   ThemeData _createTheme({
//     required bool isDark,
//     required Color primary,
//     required Color primaryDark,
//     required Color secondary,
//     required Color secondaryDark,
//     required Color background,
//     required Color backgroundDark,
//     required Color surface,
//     required Color surfaceDark,
//     required Color error,
//     required Color errorDark,
//   }) {
//     // Configuració de colors i estils
//     final buttonPadding = EdgeInsets.symmetric(horizontal: 2.0.w, vertical: 0.0.h);
//     final buttonShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(8));
    
//     return ThemeData(
//       brightness: isDark ? Brightness.dark : Brightness.light,
//       primaryColor: primary,
//       scaffoldBackgroundColor: background,
      
//       colorScheme: isDark 
//         ? ColorScheme.dark(
//             primary: primary,
//             secondary: secondary,
//             surface: surface,
//             error: error,
//           )
//         : ColorScheme.light(
//             primary: primary,
//             secondary: secondary,
//             surface: surface,
//             error: error,
//           ),
      
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ButtonStyle(
//           backgroundColor: WidgetStatePropertyAll(primary),
//           padding: WidgetStatePropertyAll(buttonPadding),
//           shape: WidgetStatePropertyAll(buttonShape),
//         ),
//       ),
//     );
//   }
// }