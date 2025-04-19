// ld_tag_mixin.dart
// Mixin per a incorporar capacitats d'identificació única i cerca de dependències.
// CreatedAt: 2025/04/15 dt. JIQ

import 'package:flutter/material.dart';
import 'package:ld_wbench5/03_core/interfaces/ld_ctrl_intf.dart';
import 'package:ld_wbench5/03_core/interfaces/ld_disposable_intf.dart';
import 'package:ld_wbench5/03_core/interfaces/ld_model_intf.dart';
import 'package:ld_wbench5/03_core/interfaces/ld_tag_intf.dart';
import 'package:ld_wbench5/03_core/ld_bindings.dart';
import 'package:ld_wbench5/03_core/ld_model.dart';
import 'package:ld_wbench5/03_core/ld_tag_builder.dart';
import 'package:ld_wbench5/03_core/views/ld_view.dart';
import 'package:ld_wbench5/03_core/widgets/ld_widget.dart';
import 'package:ld_wbench5/10_tools/once_set.dart';

/// Mixin per a incorporar capacitats d'identificació única i cerca de dependències.
mixin      LdTagMixin
implements LdDisposableIntf, LdTagIntf {
  // 🧩 MEMBRES ------------------------
  final OnceSet<String> _tag = OnceSet<String>();

  // 🪟 GETTERS I SETTERS --------------
  /// Retorna el tag únic de l'objecte.
  @override String get tag => _tag.get(pError: "El tag de l'objecte encara no s'ha assignat!");

  /// Estableix el tag únic de l'objecte.
  @override set tag(String pTag) => _tag.set(pTag, pError: "El tag de l'objecte ja estava assignat!");

  // REGISTRE DEL 'tag' ---------------
  /// Registra la instància corresponent al 'tag'.
  @override registerTag<T extends LdTagIntf>({ required String? pTag, required T pInst }) {
    tag = (this is LdCtrlIntf)
      ? LdTagBuilder.newCtrlTag(pTag?? baseTag())
      : (this is LdModelIntf || this is LdModel)
        ? LdTagBuilder.newModelTag(pTag?? baseTag())
        : (this is LdWidget)
          ? LdTagBuilder.newWidgetTag(pTag?? baseTag())
          : (this is LdView)
            ? LdTagBuilder.newViewTag(pTag?? baseTag())
            : LdTagBuilder.newTag(pTag ?? baseTag(), "Unknown");
    LdBindings.set(tag, pInst: this);
  }

  /// Assegura que durant l'alliberament de recursos s'elimina la instància pel seu 'tag'.
  @override
  @mustCallSuper
  void dispose() {
    LdBindings.remove(tag);
  }
  
  /// 📍 Retorna la base del tag a fer servir en cas que no es proporcioni cap.
  @override String baseTag();
}