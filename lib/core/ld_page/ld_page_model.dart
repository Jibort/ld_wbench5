// ld_page_model.dart
// Model base per a les pàgines. 
// Created: 2025/05/03 ds. JIQ

import 'package:ld_wbench5/core/ld_model_abs.dart';
import 'package:ld_wbench5/core/ld_page/ld_page_abs.dart';
import 'package:ld_wbench5/utils/once_set.dart';

/// Model base per a les pàgines.
abstract class LdPageModelAbs<T extends LdPageAbs>
extends  LdModelAbs {
  /// Referència al widget
  final OnceSet<T> _page = OnceSet<T>();

  /// Retorna la referència a la pàgina del model.
  T get cPage => _page.get(pCouldBeNull: false)!;

  /// Estableix la referència a la pàgina  del model.
  set cPage(T pPage) => _page.set(pPage);

  /// Constructor ---------------------
  LdPageModelAbs({ required T pPage }) { cPage = pPage; }
}
