// ld_model.dart
// Abstracció d'una entitat de dades de l'aplicació.
// L'M de Model-View-Control.
// CreatedAt: 2025/04/07 dl. JIQ

import 'package:ld_wbench5/02_core/ld_bindings.dart';
import 'package:ld_wbench5/02_core/ld_tag_builder.dart';
import 'package:ld_wbench5/02_core/mixins/ld_tag_mixin.dart';

/// Abstracció d'una entitat de dades de l'aplicació.
abstract class LdModel 
with LdTagMixin {
  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  LdModel({ String? pTag }) {
    set("${pTag?? baseTag()}_${LdTagBuilder.newModelId}");
    LdBindings.set(tag, pInst: this);
  }

  @override
  void dispose() {
    LdBindings.remove(tag);
  }
}