// view_event_model.dart
// Model de representació d'un event que afecti la vista.
// CreatedAt: 2025/04/26 ds. JIQ

import 'package:flutter/material.dart';
import 'package:ld_wbench5/03_core/event/view/view_event.dart';
import 'package:ld_wbench5/03_core/model/ld_model_abs.dart';
import 'package:ld_wbench5/10_tools/full_set.dart';
import 'package:ld_wbench5/10_tools/ld_map.dart';

const String mfOldLocaleModel = "mfOldLocaleModel";
const String mfNewLocaleModel = "mfNewLocaleModel";

/// Model de representació d'un event que afecti la vista.
class   ViewEventModel 
extends LdModelAbs {
  // 📐 FUNCIONALITAT ESTÀTICA ---------
  static ViewEvent envelope({
    required String pSrc,
    List<String>? pTgts, 
    required ViewEventModel pModel })
  => ViewEvent(pSrc: pSrc, pModel: pModel);

  // 🧩 MEMBRES ------------------------
  final FullSet<Locale?> _oldLocale = FullSet<Locale?>();
  final FullSet<Locale>  _newLocale = FullSet<Locale>();

  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  ViewEventModel({ Locale? pOld, required Locale pNew }) {
    _oldLocale.set(pOld);
    _newLocale.set(pNew);
  }

  // 🪟 GETTERS I SETTERS --------------
  Locale?  get oldLocale => _oldLocale.get();
  set oldLocale(Locale? pOld) => _oldLocale.set(pOld);
  Locale   get newLocale => _newLocale.get()!;
  set newLocale(Locale? pNew) => _newLocale.set(pNew);

  bool get hasChanged => oldLocale != newLocale;

  // 📍 IMPLEMENTACIÓ ABSTRACTA --------
  /// 📍 'LdModel': Retorna el tag per defecte quan aquest non s'especifica.
  @override String baseTag() => "ViewEventModel";

  /// 📍 'LdModel': Reconstrueix la instància a partir d'un mapa de valors.
  @override
  void fromMap(LdMap pMap) {
    tag = pMap[mfTag];
    _oldLocale.set(pMap[mfOldLocaleModel]);
    _newLocale.set(pMap[mfNewLocaleModel]);
  } 

/// 📍 'LdModel': Retorna el mapa de valors del model.
  @override
  LdMap toMap() => LdMap(pMap: {
    mfTag:            tag,
    mfOldLocaleModel: oldLocale,
    mfNewLocaleModel: newLocale,
  });

  /// 📍 'LdModel': Retorna el valor d'un camp del model.
  @override
  dynamic getField(String pField) 
  => (pField == mfTag)
    ? tag
    : (pField == mfOldLocaleModel)
      ? oldLocale
      : (pField == mfNewLocaleModel)
        ? newLocale
        : null;

  /// 📍 'LdModel': Retorna el nom comú del model.
  @override String modelName() => baseTag();

  /// 📍 'LdModel': Estableix el valor d'un camp del model.
  @override
  void setField(String pField, dynamic pValue) 
  => (pField == mfTag && pValue is String)
    ? tag = pValue
    : (pField == mfOldLocaleModel && pValue is Locale?)
      ? oldLocale = pValue
      : (pField == mfNewLocaleModel && pValue is Locale)
        ? newLocale
        : null;

  /// 📍 'LdModel': Retorna la cadena JSON que representa el model.
  @override String toJson() 
  => throw Exception("LocaleEventModel no pot ser serialitzat en JSON!");

  /// 📍 'LdModel': Reconstrueix la instància a partir d'una estructura JSON.
  @override void fromJson(String pJSon)
  => throw Exception("LocaleEventModel no pot ser deserialitzat des de JSON!");

}