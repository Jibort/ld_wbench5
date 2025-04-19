// ld_model.dart
// Abstracció d'una estructura de dades de l'aplicació.
// L'M de Model-View-Control.
// CreatedAt: 2025/04/15 dt. JIQ

import 'package:flutter/cupertino.dart';
import 'package:ld_wbench5/03_core/interfaces/ld_model_intf.dart';
import 'package:ld_wbench5/03_core/mixins/ld_tag_mixin.dart';

// 📦 CONSTANTS PÚBLIQUES --------------
// Noms identificadors de membres d'un model.
const String mfTag      = "mfTag";
const String mfTitle    = "mfTitle";
const String mfSubTitle = "mfSubTitle";
const String mfText     = "mfText";

/// Abstracció d'una estructura de dades de l'aplicació.
abstract   class LdModel
with       LdTagMixin
implements LdModelIntf {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "LdModel";
  
  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  LdModel({ String? pTag }) {
    registerTag(pTag: pTag, pInst: this); 
  }

  // 📍 'LdDisposableIntf': Allibera recursos del model.
  @override
  @mustCallSuper
  void dispose() {
    super.dispose();
  }
}