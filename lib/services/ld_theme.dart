// lib/services/ld_theme.dart
// Servei unificat per a la gestió de temes de l'aplicació
// CreatedAt: 2025/05/08 dj.
// Updated: 2025/05/08 dj. CLA - Correcció d'APIs deprecades

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:ld_wbench5/core/ld_taggable_mixin.dart';
import 'package:ld_wbench5/core/event_bus/event_bus.dart';
import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/utils/color_extensions.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Servei centralitzat per a la gestió de temes visuals
class LdTheme with LdTaggableMixin {
  /// Instància singleton
  static final LdTheme _inst = LdTheme._();
  static LdTheme get s => _inst;
  
  /// Mode del tema actual
  ThemeMode _themeMode = ThemeMode.system;
  /// Retorna el mode de tema actual
  ThemeMode get themeMode => _themeMode;
  /// Estableix el mode de tema
  set themeMode(ThemeMode pMode) => _themeMode = pMode;

  /// Flag que indica si el tema actual és fosc
  bool _isDarkMode = false;
  /// Retorna si el tema actual és fosc
  bool get isDarkMode => _isDarkMode;
  
  /// Tema actual
  late ThemeData _currentTheme;
  /// Retorna el tema actual
  ThemeData get currentTheme => _currentTheme;
  
  /// Constructor privat
  LdTheme._() {
    tag = className;
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
  
  // Colors auxiliars
  static final Color shadowColorLight = Colors.black.setOpacity(0.9);
  static final Color shadowColorDark = Colors.black.setOpacity(0.7);
  
  // Configuració comuna per als dos temes
  static final _buttonPadding = EdgeInsets.symmetric(horizontal: 2.0.w, vertical: 0.0.h);
  static final _buttonShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(8));
  static final _visualDensity = VisualDensity(horizontal: 0, vertical: -4);
  static final _inputBorderRadius = BorderRadius.circular(8);
  
  /// Retorna el tema clar
  ThemeData get lightTheme => _createLightTheme();
  
  /// Retorna el tema fosc
  ThemeData get darkTheme => _createDarkTheme();
  
  /// Canvia el mode del tema
  void changeThemeMode(ThemeMode mode) {
    Debug.info("$tag: Canviant mode de tema a ${mode.toString()}");
    
    // Verificar si el mode realment canvia
    if (_themeMode == mode) {
      Debug.info("$tag: El mode de tema ja és ${mode.toString()}, no cal canviar");
      return;  // Sortir si el mode no canvia
    }
    
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
    
    if (themeMode == ThemeMode.system) {
      // Si estem en mode sistema, canviem a fosc o clar depenent de l'actual
      changeThemeMode(_isDarkMode ? ThemeMode.light : ThemeMode.dark);
    } else {
      // Si ja estem en mode manual, alternem entre fosc i clar
      changeThemeMode(themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
    }
  }
  
  /// Notifica del canvi de tema
  void _notifyThemeChanged(ThemeData? oldTheme, ThemeData newTheme) {
    Debug.info("$tag: Notificant canvi de tema");
    
    // Emetre un event de canvi de tema
    EventBus.s.emit(LdEvent(
      eType: EventType.themeChanged,
      srcTag: tag,
      eData: {
        mfIsDarkMode: _isDarkMode,
        mfThemeMode: _themeMode.toString(),
      },
    ));
  }
  
  /// Crea el tema clar
  ThemeData _createLightTheme() {
    // Definim colors pels TextTheme
    final headlineColor = Colors.white;
    final bodyColor = Colors.black;
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryLight,
      colorScheme: const ColorScheme.light(
        primary: primaryLight,
        onPrimary: Colors.white,
        secondary: secondaryLight,
        onSecondary: Colors.black87,
        surface: surfaceLight,
        onSurface: Colors.black87,
        error: errorLight,
        onError: Colors.white, // No deprecat
      ),
      
      scaffoldBackgroundColor: backgroundLight,
      
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          color: headlineColor,
          fontSize: 14.0.sp,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: headlineColor,
          fontSize: 10.0.sp,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: headlineColor,
          fontSize: 8.0.sp,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          color: bodyColor,
          fontSize: 12.0.sp,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: TextStyle(
          color: bodyColor,
          fontSize: 10.0.sp,
          fontWeight: FontWeight.bold,
        ),
        bodySmall: TextStyle(
          color: bodyColor,
          fontSize: 8.0.sp,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(color: headlineColor),
      ),
      
      cardTheme: const CardTheme(
        color: surfaceLight,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
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
        toolbarTextStyle: const TextStyle(color: Colors.white),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: _visualDensity,
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(_buttonPadding),
          backgroundColor: primaryLight.toBackgroundProperty(
            disabled: primaryLight.lessVivid().setOpacity(0.6),
          ),
          foregroundColor: Colors.white.toForegroundProperty(
            disabled: Colors.white.setOpacity(0.6),
          ),
          elevation: WidgetStateProperty.all<double>(6),
          shadowColor: WidgetStateProperty.all<Color>(shadowColorLight),
          shape: WidgetStateProperty.all<OutlinedBorder>(_buttonShape),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: _visualDensity,
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(_buttonPadding),
          foregroundColor: Colors.black.toForegroundProperty(
            disabled: Colors.black.setOpacity(0.6),
          ),
          side: WidgetStateProperty.all<BorderSide>(
            BorderSide(color: primaryLight, width: 1.5),
          ),
          shape: WidgetStateProperty.all<OutlinedBorder>(_buttonShape),
        ),
      ),
      
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryLight,
        foregroundColor: Colors.white,
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
        fillColor: Colors.transparent,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: _inputBorderRadius,
          borderSide: const BorderSide(color: primaryLight, width: 1.2),
        ),
        
