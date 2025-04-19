// ld_theme.dart
//
// Controlador unificat per a la gestió de temes de l'aplicació.
// CreatedAt: 2025/03/07 dv.

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ld_wbench5/03_core/interfaces/ld_tag_intf.dart';
import 'package:ld_wbench5/03_core/ld_model.dart';
import 'package:ld_wbench5/03_core/mixins/ld_tag_mixin.dart';
import 'package:ld_wbench5/03_core/mixins/stream_emitter_mixin.dart';
import 'package:ld_wbench5/03_core/streams/stream_envelope.dart';
import 'package:ld_wbench5/08_theme/events/theme_model.dart';
import 'package:ld_wbench5/10_tools/once_set.dart';

class      LdTheme 
with       LdTagMixin, 
           StreamEmitterMixin<StreamEnvelope<LdModel>, LdModel>
implements LdTagIntf {
  // 📝 SINGLETON ----------------------
  static final OnceSet<LdTheme> _single = OnceSet<LdTheme>(pInst: LdTheme());
  static LdTheme get single => _single.get();

  // 🧩 MEMBRES ------------------------  
  late ThemeMode _themeMode = ThemeMode.system;
  late bool _isDarkMode = false;
  late ThemeData _currentTheme;

  // 🛠️ CONSTRUCTOR/DISPOSE -----------
  LdTheme() {
    registerTag(pTag: "LdTheme", pInst: this);
    init();
  }

  /// 🌥️ FUNCIONALITAT ----------------
  void init() {
    // Detectar el mode actual del sistema
    final platformBrightness = PlatformDispatcher.instance.platformBrightness;
    _isDarkMode = platformBrightness == Brightness.dark;

    // Inicialitzar _themeMode basat en la configuració del sistema
    _themeMode = _isDarkMode ? ThemeMode.dark : ThemeMode.light;
    
    // Assignar tema inicial
    _currentTheme = _isDarkMode ? darkTheme : lightTheme;
    
    // Emetre l'event inicial
    send(
      ThemeEventModel.envelope(
        pSrc: tag,
        pModel: ThemeEventModel(
          null, 
          _currentTheme,
        )
      )
    );
  }

  // 📥 GETTERS/SETTERS ----------------
  ThemeMode get themeMode        => _themeMode;
  bool      get isDarkMode       => _isDarkMode;
  ThemeData get currentThemeData => _currentTheme;
  

  // 🎨 DEFINICIÓ DE TEMES -------------
  // COLORS CONSTANTS DE REFERÈNCIA
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

  // TEMA CLAR ------------------------
  ThemeData get lightTheme => _lightTheme;

  final ThemeData _lightTheme = ThemeData.light().copyWith(
    // Esquema de colors principals
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

    // Colors específics per a components
    scaffoldBackgroundColor: backgroundLight,

    textTheme: TextTheme(
      // Específicament canviem l'estil del títol a blanc
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

      // També afegim l'estil per a subtítols
      titleLarge: TextStyle(color: Colors.white),
    ),

    cardTheme: CardTheme(
      color: surfaceLight,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
        padding: EdgeInsets.symmetric(horizontal: 2.0.w, vertical: 0.0.h),
        backgroundColor: primaryLight,
        foregroundColor: Colors.white,
        elevation: 6, // Més elevació en tema clar (6)
        shadowColor: Colors.black.withAlpha((0.9 * 255.0).round()),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ElevatedButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
        padding: EdgeInsets.symmetric(horizontal: 0.0.w, vertical: 0.0.h),
        backgroundColor: primaryLight,
        foregroundColor: Colors.black,
        elevation: 6, // Més elevació en tema clar (6)
        shadowColor: Colors.black.withAlpha((0.9 * 255.0).round()),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryLight,
      foregroundColor: Colors.white,
    ),

    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
      fillColor: Colors.transparent, // Com els botons outlined, sense fons
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: primaryLight, width: 1.2), // Vora normal
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: primaryLight, width: 1.2), // Vora normal
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: primaryLight,
          width: 2.5,
        ), // Vora més gruixuda amb focus
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: errorLight,
          width: 1.2,
        ), // Vora normal amb error
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: errorLight,
          width: 2.5,
        ), // Vora més gruixuda amb focus i error
      ),

      // Estils de text
      isDense: true,
      labelStyle: TextStyle(
        fontSize: 16.0.sp, // Mateixa mida que els botons
        color: primaryLight,
        fontWeight: FontWeight.normal,
      ),
      floatingLabelStyle: TextStyle(
        // fontSize: _txtScaler.scale(10.0.sp), // Igual que els botons
        color: primaryLight,
        fontWeight: FontWeight.bold,
      ),

      hintStyle: TextStyle(color: Colors.grey.shade500),
      helperStyle: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 10.0.sp,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.italic,
        color: Colors.white30,
        letterSpacing: 0.2,
      ),
      errorStyle: TextStyle(color: errorLight, fontSize: 12.0),

      // Prefix i suffix - Mateixos colors que els botons outlined
      prefixIconColor: primaryLight,
      suffixIconColor: primaryLight,
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryLight;
        }
        return Colors.grey.shade400;
      }),
      checkColor: WidgetStateProperty.all(Colors.white),
    ),

    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: primaryLight,
      linearTrackColor: Colors.grey.shade200,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: primaryLight,
      foregroundColor: Colors.white,
      elevation: 4,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20.0.h,
        fontWeight: FontWeight.bold,
      ),

      // Assegurem que tots els textos de l'AppBar siguin blancs
      toolbarTextStyle: TextStyle(color: Colors.white),
    ),
  );

  // TEMA FOSC ------------------------
  ThemeData get darkTheme => _darkTheme;

  final ThemeData _darkTheme = ThemeData.dark().copyWith(
    // Esquema de colors principals
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

    // Colors específics per a components
    scaffoldBackgroundColor: Color(0xFF1E2433),

    textTheme: TextTheme(
      // Específicament canviem l'estil del títol a blanc
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

      // També afegim l'estil per a subtítols
      titleLarge: TextStyle(color: Colors.white),
    ),

    cardTheme: CardTheme(
      color: surfaceDark,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
        padding: EdgeInsets.symmetric(horizontal: 2.0.w, vertical: 0.0.h),
        backgroundColor: Color.fromARGB(255, 89, 124, 172),
        foregroundColor: Colors.white,
        elevation: 8, // Elevació encara més alta en tema fosc
        shadowColor: Colors.black.withAlpha((0.7 * 255.0).round()),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ElevatedButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
        padding: EdgeInsets.symmetric(horizontal: 0.0.w, vertical: 0.0.h),
        backgroundColor: primaryLight,
        foregroundColor: Colors.white,
        elevation: 6, // Més elevació en tema clar
        shadowColor: Colors.black.withAlpha((0.5 * 255.0).round()),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryDark,
      foregroundColor: Colors.white,
    ),

    inputDecorationTheme: InputDecorationTheme(
      // Paddings i espaiats d'edició
      contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      // Colors i estils base
      fillColor: Colors.transparent, // Com els botons outlined, sense fons
      filled: true,

      // Vores - Estil similar als botons outlined
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: Colors.lightBlueAccent,
          width: 1.2,
        ), // Vora normal
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: Colors.lightBlueAccent,
          width: 1.2,
        ), // Vora normal
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: Colors.lightBlueAccent,
          width: 2.5,
        ), // Vora més gruixuda amb focus
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: errorDark,
          width: 1.2,
        ), // Vora normal amb error
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: errorDark,
          width: 2.5,
        ), // Vora més gruixuda amb focus i error
      ),

      // Estils de text
      isDense: true,
      labelStyle: TextStyle(
        fontSize: 16.0.sp, // Mateixa mida que els botons
        color: Colors.lightBlueAccent,
        fontWeight: FontWeight.normal,
      ),
      floatingLabelStyle: TextStyle(
        fontSize: 20.0.sp, // Mateixa mida que els botons
        color: Colors.lightBlueAccent,
        fontWeight: FontWeight.bold,
      ),

      hintStyle: TextStyle(color: Colors.grey.shade400),
      helperStyle: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 10.sp,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.italic,
        color: Colors.white70,
        letterSpacing: 0.2,
      ),
      errorStyle: TextStyle(color: errorDark, fontSize: 12.0),

      // Prefix i suffix - Mateixos colors que els botons outlined
      prefixIconColor: Colors.lightBlueAccent,
      suffixIconColor: Colors.lightBlueAccent,
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryDark;
        }
        return Colors.grey.shade700;
      }),
      checkColor: WidgetStateProperty.all(Colors.white),
    ),

    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: primaryDark,
      linearTrackColor: Colors.grey.shade800,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: primaryDark,
      foregroundColor: Colors.white, // Text blanc per la AppBar
      elevation: 4,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20.0.sp,
        fontWeight: FontWeight.bold, // Títol en negreta
      ),
      toolbarTextStyle: TextStyle(color: Colors.white),
    ),
  );

  // Mètodes públics
  void changeThemeMode(ThemeMode pMode) {
    _themeMode = pMode;
    _isDarkMode = (pMode == ThemeMode.system)
        ? PlatformDispatcher.instance.platformBrightness == Brightness.dark
        : (pMode == ThemeMode.dark);

    ThemeData? old = _currentTheme;
    _currentTheme = _isDarkMode ? darkTheme : lightTheme;
    
    // Emetre l'event de canvi de tema
    send(
      ThemeEventModel.envelope(
        pSrc: tag,
        pModel: ThemeEventModel(
          old, 
          _currentTheme,
        )
      )
    );
  }

  void toggleTheme() {
    if (_themeMode == ThemeMode.system) {
      // Si estem en mode sistema, canviem a fosc o clar depenent de l'actual
      changeThemeMode(_isDarkMode ? ThemeMode.light : ThemeMode.dark);
    } else {
      // Si ja estem en mode manual, alternem entre fosc i clar
      changeThemeMode(_themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
    }
  }
  
  @override String baseTag() => "LdTheme";
}

