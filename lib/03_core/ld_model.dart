// ld_model.dart
// Abstracció d'una entitat de dades de l'aplicació.
// L'M de Model-View-Control.
// CreatedAt: 2025/04/07 dl. JIQ

import 'package:ld_wbench5/03_core/ld_bindings.dart';
import 'package:ld_wbench5/03_core/ld_tag_builder.dart';
import 'package:ld_wbench5/03_core/mixins/ld_tag_mixin.dart';

// 📦 MEMBRES ESTÀTICS ---------------
const String  mfTitle    = "mfTitle";
const String  mfSubTitle = "mfSubTitle";

/// Abstracció d'una entitat de dades de l'aplicació.
abstract class LdModel 
with LdTagMixin {
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

  // 📍 'Object': IMPLEMENTACIÓ ABSTRACTA -------
  String toStr({ int pLevel = 0 });
}