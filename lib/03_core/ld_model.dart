// ld_model.dart
// Abstracció d'una entitat de dades de l'aplicació.
// L'M de Model-View-Control.
// CreatedAt: 2025/04/07 dl. JIQ

import 'package:flutter/foundation.dart';
import 'package:ld_wbench5/03_core/ld_bindings.dart';
import 'package:ld_wbench5/03_core/ld_tag_builder.dart';
import 'package:ld_wbench5/03_core/mixins/ld_tag_mixin.dart';
import 'package:ld_wbench5/10_tools/ld_map.dart';

// 📦 CONSTANTS PÚBLIQUES --------------
const String mfTitle              = "mfTitle";
const String mfSubTitle           = "mfSubTitle";
const String mfIsEnabled          = "mfIsEnabled";
const String mfIsVisible          = "mfIsVisible";
const String mfIsFocusable        = "mfIsFocusable";
const String mfIsPrimary          = "mfIsPrimary";
const String mfText               = "mfText";
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

/// Abstracció d'una entitat de dades de l'aplicació.
abstract class LdModel 
with LdTagMixin {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "LdModel";
  
  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  LdModel({ String? pTag }) {
    (pTag != null) 
      ? set(pTag) 
      : set("${baseTag()}_${LdTagBuilder.newModelId}}");
    LdBindings.set(tag, pInst: this);
  }

  @override
  void dispose() {
    LdBindings.remove(tag);
  }

  // 📍 FUCIONS ABSTRACTES -------------
  /// Retorna un mapa amb el contingut dels membres de la instància del model.
  @mustCallSuper
  LdMap toMap();

  /// Actualitza la instància del model amb els camps informats al mapa.
  @mustCallSuper
  void fromMap(LdMap pMap);

  /// Retorna el valor d'un component donat o null.
  dynamic getField(String pField);

  /// Estableix el valor d'un component donat del model.
  void setField(String pField, dynamic pValue);
}