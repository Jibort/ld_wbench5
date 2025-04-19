// ld_app_bar_model.dart
// Model de dades del widget LdAppBar.
// Created: 2025/04/18 dv. JIQ

import 'dart:convert';

import 'package:ld_wbench5/03_core/ld_model.dart';
import 'package:ld_wbench5/03_core/widgets/ld_widget.dart';
import 'package:ld_wbench5/10_tools/conversions.dart';
import 'package:ld_wbench5/10_tools/ld_map.dart';

/// Model de dades del widget LdAppBar.
class LdAppBarModel
extends LdWidgetModel {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "LdAppBar";

  // 🧩 MEMBRES ------------------------
  String  _title;
  String? _subTitle;

  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  LdAppBarModel({
    required super.pView, 
    required super.pWidget,
    required String pTitle,
    String? pSubTitle, })
  : _title    = pTitle,
    _subTitle = pSubTitle;

  // 🪟 GETTERS I SETTERS --------------
  /// Retorna el títol de la barra de capçalera de la vista.
  String get title => _title;
  /// Actualitza el títol de la barra de capçalera de la vista.
  set title(String pTitle) 
  => (title != pTitle) ? wCtrl.setState(() => title = pTitle): null;

  /// Retorna el subtítol de la barra de capçalera de la vista.
  String? get subTitle => _subTitle;
  /// Actualitza el subtítol de la barra de capçalera de la vista.
  set subTitle(String? pSubTitle) => wCtrl.setState(() =>  _subTitle = pSubTitle);

  /// Actualitza els títol i subtítol de la barra de capçalera de la vista.
  void setTitles({ required String pTitle, String? pSubTitle }) {
    wCtrl.setState(() {
      _title    = pTitle;
      _subTitle = pSubTitle;
    });
  }

  // 📍 IMPLEMENTACIÓ ABSTRACTA -------
  
  @override
  void fromJson(String pJSon) => fromMap(LdMap(pMap: jsonDecode(pJSon)));

  @override
  LdMap toMap() => LdMap(pMap: {
    mfTitle: title,
    mfSubTitle: subTitle,
  });

  @override
  void fromMap(LdMap pMap) {
    tag = pMap[mfTag];
    title = pMap[mfTitle]?? "!?";
    subTitle = pMap[mfSubTitle];
  }

  @override
  getField(String pField)
  => (pField == mfTag)
     ? tag
      : (pField == mfTitle)
        ? title
        : (pField == mfSubTitle)
          ? subTitle
          : null;

  @override
  String modelName() => baseTag();

  @override
  void setField(String pField, dynamic pValue)
  => (pField == mfTitle && (pValue is String))
    ? title = pValue
    : (pField == mfSubTitle && (pValue is String || pValue is String?))
      ? subTitle = pValue
      : (pField == "$mfTitle|$mfSubTitle" && (pValue is String || pValue is String?))
        ? (){
          String t;
          String? s;
          (t, s) = splitAt(pValue, '|');
          setTitles(pTitle: t, pSubTitle: s);
        }()
        : null;

  @override
  String toJson() => jsonEncode(toMap);

  /// 📍 'ldTagMixin': Retorna la base del tag a fer servir en cas que no es proporcioni cap.
  @override String baseTag() => LdAppBarModel.className;
}