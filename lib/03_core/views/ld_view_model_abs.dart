// ld_view_model_abs.dart
// Abstracció del model de dades per a una pàgina de l'aplicació.
// CreatedAt: 2025/04/07 dl. JIQ

import 'package:ld_wbench5/03_core/abstraction/ld_view_abs.dart';
import 'package:ld_wbench5/03_core/model/ld_model_abs.dart';
import 'package:ld_wbench5/03_core/views/ld_view_ctrl_abs.dart';
import 'package:ld_wbench5/10_tools/debug.dart';
import 'package:ld_wbench5/10_tools/ld_map.dart';
import 'package:ld_wbench5/10_tools/once_set.dart';

/// Abstracció del controlador per a una pàgina de l'aplicació.
abstract class LdViewModelAbs 
extends  LdModelAbs {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "LdViewModel";
  
  // 🧩 MEMBRES ------------------------
  final OnceSet<LdViewAbs> _view  = OnceSet<LdViewAbs>();

  late String  _title;
  late String? _subTitle;

  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  /// Constructor base de la classe.
  LdViewModelAbs({ 
    required LdViewAbs pView, 
    super.pTag,
    required String pTitle, 
    String? pSubTitle })
  : _title = pTitle,
    _subTitle = pSubTitle
  { _view.set(pView); }

  /// Constructor de la instància a partir d'un mapa de valors.
  LdViewModelAbs.fromMap(LdMap pMap)
  : super(pTag: pMap[mfTag]);

  @override void dispose() => super.dispose();

  // 🪟 GETTERS I SETTERS --------------
  /// Retorna la vista on pertany el model.
  LdViewAbs  get view => _view.get();
  /// Retorna el controlador de la vista on pertany el model.
  LdViewCtrlAbs get vCtrl => view.vCtrl;

  /// Retorna el títol principal de la vista.
  String  get title => _title;
  /// Retorna el subtítol de la vista.
  String? get subTitle => _subTitle;
  
  /// Estableix el títítol principal de la vista.
  set title(String pTitle)
  => vCtrl.setState(() => _title = pTitle);
  
  set subTitle(String? pSubTitle)
  => view.vCtrl.setState(() => _subTitle = pSubTitle);

  void setTitles(String pTitle, String? pSubTitle) 
  => view.vCtrl.setState(() {
    _title = pTitle;
    _subTitle = pSubTitle;
  });


  // 📍 IMPLEMENTACIÓ ABSTRACTA -------
  /// 📍 'LdModel': Retorna un mapa amb el contingut dels membres de la instància del model.
  @override LdMap toMap() => LdMap(pMap: {
    mfTitle:    title,
    mfSubTitle: subTitle,
  });

  /// 📍 'LdModel': Actualitza la instància del model amb els camps informats al mapa.
  @override void fromMap(LdMap pMap) {
    title    = pMap[mfTitle] as String;
    subTitle = pMap[mfSubTitle] as String?;
  }

  /// 📍 'LdModel': Retorna el valor d'un component donat o null.
  @override dynamic getField(String pField) {
    (pField == mfTitle)
      ? title
      : (pField == mfSubTitle)
        ? subTitle
        : null;
  }

  /// 📍 'LdModel': Estableix el valor d'un component donat del model.
  @override void setField(String pField, dynamic pValue) {
    (pField == mfTitle && pValue is String)
      ? {title = pValue }
      : (pField == mfSubTitle && pValue is String?)
        ? { subTitle = pValue }
        : Debug.warn("El membre '$pField' no pertany al model '$baseTag()' o el valor no correspon al seu tipus!");
  }
}

