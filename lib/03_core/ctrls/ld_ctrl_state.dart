// ld_ctrl_state.dart
// Abstracció del controlador de l'State d'un 'StatefulWidget'.
// La C de Model-View-Control.
// CreatedAt: 2025/04/07 dl. JIQ

import 'package:flutter/material.dart';
import 'package:ld_wbench5/03_core/interfaces/ld_ctrl_intf.dart';
import 'package:ld_wbench5/03_core/views/ld_view.dart';
import 'package:ld_wbench5/10_tools/once_set.dart';

/// Abstracció del controlador d'una instància de dades.
mixin      LdCtrlState<W extends StatefulWidget>
on         State<W>
implements LdCtrlIntf {
  // 🧩 MEMBRES ------------------------
  final OnceSet<LdView> _view  = OnceSet<LdView>();

  // 🪟 GETTERS I SETTERS --------------
  /// Retorna la vista del controlador.
  LdView get view => _view.get();

  /// Estableix la vista del controlador.
  set view(LdView pView) => _view.set(pView);
}

