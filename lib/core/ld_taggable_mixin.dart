// ld_taggable_mixin.dart
// Mixin simplificat per a la identificació d'elements mitjançant tags
// Created: 2025/04/29 dt. CLA[JIQ]
// Updated: 2025/05/11 dg. CLA - Optimització amb GlobalKey i navegació

import 'package:flutter/material.dart';
import 'package:ld_wbench5/utils/debug.dart';
import 'package:ld_wbench5/core/extensions/type_extensions.dart';

/// Mixin que proporciona capacitats d'identificació mitjançant tags únics
/// i GlobalKey transparent per a widgets i pàgines.
mixin LdTaggableMixin {
  // MEMBRES ESTÀTICS =====================================
  static int _cntWidgets = 0;
  static int get cntWidgets => ++_cntWidgets;

  // MEMBRES LOCALS =======================================
  /// Nom base de la classe.
  String get className => runtimeType.cleanClassName;

  /// Tag únic per a aquesta instància
  String? _tag;
  
  /// GlobalKey gestionada internament
  GlobalKey? _globalKey;
  
  // GETTERS/SETTERS ======================================
  /// Obté el tag d'aquesta instància, generant-ne un si no existeix
  String get tag => _tag ?? generateTag();
  
  /// Estableix el tag com una propietat simple
  set tag(String pNewTag) {
    _tag = pNewTag;
    Debug.info("Tag assignat: $_tag");
  }
  
  // FUNCIONALITAT TAG'S ==================================
  /// Genera un tag únic basat en el tipus de classe i timestamp
  String generateTag() {
    // final generatedTag = '${className}_${DateTime.now().millisecondsSinceEpoch}';
    final generatedTag = '${className}_$cntWidgets';
    _tag = generatedTag;
    return generatedTag;
  }
  
  // FUNCIONALITAT GLOBALKEY'S ============================
  /// Inicialitza i retorna la GlobalKey per a widgets
  /// Només crear quan realment necessitem la key
  GlobalKey<T> _ensureGlobalKey<T extends State>() {
    if (_globalKey == null) {
      _globalKey = GlobalKey<T>();
      Debug.info("$tag: GlobalKey creada sota demanda");
    }
    return _globalKey! as GlobalKey<T>;
  }
  
  /// Interfície pública per accedir a la GlobalKey
  /// Retorna null si no s'ha creat encara
  GlobalKey? get globalKey => _globalKey;
  
  /// Accés tipat a l'estat del widget si està disponible
  T? getState<T extends State<StatefulWidget>>() {
    var state = _globalKey?.currentState;
    assert(state != null, "$tag: Estat no disponible encara");
    
    try {
      return state as T?;
    } catch (e) {
      Debug.fatal("$tag: Error al obtenir estat del widget: $e");
      return null;
    }
  }
  
  /// Accés al context del widget si està disponible
  BuildContext? get widgetContext {
    return _globalKey?.currentContext;
  }
  
  /// Comprova si el widget està muntat i accessible
  bool get isWidgetMounted => _globalKey?.currentState != null;
  
  /// Força la creació de la GlobalKey i la retorna
  /// Útil per a casos específics on necessitem la key abans del muntatge
  GlobalKey<T> forceGlobalKey<T extends State>() {
    return _ensureGlobalKey<T>();
  }
  
  // NAVEGACIÓ I UTILITATS DE CONTEXT =====================
  /// Navega a una nova ruta des d'aquest widget
  void navigateTo(
    Widget destination, {
    bool replace = false,
    bool clearStack = false,
  }) {
    final context = widgetContext;
    if (context != null) {
      if (clearStack) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => destination),
          (route) => false,
        );
      } else if (replace) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => destination),
        );
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => destination),
        );
      }
    } else {
      Debug.warn("$tag: No es pot navegar - widget no muntat");
    }
  }
  
  /// Tanca aquest widget/pàgina
  void pop([dynamic result]) {
    final context = widgetContext;
    if (context != null && Navigator.canPop(context)) {
      Navigator.of(context).pop(result);
    }
  }
  
  // SNACKBAR'S I DIÀLOGS =================================
  /// Mostra un SnackBar des d'aquest widget
  void showSnackBar(String message, {Duration? duration}) {
    final context = widgetContext;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: duration ?? const Duration(seconds: 3),
        ),
      );
    }
  }
  
  /// Mostra un diàleg des d'aquest widget
  Future<T?> showDialogFromWidget<T>({
    required Widget Function(BuildContext) builder,
    bool barrierDismissible = true,
  }) async {
    final context = widgetContext;
    if (context != null) {
      return await showDialog<T>(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: builder,
      );
    } else {
      Debug.warn("$tag: No es pot mostrar el diàleg - widget no muntat");
      return null;
    }
  }
}