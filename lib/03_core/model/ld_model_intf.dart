// ld_model_intf.dart
// Interfície d'una estructura de dades de l'aplicació.
// L'M de Model-View-Control.
// CreatedAt: 2025/04/15 dt. JIQ

import 'package:flutter/material.dart';
import 'package:ld_wbench5/03_core/interfaces/ld_disposable_intf.dart';
import 'package:ld_wbench5/10_tools/ld_map.dart';

// 📦 CONSTANTS PÚBLIQUES --------------
// Altres noms identificadors.
const String mfIsEnabled          = "mfIsEnabled";
const String mfIsVisible          = "mfIsVisible";
const String mfIsFocusable        = "mfIsFocusable";
const String mfIsPrimary          = "mfIsPrimary";
const String mfOnPressed          = "mfOnPressed";
const String mfLeftIcon           = "mfLeftIcon";
const String mfWidth              = "mfWidth";
const String mfHeight             = "mfHeight";
const String mfElevation          = "mfElevation";
const String mfBorderRadius       = "mfBorderRadius";
const String mfPadding            = "mfPadding";
const String mfPrimaryColor       = "mfPrimaryColor";
const String mfPrimaryTextColor   = "mfPrimaryTextColor";
const String mfSecondaryColor     = "mfSecondaryColor";
const String mfSecondaryTextColor = "mfSecondaryTextColor";
const String mfDisabledColor      = "mfDisabledColor";
const String mfDisabledTextColor  = "mfDisabledTextColor";
const String mfTextStyle          = "mfTextStyle";
const String mfExpanded           = "mfExpanded";
const String mfMainAxisSize       = "mfMainAxisSize";
const String mfMainAxisAlignment  = "mfMainAxisAlignment";
const String mfCrossAxisAlignment = "mfCrossAxisAlignment";

/// Interfície d'una entitat de dades de l'aplicació.
abstract class LdModelIntf 
extends  LdDisposableIntf {
  // 📍 FUCIONS ABSTRACTES -------------
  /// Retorna el nom de la classe tipus.
  String modelName();

  /// Retorna una cadena en format JSON amb el contingut de la instància del model.
  String toJson();

  /// Retorna un mapa amb el contingut dels membres de la instància del model.
  @mustCallSuper
  LdMap toMap();

  /// Actualitza la instància del model amb els camps informats en la cadena JSON.
  void fromJson(String pJSon);

  /// Actualitza la instància del model amb els camps informats al mapa.
  @mustCallSuper
  void fromMap(LdMap pMap);

  /// Retorna el valor d'un component donat o null.
  dynamic getField(String pField);

  /// Estableix el valor d'un component donat del model.
  void setField(String pField, dynamic pValue);
}