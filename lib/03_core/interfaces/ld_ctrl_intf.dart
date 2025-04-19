// ld_ctrl_intf.dart
// Interfície que declara les funcions que ha d'implementar un widget o una vista
// per tal de poder controlar el seu cicle de vida.
// CreatedAt: 2025/02/08 dt. JIQ

import 'package:flutter/material.dart';
import 'ld_disposable_intf.dart';

/// Interfície que declara les funcions que ha d'implementar un widget o una vista
/// per tal de poder controlar el seu cicle de vida.
abstract class LdCtrlIntf<W extends StatefulWidget>
extends  LdDisposableIntf {
  /// Equivalent a initState
  void onInit();

  /// Equivalent a didChangeDependencies
  void onDependenciesResolved();

  /// Equivalent a didUpdateWidget
  void onWidgetUpdated(covariant W pOldWidget);

  /// Opcional: notifica quan la vista ha estat construïda.
  void onRendered(BuildContext pBCtx);

  /// Equivalent a deactivate.
  void onDeactivate();

  /// Equivalente a dispose.
  void onDispose();
}