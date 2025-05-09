// lib/services/theme_service.dart
// Servei de gestió de temes simplificat
// Created: 2025/04/29 dt. CLA[JIQ]
// Updated: 2025/05/09 dv. CLA - Adaptador complet per LdTheme

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/ld_taggable_mixin.dart';
import 'package:ld_wbench5/services/ld_theme.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Servei centralitzat per a la gestió de temes visuals
/// @deprecated Utilitzar LdTheme en lloc d'aquest servei
class ThemeService with LdTaggableMixin {
  /// Instància singleton
  static final ThemeService _inst = ThemeService._();
  static ThemeService get s => _inst;
  
  /// Constructor privat
  ThemeService._() {
    tag = className;
    Debug.warn("$tag: Aquest servei és obsolet, utilitzar LdTheme en el seu lloc");
  }
  
  /// Retorna si el tema actual és fosc
  bool get isDarkMode => LdTheme.s.isDarkMode;
  
  /// Retorna el tema actual
  ThemeData get currentTheme => LdTheme.s.currentTheme;
  
  /// Retorna el tema clar
  ThemeData get lightTheme => LdTheme.s.lightTheme;
  
  /// Retorna el tema fosc
  ThemeData get darkTheme => LdTheme.s.darkTheme;
  
  /// Retorna el mode de tema actual
  ThemeMode get themeMode => LdTheme.s.themeMode;
  
  /// Estableix el mode de tema
  set themeMode(ThemeMode pMode) => LdTheme.s.themeMode = pMode;
  
  /// Canvia el mode del tema
  void changeThemeMode(ThemeMode mode) => LdTheme.s.changeThemeMode(mode);
  
  /// Alterna entre els temes clar i fosc
  void toggleTheme() => LdTheme.s.toggleTheme();

  /// Canvia al tema següent en la llista de temes disponibles
  void nextTheme() => LdTheme.s.nextTheme();
  
  /// Retorna el nom del tema actual
  ThemeName get currentThemeName => LdTheme.s.currentThemeName;
  
  /// Estableix el tema actual per nom
  set currentThemeName(ThemeName pName) => LdTheme.s.currentThemeName = pName;
}