        enabledBorder: OutlineInputBorder(
          borderRadius: _inputBorderRadius,
          borderSide: const BorderSide(color: primaryLight, width: 1.2),
        ),
        
        focusedBorder: OutlineInputBorder(
          borderRadius: _inputBorderRadius,
          borderSide: const BorderSide(color: primaryLight, width: 2.5),
        ),
        
        errorBorder: OutlineInputBorder(
          borderRadius: _inputBorderRadius,
          borderSide: const BorderSide(color: errorLight, width: 1.2),
        ),
        
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: _inputBorderRadius,
          borderSide: const BorderSide(color: errorLight, width: 2.5),
        ),
        
        isDense: true,
        labelStyle: TextStyle(
          fontSize: 16.0.sp,
          color: primaryLight,
          fontWeight: FontWeight.normal,
        ),
        floatingLabelStyle: const TextStyle(
          color: primaryLight,
          fontWeight: FontWeight.bold,
        ),
        
        hintStyle: TextStyle(color: Colors.grey[500]),
        helperStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 10.0.sp,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
          color: Colors.white30,
          letterSpacing: 0.2,
        ),
        errorStyle: const TextStyle(color: errorLight, fontSize: 12.0),
        
        prefixIconColor: primaryLight,
        suffixIconColor: primaryLight,
      ),
      
      checkboxTheme: CheckboxThemeData(
        // Utilitzem les extensions per crear WidgetStateProperty
        fillColor: primaryLight.toBackgroundProperty(
          selected: primaryLight,
          unselected: Colors.grey[400],
        ),
        checkColor: WidgetStateProperty.all<Color>(Colors.white),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
        side: BorderSide(color: Colors.grey[400]!, width: 1.5),
      ),
      
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primaryLight,
        linearTrackColor: Colors.grey[200],
      ),
    );
  }
  
  /// Crea el tema fosc
  ThemeData _createDarkTheme() {
    // Definim colors pels TextTheme
    final textColor = Colors.white;
    
    // Color personalitzat per botó en tema fosc
    final buttonColorDark = const Color.fromARGB(255, 89, 124, 172);
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryDark,
      colorScheme: const ColorScheme.dark(
        primary: primaryDark,
        onPrimary: Colors.white,
        secondary: secondaryDark,
        onSecondary: Colors.white,
        surface: surfaceDark, 
        onSurface: Colors.white,
        error: errorDark,
        onError: Colors.black, // No deprecat
      ),
      
      scaffoldBackgroundColor: const Color(0xFF1E2433),
      
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          color: textColor,
          fontSize: 14.0.sp,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: textColor,
          fontSize: 10.0.sp,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: textColor,
          fontSize: 8.0.sp,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          color: textColor,
          fontSize: 12.0.sp,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: TextStyle(
          color: textColor,
          fontSize: 10.0.sp,
          fontWeight: FontWeight.bold,
        ),
        bodySmall: TextStyle(
          color: textColor,
          fontSize: 8.0.sp,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(color: textColor),
      ),
      
      cardTheme: const CardTheme(
        color: surfaceDark,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
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
        toolbarTextStyle: const TextStyle(color: Colors.white),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: _visualDensity,
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(_buttonPadding),
          backgroundColor: buttonColorDark.toBackgroundProperty(
            disabled: buttonColorDark.lessVivid().setOpacity(0.6),
          ),
          foregroundColor: Colors.white.toForegroundProperty(
            disabled: Colors.white.setOpacity(0.6),
          ),
          elevation: WidgetStateProperty.all<double>(8),
          shadowColor: WidgetStateProperty.all<Color>(shadowColorDark),
          shape: WidgetStateProperty.all<OutlinedBorder>(_buttonShape),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: _visualDensity,
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(_buttonPadding),
          foregroundColor: Colors.white.toForegroundProperty(
            disabled: Colors.white.setOpacity(0.6),
          ),
          side: WidgetStateProperty.all<BorderSide>(
            const BorderSide(color: Colors.lightBlueAccent, width: 1.5),
          ),
          shape: WidgetStateProperty.all<OutlinedBorder>(_buttonShape),
        ),
      ),
      
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryDark,
        foregroundColor: Colors.white,
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        fillColor: Colors.transparent,
        filled: true,
        
        border: OutlineInputBorder(
          borderRadius: _inputBorderRadius,
          borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 1.2),
        ),
        
        enabledBorder: OutlineInputBorder(
          borderRadius: _inputBorderRadius,
          borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 1.2),
        ),
        
        focusedBorder: OutlineInputBorder(
          borderRadius: _inputBorderRadius,
          borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2.5),
        ),
        
        errorBorder: OutlineInputBorder(
          borderRadius: _inputBorderRadius,
          borderSide: const BorderSide(color: errorDark, width: 1.2),
        ),
        
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: _inputBorderRadius,
          borderSide: const BorderSide(color: errorDark, width: 2.5),
        ),
        
        isDense: true,
        labelStyle: TextStyle(
          fontSize: 16.0.sp,
          color: Colors.lightBlueAccent,
          fontWeight: FontWeight.normal,
        ),
        floatingLabelStyle: TextStyle(
          fontSize: 20.0.sp,
          color: Colors.lightBlueAccent,
          fontWeight: FontWeight.bold,
        ),
        
        hintStyle: TextStyle(color: Colors.grey[400]),
        helperStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 10.sp,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
          color: Colors.white70,
          letterSpacing: 0.2,
        ),
        errorStyle: const TextStyle(color: errorDark, fontSize: 12.0),
        
        prefixIconColor: Colors.lightBlueAccent,
        suffixIconColor: Colors.lightBlueAccent,
      ),
      
      checkboxTheme: CheckboxThemeData(
        // Utilitzem les extensions per crear WidgetStateProperty
        fillColor: primaryDark.toBackgroundProperty(
          selected: primaryDark,
          unselected: Colors.grey[700],
        ),
        checkColor: WidgetStateProperty.all<Color>(Colors.white),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
        side: BorderSide(color: Colors.grey[700]!, width: 1.5),
      ),
      
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primaryDark,
        linearTrackColor: Colors.grey[800],
      ),
    );
  }
}