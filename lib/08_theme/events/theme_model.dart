// theme_event_model.dart
// Model de representació de l'event de canvi de tema visual.
// CreatedAt: 2025/04/19 ds. JIQ

import 'package:flutter/material.dart';
import 'package:ld_wbench5/03_core/ld_model.dart';
import 'package:ld_wbench5/03_core/streams/stream_envelope.dart';
import 'package:ld_wbench5/10_tools/full_set.dart';
import 'package:ld_wbench5/10_tools/ld_map.dart';

const String mfOldThemeModel = "mfOldThemeModel";
const String mfNewThemeModel = "mfNewThemeModel";

/// Model de representació de l'event de canvi de tema visual.
class   ThemeEventModel 
extends LdModel {
  // 📐 FUNCIONALITAT ESTÀTICA ---------
  static StreamEnvelope<ThemeEventModel> envelope({
    required String pSrc,
    List<String>? pTgts, 
    required ThemeEventModel pModel })
  => StreamEnvelope(pSrc: pSrc, pTgts: pTgts, pModel: pModel);

  // 🧩 MEMBRES ------------------------
  final FullSet<ThemeData?> _oldTheme = FullSet<ThemeData?>();
  final FullSet<ThemeData>  _newTheme = FullSet<ThemeData>();

  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  ThemeEventModel(ThemeData? pOld, ThemeData pNew) {
    _oldTheme.set(pOld);
    _newTheme.set(pNew);
  }

  // 🪟 GETTERS I SETTERS --------------
  ThemeData?  get oldTheme => _oldTheme.get();
  set oldTheme(ThemeData? pOld) => _oldTheme.set(pOld);
  ThemeData   get newTheme => _newTheme.get()!;
  set newTheme(ThemeData? pNew) => _newTheme.set(pNew);

  bool get hasChanged => oldTheme != newTheme;

  // 📍 IMPLEMENTACIÓ ABSTRACTA --------
  /// 📍 'LdModel': Retorna el tag per defecte quan aquest non s'especifica.
  @override String baseTag() => "ThemeEventModel";

  /// 📍 'LdModel': Reconstrueix la instància a partir d'un mapa de valors.
  @override
  void fromMap(LdMap pMap) {
    tag = pMap[mfTag];
    _oldTheme.set(pMap[mfOldThemeModel]);
    _newTheme.set(pMap[mfNewThemeModel]);
  } 

/// 📍 'LdModel': Retorna el mapa de valors del model.
  @override
  LdMap toMap() => LdMap(pMap: {
    mfTag:           tag,
    mfOldThemeModel: oldTheme,
    mfNewThemeModel: newTheme,
  });

  /// 📍 'LdModel': Retorna el valor d'un camp del model.
  @override
  dynamic getField(String pField) 
  => (pField == mfTag)
    ? tag
    : (pField == mfOldThemeModel)
      ? oldTheme
      : (pField == mfNewThemeModel)
        ? newTheme
        : null;

  /// 📍 'LdModel': Retorna el nom comú del model.
  @override String modelName() => baseTag();

  /// 📍 'LdModel': Estableix el valor d'un camp del model.
  @override
  void setField(String pField, dynamic pValue) 
  => (pField == mfTag && pValue is String)
    ? tag = pValue
    : (pField == mfOldThemeModel && pValue is ThemeData?)
      ? oldTheme = pValue
      : (pField == mfNewThemeModel && pValue is ThemeData)
        ? newTheme
        : null;

  /// 📍 'LdModel': Retorna la cadena JSON que representa el model.
  @override String toJson() 
  => throw Exception("ThemeEventModel no pot ser serialitzat en JSON!");

  /// 📍 'LdModel': Reconstrueix la instància a partir d'una estructura JSON.
  @override void fromJson(String pJSon)
  => throw Exception("ThemeEventModel no pot ser deserialitzat des de JSON!");

}