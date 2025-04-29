// ld_widget_model_abs.dart
// Model bàsic per a tots els widgets de l'aplicació.
// CreatedAt: 2025/04/14 dg. JIQ

import 'package:ld_wbench5/03_core/abstraction/ld_view_abs.dart';
import 'package:ld_wbench5/03_core/abstraction/ld_widget_abs.dart';
import 'package:ld_wbench5/03_core/model/ld_model_abs.dart';
import 'package:ld_wbench5/03_core/widgets/ld_widget_ctrl_abs.dart';
import 'package:ld_wbench5/10_tools/ld_map.dart';
import 'package:ld_wbench5/10_tools/once_set.dart';

/// Abstracció del model per als widgets de l'aplicació.
abstract class LdWidgetModelAbs
extends  LdModelAbs {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "LdWidgetModel";
  
  // 🧩 MEMBRES ------------------------
  final OnceSet<LdWidgetAbs> _widget = OnceSet<LdWidgetAbs>();
  
  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  /// Constructor base de la classe.
  LdWidgetModelAbs({ 
    required LdViewAbs   pView, 
    required LdWidgetAbs pWidget,
    super.pTag, })
  { _widget.set(pWidget);
    _widget.get().view; 
  }

  /// Constructor de la instància a partir d'un mapa de valors.
  LdWidgetModelAbs.fromMap(LdMap pMap)
  : super(pTag: pMap[mfTag]);
    
  @override void dispose() => super.dispose();

  // 🪟 GETTERS I SETTERS --------------
  /// Retorna la vista on pertany el widget del model.
  LdViewAbs get view => _widget.get().view;
  
  /// Retorna el widget on pertany el model de la vista.
  LdWidgetAbs get widget => _widget.get();

  /// Retorna el controlador del widget.
  LdWidgetCtrlAbs get wCtrl => widget.wCtrl;
}