// ld_page_model.dart
// Model base per a les pàgines. 
// CreatedAt: 2025/05/03 ds. JIQ

import 'package:ld_wbench5/core/ld_model.dart';
import 'package:ld_wbench5/core/ld_page/ld_page_abs.dart';
import 'package:ld_wbench5/utils/once_set.dart';

/// Model base per a les pàgines.
abstract class LdPageModelAbs<T extends LdPageAbs>
extends  LdModelAbs {
  /// Referència al widget
  final OnceSet<T> _page = OnceSet<T>();

  /// Retorna la referència al widget del controlador.
  T get cWidget => _page.get(pCouldBeNull: false)!;
  
  /// Estableix la referència al widget del controlador.
  set cWidget(T pPage) => _page.set(pPage);

  /// Constructor ---------------------
  LdPageModelAbs();
}
