// ld_ctrl_model.dart
// Abstracció del controlador d'una instància de dades.
// La C de Model-View-Control.
// CreatedAt: 2025/04/07 dl. JIQ

import 'package:flutter/material.dart';
import 'package:ld_wbench5/03_core/interfaces/ld_ctrl_intf.dart';
import 'package:ld_wbench5/03_core/interfaces/ld_tag_intf.dart';
import 'package:ld_wbench5/03_core/views/ld_view.dart';
import 'package:ld_wbench5/10_tools/once_set.dart';

/// Abstracció del controlador d'una instància de dades.
mixin      LdCtrlModel<W extends StatefulWidget>
on         State<W>
implements LdTagIntf, LdCtrlIntf {
  // 🧩 MEMBRES ------------------------
  final OnceSet<LdView> _view  = OnceSet<LdView>();

  // 🪟 GETTERS I SETTERS --------------
  /// Retorna la vista del controlador.
  LdView get view => _view.get();

  /// Estableix la vista del controlador.
  set view(LdView pView) => _view.set(pView);
}

