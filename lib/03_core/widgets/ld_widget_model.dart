// ld_widget_model.dart
// Model bàsic per a tots els widgets de l'aplicació.
// CreatedAt: 2025/04/14 dg. JIQ

import 'package:ld_wbench5/03_core/views/ld_view.dart';
import 'package:ld_wbench5/03_core/ld_model.dart';
import 'ld_widget.dart';
import 'package:ld_wbench5/10_tools/ld_map.dart';
import 'package:ld_wbench5/10_tools/once_set.dart';

/// Abstracció del model per als widgets de l'aplicació.
abstract class LdWidgetModel
extends  LdModel {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "LdWidgetModel";
  
  // 🧩 MEMBRES ------------------------
  final OnceSet<LdWidget> _widget = OnceSet<LdWidget>();
  
  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  /// Constructor base de la classe.
  LdWidgetModel({ 
    required LdView pView, 
    required LdWidget pWidget,
    super.pTag, })
  { _widget.set(pWidget);
    _widget.get().view; 
  }

  /// Constructor de la instància a partir d'un mapa de valors.
  LdWidgetModel.fromMap(LdMap pMap)
  : super(pTag: pMap[mfTag]);
    
  @override void dispose() => super.dispose();

  // 🪟 GETTERS I SETTERS --------------
  /// Retorna la vista on pertany el widget del model.
  LdView get view => _widget.get().view;
  /// Retorna el widget on pertany el model de la vista.
  LdWidget get widget => _widget.get();
  LdWidgetCtrl get wCtrl => widget.wCtrl;
}