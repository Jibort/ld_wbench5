// lib/services/ld_theme.dart
// Servei unificat per a la gestió de temes de l'aplicació
// Created: 2025/05/08 dj.
// Actualitzat: 2025/05/08 dj. CLA - Refactorització completa

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:ld_wbench5/core/ld_taggable_mixin.dart';
import 'package:ld_wbench5/core/event_bus/event_bus.dart';
import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/core/extensions/color_extensions.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Noms dels temes personalitzats disponibles
enum ThemeName {
  /// Tema predeterminat de l'aplicació (blau/daurat)
  sabina,
  
  /// Tema alternatiu amb tonalitats verdes
  natura,
  
  /// Tema amb tons vermells/taronja
  foc,
  
  /// Tema amb tons lila/violeta
  nit,
  
  /// Tema personalitzat 1
  custom1,
  
  /// Tema personalitzat 2
  custom2
}

/// Classe que defineix els colors principals d'un tema
class ThemeColors {
  final Color primary;
  final Color primaryDark;
  final Color secondary;
  final Color secondaryDark;
  final Color background;
  final Color backgroundDark;
  final Color surface;
  final Color surfaceDark;
  final Color error;
  final Color errorDark;

  const ThemeColors({
    required this.primary,
    required this.primaryDark,
    required this.secondary,
    required this.secondaryDark, 
    required this.background,
    required this.backgroundDark,
    required this.surface,
    required this.surfaceDark,
    required this.error,
    required this.errorDark,
  });
}

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

  /// Nom del tema actual
  ThemeName _currentThemeName = ThemeName.sabina;
  /// Retorna el nom del tema actual
  ThemeName get currentThemeName => _currentThemeName;
  /// Estableix el tema actual per nom
  set currentThemeName(ThemeName pName) {
    if (_currentThemeName != pName) {
      _currentThemeName = pName;
      _updateCurrentTheme();
    }
  }
  
  /// Tema actual
  late ThemeData _currentTheme;
  /// Retorna el tema actual
  ThemeData get currentTheme => _currentTheme;
  
  /// Temes clars per nom
  final Map<ThemeName, ThemeData> _lightThemes = {};
  
  /// Temes foscos per nom
  final Map<ThemeName, ThemeData> _darkThemes = {};
  
  /// Retorna el tema clar actual
  ThemeData get lightTheme => _lightThemes[_currentThemeName]!;
  
  /// Retorna el tema fosc actual
  ThemeData get darkTheme => _darkThemes[_currentThemeName]!;
  
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
    
    // Crear tots els temes disponibles
    _createAllThemes();
    
    // Assignar tema inicial
    _currentTheme = _isDarkMode ? darkTheme : lightTheme;
    
    // Emetre event inicial
    _notifyThemeChanged(null, _currentTheme);
    
    Debug.info("$tag: Servei de temes inicialitzat amb ${_lightThemes.length} temes");
  }
  
  /// Crea tots els temes disponibles
  void _createAllThemes() {
    // Tema principal Sabina (blau/daurat)
    final sabinaColors = ThemeColors(
      primary: const Color(0xFF4B70A5),       // Blau mitjà
      primaryDark: const Color(0xFF2D3B57),   // Blau fosc
      secondary: const Color(0xFFE8C074),     // Daurat clar
      secondaryDark: const Color(0xFFD9A440), // Daurat fosc
      background: const Color(0xFFF5F5F5),    // Gris molt clar
      backgroundDark: const Color(0xFF273042),// Blau molt fosc
      surface: const Color(0xFFFFFFFF),       // Blanc
      surfaceDark: const Color(0xFF2F3A52),   // Blau fosc grisós
      error: const Color(0xFFB00020),         // Vermell
      errorDark: const Color(0xFFCF6679),     // Rosa vermellós
    );
    
    // Tema Natura (verd)
    final naturaColors = ThemeColors(
      primary: const Color(0xFF2E7D32),       // Verd mitjà
      primaryDark: const Color(0xFF1B5E20),   // Verd fosc
      secondary: const Color(0xFFFDD835),     // Groc
      secondaryDark: const Color(0xFFF9A825), // Groc fosc
      background: const Color(0xFFF1F8E9),    // Verd molt clar
      backgroundDark: const Color(0xFF1B2A1B),// Verd molt fosc
      surface: const Color(0xFFFFFFFF),       // Blanc
      surfaceDark: const Color(0xFF263226),   // Verd fosc grisós
      error: const Color(0xFFB00020),         // Vermell
      errorDark: const Color(0xFFCF6679),     // Rosa vermellós
    );
    
    // Tema Foc (vermell/taronja)
    final focColors = ThemeColors(
      primary: const Color(0xFFE64A19),       // Taronja mitjà
      primaryDark: const Color(0xFFBF360C),   // Taronja fosc
      secondary: const Color(0xFFFFD54F),     // Groc
      secondaryDark: const Color(0xFFFFB300), // Groc daurat
      background: const Color(0xFFFBE9E7),    // Vermell molt clar
      backgroundDark: const Color(0xFF2D1A16),// Vermell molt fosc
      surface: const Color(0xFFFFFFFF),       // Blanc
      surfaceDark: const Color(0xFF3E2723),   // Marró fosc
      error: const Color(0xFFB00020),         // Vermell
      errorDark: const Color(0xFFCF6679),     // Rosa vermellós
    );
    
    // Tema Nit (lila/violeta)
    final nitColors = ThemeColors(
      primary: const Color(0xFF512DA8),       // Lila mitjà
      primaryDark: const Color(0xFF311B92),   // Lila fosc
      secondary: const Color(0xFF7C4DFF),     // Lila clar
      secondaryDark: const Color(0xFF651FFF), // Lila intens
      background: const Color(0xFFF3E5F5),    // Lila molt clar
      backgroundDark: const Color(0xFF1A1221),// Lila molt fosc
      surface: const Color(0xFFFFFFFF),       // Blanc
      surfaceDark: const Color(0xFF2A1D36),   // Lila fosc grisós
      error: const Color(0xFFB00020),         // Vermell
      errorDark: const Color(0xFFCF6679),     // Rosa vermellós
    );
    
    // Crear tots els temes i guardar-los per nom
    _createThemeSet(ThemeName.sabina, sabinaColors);
    _createThemeSet(ThemeName.natura, naturaColors);
    _createThemeSet(ThemeName.foc, focColors);
    _createThemeSet(ThemeName.nit, nitColors);
    
    // Crear temes custom (copiem els predeterminats per ara)
    _createThemeSet(ThemeName.custom1, sabinaColors);
    _createThemeSet(ThemeName.custom2, naturaColors);
  }
  
  /// Crea un conjunt de temes (clar i fosc) a partir d'un esquema de colors
  void _createThemeSet(ThemeName name, ThemeColors colors) {
    _lightThemes[name] = _createTheme(
      isDark: false,
      primary: colors.primary,
      primaryDark: colors.primaryDark,
      secondary: colors.secondary,
      secondaryDark: colors.secondaryDark,
      background: colors.background,
      backgroundDark: colors.backgroundDark,
      surface: colors.surface,
      surfaceDark: colors.surfaceDark,
      error: colors.error,
      errorDark: colors.errorDark,
    );
    
    _darkThemes[name] = _createTheme(
      isDark: true,
      primary: colors.primary,
      primaryDark: colors.primaryDark,
      secondary: colors.secondary,
      secondaryDark: colors.secondaryDark,
      background: colors.background,
      backgroundDark: colors.backgroundDark,
      surface: colors.surface,
      surfaceDark: colors.surfaceDark,
      error: colors.error,
      errorDark: colors.errorDark,
    );
  }
  
  /// Actualitza el tema actual basant-se en el nom del tema i el mode
  void _updateCurrentTheme() {
    ThemeData oldTheme = _currentTheme;
    _currentTheme = _isDarkMode ? darkTheme : lightTheme;
    
    _notifyThemeChanged(oldTheme, _currentTheme);
  }
  
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
  
  /// Canvia al tema següent en la llista de temes disponibles
  void nextTheme() {
    Debug.info("$tag: Canviant al tema següent");
    
    // Obtenir els valors de l'enum i trobar l'índex actual
    List<ThemeName> values = ThemeName.values;
    int currentIndex = values.indexOf(_currentThemeName);
    
    // Calcular el següent índex (amb rotació)
    int nextIndex = (currentIndex + 1) % values.length;
    
    // Canviar al tema següent
    currentThemeName = values[nextIndex];
    
    Debug.info("$tag: Tema canviat de ${values[currentIndex]} a ${values[nextIndex]}");
  }
  
  /// Retorna el nom del tema en format llegible
  String getThemeNameString(ThemeName name) {
    switch (name) {
      case ThemeName.sabina:
        return "Sabina";
      case ThemeName.natura:
        return "Natura";
      case ThemeName.foc:
        return "Foc";
      case ThemeName.nit:
        return "Nit";
      case ThemeName.custom1:
        return "Personalitzat 1";
      case ThemeName.custom2:
        return "Personalitzat 2";
    }
  }
  
  /// Actualitza un tema personalitzat amb nous colors
  void updateCustomTheme(ThemeName themeName, ThemeColors colors) {
    // Verificar que és un tema personalitzable
    if (themeName != ThemeName.custom1 && themeName != ThemeName.custom2) {
      Debug.error("$tag: No es pot modificar un tema predefinit");
      return;
    }
    
    // Recrear el tema amb els nous colors
    _createThemeSet(themeName, colors);
    
    // Si és el tema actual, actualitzar-lo
    if (_currentThemeName == themeName) {
      _updateCurrentTheme();
    }
    
    Debug.info("$tag: Tema personalitzat ${getThemeNameString(themeName)} actualitzat");
  }
  
  /// Notifica del canvi de tema
  void _notifyThemeChanged(ThemeData? oldTheme, ThemeData newTheme) {
    Debug.info("$tag: Notificant canvi de tema");
    
    // Emetre un event de canvi de tema
    EventBus.s.emit(LdEvent(
      eType: EventType.themeChanged,
      srcTag: tag,
      eData: {
        efIsDarkMode: _isDarkMode,
        efThemeMode:  _themeMode.toString(),
        efThemeName:  _currentThemeName.toString(),
      },
    ));
  }
  
  /// Crea un tema basant-se en els colors proporcionats
  ThemeData _createTheme({
    required bool isDark,
    required Color primary,
    required Color primaryDark,
    required Color secondary,
    required Color secondaryDark,
    required Color background,
    required Color backgroundDark,
    required Color surface,
    required Color surfaceDark,
    required Color error,
    required Color errorDark,
  }) {
    // Configuració comuna per als dos temes
    final buttonPadding = EdgeInsets.symmetric(horizontal: 2.0.w, vertical: 0.0.h);
    final buttonShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(8));
    final visualDensity = VisualDensity(horizontal: 0, vertical: -4);
    final inputBorderRadius = BorderRadius.circular(8);
    
    // Determinar quines variants de colors utilitzar
    final themeColor = isDark ? primaryDark : primary;
    final secondaryColor = isDark ? secondaryDark : secondary;
    final backgroundColor = isDark ? backgroundDark : background;
    final surfaceColor = isDark ? surfaceDark : surface;
    final errorColor = isDark ? errorDark : error;
    
    // Colors per elements específics
    final shadowColor = Colors.black.setOpacity(isDark ? 0.7 : 0.9);
    
    // Colors pels TextTheme
    final headlineColor = isDark ? Colors.white : Colors.white; // Sempre blanc per encapçalats
    final bodyColor = isDark ? Colors.white : Colors.black;     // Blanc en fosc, negre en clar
    
    // Color personalitzat per botó en tema fosc
    final buttonColor = isDark 
        ? Color.fromARGB(255, 89, 124, 172) // Més clar en tema fosc
        : themeColor;                        // Color primari en tema clar
    
    // Crear el ThemeData apropiat
    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      primaryColor: themeColor,
      
      colorScheme: isDark
          ? ColorScheme.dark(
              primary: themeColor,
              onPrimary: Colors.white,
              secondary: secondaryColor,
              onSecondary: Colors.white,
              surface: surfaceColor,
              onSurface: Colors.white,
              error: errorColor,
              onError: Colors.black,
            )
          : ColorScheme.light(
              primary: themeColor,
              onPrimary: Colors.white,
              secondary: secondaryColor,
              onSecondary: Colors.black87,
              surface: surfaceColor,
              onSurface: Colors.black87,
              error: errorColor,
              onError: Colors.white,
            ),
      
      scaffoldBackgroundColor: backgroundColor,
      
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
      
      cardTheme: CardTheme(
        color: surfaceColor,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
      ),
      
      appBarTheme: AppBarTheme(
        backgroundColor: themeColor,
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
          visualDensity: visualDensity,
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(buttonPadding),
          backgroundColor: buttonColor.toBackgroundProperty(
            disabled: buttonColor.lessVivid().setOpacity(0.6),
          ),
          foregroundColor: (isDark ? Colors.white : Colors.white).toForegroundProperty(
            disabled: Colors.white.setOpacity(0.6),
          ),
          elevation: WidgetStateProperty.all<double>(isDark ? 8 : 6),
          shadowColor: WidgetStateProperty.all<Color>(shadowColor),
          shape: WidgetStateProperty.all<OutlinedBorder>(buttonShape),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: visualDensity,
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(buttonPadding),
          foregroundColor: (isDark ? Colors.white : Colors.black).toForegroundProperty(
            disabled: (isDark ? Colors.white : Colors.black).setOpacity(0.6),
          ),
          side: WidgetStateProperty.all<BorderSide>(
            BorderSide(
              color: isDark ? Colors.lightBlueAccent : themeColor, 
              width: 1.5
            ),
          ),
          shape: WidgetStateProperty.all<OutlinedBorder>(buttonShape),
        ),
      ),
      
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.symmetric(
          vertical: isDark ? 16.0 : 8.h, 
          horizontal: isDark ? 20.0 : 4.w
        ),
        fillColor: Colors.transparent,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: inputBorderRadius,
          borderSide: BorderSide(
            color: isDark ? Colors.lightBlueAccent : themeColor, 
            width: 1.2
          ),
        ),
        
        enabledBorder: OutlineInputBorder(
          borderRadius: inputBorderRadius,
          borderSide: BorderSide(
            color: isDark ? Colors.lightBlueAccent : themeColor, 
            width: 1.2
          ),
        ),
        
        focusedBorder: OutlineInputBorder(
          borderRadius: inputBorderRadius,
          borderSide: BorderSide(
            color: isDark ? Colors.lightBlueAccent : themeColor, 
            width: 2.5
          ),
        ),
        
        errorBorder: OutlineInputBorder(
          borderRadius: inputBorderRadius,
          borderSide: BorderSide(color: errorColor, width: 1.2),
        ),
        
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: inputBorderRadius,
          borderSide: BorderSide(color: errorColor, width: 2.5),
        ),
        
        isDense: true,
        labelStyle: TextStyle(
          fontSize: 16.0.sp,
          color: isDark ? Colors.lightBlueAccent : themeColor,
          fontWeight: FontWeight.normal,
        ),
        floatingLabelStyle: TextStyle(
          fontSize: isDark ? 20.0.sp : null,
          color: isDark ? Colors.lightBlueAccent : themeColor,
          fontWeight: FontWeight.bold,
        ),
        
        hintStyle: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[500]),
        helperStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 10.0.sp,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
          color: isDark ? Colors.white70 : Colors.white30,
          letterSpacing: 0.2,
        ),
        errorStyle: TextStyle(color: errorColor, fontSize: 12.0),
        
        prefixIconColor: isDark ? Colors.lightBlueAccent : themeColor,
        suffixIconColor: isDark ? Colors.lightBlueAccent : themeColor,
      ),
      
      checkboxTheme: CheckboxThemeData(
        // Utilitzem les extensions per crear WidgetStateProperty
        fillColor: themeColor.toBackgroundProperty(
          selected: themeColor,
          unselected: isDark ? Colors.grey[700] : Colors.grey[400],
        ),
        checkColor: WidgetStateProperty.all<Color>(Colors.white),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
        side: BorderSide(
          color: isDark ? Colors.grey[700]! : Colors.grey[400]!, 
          width: 1.5
        ),
      ),
      
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: themeColor,
        linearTrackColor: isDark ? Colors.grey[800] : Colors.grey[200],
      ),
    );
  }
}

// Servei ThemeService ara redirigeix a LdTheme
// Mantenim la classe per compatibilitat, però està obsoleta
class ThemeService {
  // Redirigir a la instància de LdTheme
  static LdTheme get s => LdTheme.s;
}