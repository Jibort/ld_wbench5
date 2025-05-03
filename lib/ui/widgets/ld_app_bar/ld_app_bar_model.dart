// ld_app_bar_model.dart
// Model de dades del widget LdAppBar.
// Created: 2025-05-01 dc. JIQ

import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/ui/ui_consts.dart';
import 'package:ld_wbench5/ui/widgets/ld_app_bar/ld_app_bar.dart';
import 'package:ld_wbench5/utils/full_set.dart';
import 'package:ld_wbench5/utils/map_extensions.dart';

/// Model de dades del widget LdAppBar.
class   LdAppBarModel
extends LdWidgetModelAbs<LdAppBar> {
  /// Retorna el controlador del widget.
  LdAppBarCtrl get wCtrl => cWidget.wCtrl as LdAppBarCtrl;
  
  /// Títol de la barra d'aplicació.
  final FullSet<String> _title = FullSet<String>();
  /// Retorna el títol de la barra d'aplicació.
  String get title => _title.get() ?? errInText;
  /// Estableix el títol de la barra d'aplicació.
  set title(String pTitle) => notifyListeners(() => _title.set(pTitle));

  /// Subtítol de la barra d'aplicació.
  final FullSet<String?> _subTitle = FullSet<String?>();
  /// Retorna el subtítol de la barra d'aplicació.
  String? get subTitle => _subTitle.get();
  /// Estableix el subtítol de la barra d'aplicació.
  set subTitle(String? pSubTitle) => notifyListeners(() => _subTitle.set(pSubTitle));
  /// Estableix el títol i el subtítol en la mateixa crida.
  void setTitles({ required String pTitle, String? pSubTitle }) =>
    notifyListeners(() {
      _title.set(pTitle);
      _subTitle.set(pSubTitle);
    });

  /// Constructor General
  LdAppBarModel(super.pWidget, { required String pTitle, String? pSubTitle}) {
    _title.set(pTitle);
    _subTitle.set(pSubTitle);
  }

  /// Constructor des d'un mapa de valors.
  LdAppBarModel.fromMap(super.pWidget, LdMap pMap) { fromMap(pMap); }

  /// 'LdModelAbs': Assigna els valors dels membres del model a partir d'un mapa.
  @override
  void fromMap(LdMap pMap) {
    super.fromMap(pMap);
    title    = pMap[mfTitle] as String;
    subTitle = pMap[mfSubTitle] as String?;
  }

/// Retorna un mapa amb els membres del model.
  @override // Arrel
  LdMap<dynamic> toMap() {
    LdMap<dynamic> map = super.toMap();
    map.addAll({
      mfTag:      tag,
      mfTitle:    title,
      mfSubTitle: subTitle,
    });
    return map;
  }

  /// 'LdModelAbs': Retorna el valor d'un membre del model.
  @override
  getField({required String pKey, bool pCouldBeNull = true, String? pErrorMsg}) 
  => (pKey == mfTitle)
      ? title
      : (pKey == mfSubTitle)
        ? subTitle
        : super.getField(pKey: pKey, pCouldBeNull: pCouldBeNull, pErrorMsg: pErrorMsg);

  /// 'LdModelAbs': Estableix el valor d'un membre del model.
  @override
  void setField({required String pKey, dynamic pValue, bool pCouldBeNull = true, String? pErrorMsg})
  => (pKey == mfTitle && pValue is String)
      ? title = pValue
      : (pKey == mfSubTitle && pValue is String?)
        ? subTitle = pValue 
        : (pKey == "$mfTitle|$mfSubTitle")
          ? setTitles(
              pTitle:    (pValue as String).split(r"|").first,
              pSubTitle: (pValue.split(r"|").last))
          : super.setField(pKey: pKey, pValue: pValue, pCouldBeNull: pCouldBeNull, pErrorMsg: pErrorMsg);
}
