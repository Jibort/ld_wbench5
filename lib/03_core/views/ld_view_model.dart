// ld_view_model.dart
// Abstracció del model de dades per a una pàgina de l'aplicació.
// CreatedAt: 2025/04/07 dl. JIQ

import 'package:ld_wbench5/03_core/ld_model.dart';
import 'package:ld_wbench5/03_core/views/ld_view.dart';
import 'package:ld_wbench5/03_core/views/ld_view_ctrl.dart';
import 'package:ld_wbench5/10_tools/debug.dart';
import 'package:ld_wbench5/10_tools/ld_map.dart';
import 'package:ld_wbench5/10_tools/only_once.dart';

/// Abstracció del controlador per a una pàgina de l'aplicació.
abstract class LdViewModel 
extends  LdModel {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "LdViewModel";
  
  // 🧩 MEMBRES ------------------------
  final OnlyOnce<LdView>     _view  = OnlyOnce<LdView>();
  final OnlyOnce<LdViewCtrl> _vCtrl = OnlyOnce<LdViewCtrl>();

  late String  _title;
  late String? _subTitle;

  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  LdViewModel({ 
    // required LdView pView, 
    super.pTag,
    required String pTitle, 
    String? pSubTitle })
  : // _view = pView,
    _title = pTitle,
    _subTitle = pSubTitle;

  @override
  void dispose() {
    super.dispose();
  }

  // 🪟 GETTERS I SETTERS --------------
  LdView  get view     => _view.get();
  String  get title    => _title;
  String? get subTitle => _subTitle;

  set view(LdView pView) => _view.set(pView, pError: "Error en assignació 'LdViewModel'!");
  set vCtrl(LdViewCtrl pVCtrl) => _vCtrl.set(pVCtrl);

  set title(String pTitle) {
    view.ctrl.setState(() => _title = pTitle);
  }
  
  set subTitle(String? pSubTitle) {
    view.ctrl.setState(() => _subTitle = pSubTitle);
  }

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

