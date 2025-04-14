// ld_widget_model.dart
// Model bàsic per a tots els widgets de l'aplicació.
// CreatedAt: 2025/04/14 dg. JIQ

import 'package:flutter/widgets.dart';
import 'package:ld_wbench5/03_core/ld_model.dart';
import 'package:ld_wbench5/03_core/widgets/ld_widget.dart';
import 'package:ld_wbench5/10_tools/debug.dart';
import 'package:ld_wbench5/10_tools/ld_map.dart';
import 'package:ld_wbench5/10_tools/only_once.dart';

/// Model bàsic per a tots els widgets de l'aplicació.
abstract class LdWidgetModel
extends LdModel {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "LdWidgetModel";
  
  // 🧩 MEMBRES ------------------------
  final OnlyOnce<LdWidget>     _widget = OnlyOnce<LdWidget>();
  final OnlyOnce<LdWidgetCtrl> _wCtrl  = OnlyOnce<LdWidgetCtrl>();
  bool _isEnabled;
  bool _isVisible;
  bool _isFocusable;

  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  LdWidgetModel({
    bool isEnabled   = true,
    bool isVisible   = true,
    bool isFocusable = true, })
  : _isEnabled   = isEnabled,
    _isVisible   = isVisible,
    _isFocusable = isFocusable;
    
  // 🪟 GETTERS I SETTERS --------------
  LdWidgetCtrl get wCtrl => _wCtrl.get();

  bool get isEnabled => _isEnabled;
  set isEnabled(bool pIsEnabled) {
    if (_isEnabled != pIsEnabled) {
      wCtrl.setState(() => _isEnabled = pIsEnabled);
    }
  }

  bool get isVisible => _isVisible;
  set isVisible(bool pIsVisible) {
    if (_isVisible != pIsVisible) {
      wCtrl.setState(()  => _isVisible = pIsVisible);
    }
  }
  
  bool get isFocusable => _isFocusable;
  set isFocusable(bool pIsFocusable) {
    if (_isFocusable != pIsFocusable) {
      wCtrl.setState(()  => _isFocusable = pIsFocusable);
    }
  }

  // 📍 IMPLEMENTACIÓ ABSTRACTA -------
  /// 📍 'LdTagMixin': Retorna el tag base per defecte.
  @override String baseTag();
  
  /// 📍 'LdModel': Retorna el valor d'un component donat o null.
  @override
  @mustCallSuper
  dynamic getField(String pField) =>
    (pField == mfIsEnabled)
      ? _isEnabled
      : (pField == mfIsVisible)
        ? _isVisible
        : (pField == mfIsFocusable)
          ? _isFocusable
          : null;

  /// 📍 'LdModel': Estableix el valor d'un component donat del model.
  @override
  @mustCallSuper
  void setField(String pField, dynamic pValue) {
    (pField == mfIsEnabled && pValue is bool)
      ? _wCtrl.get().setState(() => _isEnabled = pValue)
      : (pField == mfIsVisible && pValue is bool)
        ? _wCtrl.get().setState(() => _isVisible = pValue)
        : (pField == mfIsVisible && pValue is bool)
          ? _wCtrl.get().setState(() => _isVisible = pValue)
          : (pField == mfIsFocusable)
            ? _wCtrl.get().setState(() => _isFocusable = pValue)
            : Debug.warn("El membre '$pField' no pertany al model '$baseTag()' o el valor no correspon al seu tipus!");
  }

  /// 📍 'LdModel': Retorna un mapa amb el contingut de la instància del model.  
  @override 
  @mustCallSuper 
  LdMap toMap() => LdMap(pMap: {
    mfIsEnabled:   _isEnabled,  
    mfIsVisible:   _isVisible,
    mfIsFocusable: _isFocusable,
  });

  /// 📍 'LdModel': Actualitza la instància del model amb els camps informats al mapa.
  @override
  @mustCallSuper
  void fromMap(LdMap pMap) {
    wCtrl.setState();
  }

  /// 📍 'LdModel': Retorna una String en forma "[...] amb els components del model".
  @override
  String toStr({int pLevel = 1, String pInner = '' }) {
    String root = ' ' * pLevel * 2;
    String str = super.toStr(pLevel: pLevel - 1);
    return str.replaceAll(RegExp(r'__UP__'), """
$root'$mfIsEnabled':   $_isEnabled,  
$root'$mfIsVisible':   $_isVisible,
$root'$mfIsFocusable': $_isFocusable${(pGrowable)?",\b__UP__": ""} 
""");
  }

}