// ld_widget_model_abs.dart
// Model base pels widgets.
// CreatedAt: 2025/05/02 dj. JIQ

import 'package:ld_wbench5/core/ld_model.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
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
}

