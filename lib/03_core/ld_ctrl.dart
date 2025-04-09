// ld_ctrl.dart
// Abstracció del controlador d'una pàgina de l'aplicació.
// La C de Model-View-Control.
// CreatedAt: 2025/04/07 dl. JIQ

import 'package:flutter/material.dart';
import 'package:ld_wbench5/03_core/ld_bindings.dart';
import 'package:ld_wbench5/03_core/ld_tag_builder.dart';
import 'package:ld_wbench5/03_core/mixins/ld_tag_mixin.dart';

/// Abstracció del controlador d'una pàgina de l'aplicació.
abstract class LdCtrl<W extends StatefulWidget>
extends  State<W>
with     LdTagMixin {
  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  LdCtrl({ String? pTag })
  : super() {
    (pTag != null) 
      ? set(pTag) 
      : set("${baseTag()}_${LdTagBuilder.newCtrlId}}");
    LdBindings.set(tag, pInst: this);
  }

  @mustCallSuper
  void onDispose() {
    LdBindings.remove(tag);
    super.dispose();
  }


  @override
  void setState(VoidCallback pCBack) {
    super.setState(pCBack);
  }

}

