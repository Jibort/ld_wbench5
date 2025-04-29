// theme_service.dart
// Servei de gestió de temes simplificat
// Created: 2025/04/29 dt. CLA[JIQ]

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:ld_wbench5/core/taggable_mixin.dart';
import 'package:ld_wbench5/core/event_system.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Servei centralitzat per a la gestió de temes visuals
class ThemeService with LdTaggable {
  /// Instància singleton
  static final ThemeService _instance = ThemeService._();
  static ThemeService get instance => _instance;
  
  /// Mode del tema actual
  ThemeMode _themeMode = ThemeMode.system;
  
  /// Flag que indica si el tema actual és fosc
  bool _isDarkMode = false;
  
  /// Tema actual
  late ThemeData _currentTheme;
  
  /// Constructor privat
  ThemeService._() {
    setTag('ThemeService');
    _initialize();
  }
  
  /// Inicialitza el servei de temes
  void _initialize() {
    Debug.info("$tag: Inicialitzant servei de temes");
    
    // Detectar el mode actual del sistema
    final platformBrightness = PlatformDispatcher.instance.platformBrightness;
    _isDarkMode = platformBrightness == Brightness.dark;
    
    // Inicialitzar _themeMode basat en la configuració del sistema
    _themeMode = _isDarkMode ? ThemeMode.dark : ThemeMode.light;
    
    // Assignar tema inicial
    _currentTheme = _isDarkMode ? darkTheme : lightTheme;
    
    // Emetre event inicial
    _notifyThemeChanged(null, _currentTheme);
  }
  
  /// Retorna el mode de tema actual
  ThemeMode get themeMode => _themeMode;
  
  /// Retorna si el tema actual és fosc
  bool get isDarkMode => _isDarkMode;
  
  /// Retorna el tema actual
  ThemeData get currentTheme => _currentTheme;
  
  /// Retorna el tema clar
  ThemeData get lightTheme => _createLightTheme();
  
  /// Retorna el tema fosc
  ThemeData get darkTheme => _createDarkTheme();
  
  /// Canvia el mode del tema
  void changeThemeMode(ThemeMode mode) {
    Debug.info("$tag: Canviant mode de tema a ${mode.toString()}");
    
    _themeMode = mode;
    _isDarkMode = (mode == ThemeMode.system)
        ? PlatformDispatcher.instance.platformBrightness == Brightness.dark
        : (mode == ThemeMode.dark);
    
    ThemeData oldTheme = _currentTheme;
    _currentTheme = _isDarkMode ? darkTheme : lightTheme;
    
    // Notificar del canvi de tema
    _notifyThemeChanged(oldTheme, _currentTheme);
  }
  
  /// Alterna entre els temes clar i fosc
  void toggleTheme() {
    Debug.info("$tag: Alternant tema");
    
    if (_themeMode == ThemeMode.system) {
      // Si estem en mode sistema, canviem a fosc o clar depenent de l'actual
      changeThemeMode(_isDarkMode ? ThemeMode.light : ThemeMode.dark);
    } else {
      // Si ja estem en mode manual, alternem entre fosc i clar
      changeThemeMode(_themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
    }
  }
  
  /// Notifica del canvi de tema
  void _notifyThemeChanged(ThemeData? oldTheme, ThemeData newTheme) {
    Debug.info("$tag: Notificant canvi de tema");
    
    EventBus().emit(SabinaEvent(
      type: EventType.themeChanged,
      sourceTag: tag,
      data: {
        mfIsDarkMode: _isDarkMode,
        mfThemeMode: _themeMode.toString(),
      },
    ));
  }
  
  /// COLORS CONSTANTS DE REFERÈNCIA
  // Blau mitjà de la barra de navegació
  static const Color primaryLight = Color(0xFF4B70A5);
  // Blau fosc de la capçalera
  static const Color primaryDark = Color(0xFF2D3B57);
  // To daurat/ataronjat del fons de la imatge
  static const Color secondaryLight = Color(0xFFE8C074);
  // To daurat més fosc
  static const Color secondaryDark = Color(0xFFD9A440);
  // Gris molt clar
  static const Color backgroundLight = Color(0xFFF5F5F5);
  // Blau molt fosc
  static const Color backgroundDark = Color(0xFF273042);
  // Blanc
  static const Color surfaceLight = Color(0xFFFFFFFF);
  // Blau fosc grisós
  static const Color surfaceDark = Color(0xFF2F3A52);
  // Vermell
  static const Color errorLight = Color(0xFFB00020);
  // Rosa vermellós
  static const Color errorDark = Color(0xFFCF6679);
  
  /// Crea el tema clar
  ThemeData _createLightTheme() {
    return ThemeData.light().copyWith(
      colorScheme: ColorScheme.light(
        primary: primaryLight,
        onPrimary: Colors.white,
        secondary: secondaryLight,
        onSecondary: Colors.black87,
        surface: surfaceLight,
        onSurface: Colors.black87,
        error: errorLight,
        onError: Colors.white,
      ),
      
      scaffoldBackgroundColor: backgroundLight,
      
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          color: Colors.white,
          fontSize: 14.0.sp,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: Colors.white,
          fontSize: 10.0.sp,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: Colors.white,
          fontSize: 8.0.sp,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          color: Colors.black,
          fontSize: 12.0.sp,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: TextStyle(
          color: Colors.black,
          fontSize: 10.0.sp,
          fontWeight: FontWeight.bold,
        ),
        bodySmall: TextStyle(
          color: Colors.black,
          fontSize: 8.0.sp,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(color: Colors.white),
      ),
      
      appBarTheme: AppBarTheme(
        backgroundColor: primaryLight,
        foregroundColor: Colors.white,
        elevation: 4,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20.0.sp,
          fontWeight: FontWeight.bold,
        ),
        toolbarTextStyle: TextStyle(color: Colors.white),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryLight,
          foregroundColor: Colors.white,
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
  
  /// Crea el tema fosc
  ThemeData _createDarkTheme() {
    return ThemeData.dark().copyWith(
      colorScheme: ColorScheme.dark(
        primary: primaryDark,
        onPrimary: Colors.white,
        secondary: secondaryDark,
        onSecondary: Colors.white,
        surface: surfaceDark,
        onSurface: Colors.white,
        error: errorDark,
        onError: Colors.black,
      ),
      
      scaffoldBackgroundColor: Color(0xFF1E2433),
      
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          color: Colors.white,
          fontSize: 14.0.sp,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: Colors.white,
          fontSize: 10.0.sp,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: Colors.white,
          fontSize: 8.0.sp,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          color: Colors.white,
          fontSize: 12.0.sp,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: TextStyle(
          color: Colors.white,
          fontSize: 10.0.sp,
          fontWeight: FontWeight.bold,
        ),
        bodySmall: TextStyle(
          color: Colors.white,
          fontSize: 8.0.sp,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(color: Colors.white),
      ),
      
      appBarTheme: AppBarTheme(
        backgroundColor: primaryDark,
        foregroundColor: Colors.white,
        elevation: 4,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20.0.sp,
          fontWeight: FontWeight.bold,
        ),
        toolbarTextStyle: TextStyle(color: Colors.white),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 89, 124, 172),
          foregroundColor: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}