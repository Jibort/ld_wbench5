// ld_widget_model_abs.dart
// Model base pels widgets.
// Created: 2025/05/02 dj. JIQ

import 'package:ld_wbench5/core/ld_model_abs.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
import 'package:ld_wbench5/utils/map_extensions.dart';
import 'package:ld_wbench5/utils/once_set.dart';

/// Model base pels widgets.
abstract class LdWidgetModelAbs<T extends LdWidgetAbs>
extends  LdModelAbs {
  /// Referència al widget
  final OnceSet<T> _widget = OnceSet<T>();
  /// Retorna la referència al widget del controlador.
  T get cWidget => _widget.get(pCouldBeNull: false)!;
  /// Estableix la referència al widget del controlador.
  set cWidget(T pPage) => _widget.set(pPage);

  /// Constructor ---------------------
  LdWidgetModelAbs(T pWidget) { cWidget = pWidget; }
  
  /// 'LdModelAbs': Assigna els valors dels membres del model a partir d'un mapa.
  @override
  void fromMap(LdMap pMap) {
    super.fromMap(pMap);
  }

  /// 'LdModelAbs': Retorna un mapa amb els membres del model.
  @override
  LdMap<dynamic> toMap() {
    LdMap<dynamic> map = super.toMap();
    return map;
  }

  /// 'LdModelAbs': Retorna el valor d'un membre del model.
  @override
  getField({required String pKey, bool pCouldBeNull = true, String? pErrorMsg}) {
    return super.getField(pKey: pKey, pCouldBeNull: pCouldBeNull, pErrorMsg: pErrorMsg);
  }

  /// 'LdModelAbs': Estableix el valor d'un membre del model.
  @override
  void setField({required String pKey, dynamic pValue, bool pCouldBeNull = true, String? pErrorMsg}) {
    super.setField(pKey: pKey, pValue: pValue, pCouldBeNull: pCouldBeNull, pErrorMsg: pErrorMsg);
  }
}
