// lib/services/global_variables_service.dart
// Conjunt de variables globals per a interpolacions en traduccions.
// Created: 2025/05/14 dc. CLA

import 'package:flutter/foundation.dart';
import 'package:ld_wbench5/core/ld_typedefs.dart';

/// Service que gestiona variables automàtiques per interpolació en traduccions
class GlobalVariablesService {
  static final LdMap<String> _customVariables = LdMap<String>();
  static final LdMap<String Function()> _dynamicVariables = LdMap<String Function()>();
  
  /// Inicialitzar variables automàtiques del sistema
  static void initialize() {
    // Variables de data i hora
    _registerDynamic('current_date', () => _formatDate(DateTime.now()));
    _registerDynamic('current_time', () => _formatTime(DateTime.now()));
    _registerDynamic('current_datetime', () => _formatDateTime(DateTime.now()));
    _registerDynamic('current_year', () => DateTime.now().year.toString());
    _registerDynamic('current_month', () => DateTime.now().month.toString());
    _registerDynamic('current_day', () => DateTime.now().day.toString());
    
    // Variables de sistema
    _registerDynamic('platform', () => _getPlatform());
    _registerDynamic('is_debug', () => kDebugMode.toString());
    
    // Variables de l'aplicació (es poden configurar externament)
    _registerStatic('app_name', 'LD Workbench 5');
    _registerStatic('app_version', '1.0.0');
  }
  
  /// Obtenir valor d'una variable automàtica
  static String? getValue(String variableName) {
    // 1. Buscar en variables dinàmiques (recalculades cada vegada)
    if (_dynamicVariables.containsKey(variableName)) {
      try {
        return _dynamicVariables[variableName]!();
      } catch (e) {
        if (kDebugMode) {
          print('Error calculating dynamic variable $variableName: $e');
        }
        return null;
      }
    }
    
    // 2. Buscar en variables estàtiques (custom)
    if (_customVariables.containsKey(variableName)) {
      return _customVariables[variableName];
    }
    
    // 3. Variable no trobada
    return null;
  }
  
  /// Registrar una variable estàtica
  static void setVariable(String name, String value) {
    _customVariables[name] = value;
  }
  
  /// Registrar múltiples variables estàtiques
  static void setVariables(LdMap<String> variables) {
    variables.forEach((key, value) {
      _customVariables[key] = value;
    });
  }
  
  /// Eliminar una variable
  static void removeVariable(String name) {
    _customVariables.remove(name);
    _dynamicVariables.remove(name);
  }
  
  /// Obtenir totes les variables disponibles (per debug)
  static LdMap<String> getAllVariables() {
    final all = LdMap<String>();
    
    // Afegir variables estàtiques
    _customVariables.forEach((key, value) {
      all[key] = value;
    });
    
    // Afegir variables dinàmiques (calculades en el moment)
    _dynamicVariables.forEach((key, func) {
      try {
        all[key] = func();
      } catch (e) {
        all[key] = 'ERROR: $e';
      }
    });
    
    return all;
  }
  
  /// Netejar totes les variables custom
  static void clear() {
    _customVariables.clear();
  }
  
  // MÈTODES PRIVATS ======================================
  
  /// Registrar una variable dinàmica (calculada)
  static void _registerDynamic(String name, String Function() calculator) {
    _dynamicVariables[name] = calculator;
  }
  
  /// Registrar una variable estàtica
  static void _registerStatic(String name, String value) {
    _customVariables[name] = value;
  }
  
  /// Formatear data
  static String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
  
  /// Formatear hora
  static String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
  
  /// Formatear data i hora
  static String _formatDateTime(DateTime date) {
    return '${_formatDate(date)} ${_formatTime(date)}';
  }
  
  /// Obtenir plataforma
  static String _getPlatform() {
    if (kIsWeb) return 'web';
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'android';
      case TargetPlatform.iOS:
        return 'ios';
      case TargetPlatform.macOS:
        return 'macos';
      case TargetPlatform.windows:
        return 'windows';
      case TargetPlatform.linux:
        return 'linux';
      default:
        return 'unknown';
    }
  }
}
