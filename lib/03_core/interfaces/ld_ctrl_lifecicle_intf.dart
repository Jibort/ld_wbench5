// ld_ctrl_lifecicle_intf.dart
// Interfície que declara les funcions que ha d'implementar un widget o una vista
// per tal de poder controlar el seu cicle de vida.
// CreatedAt: 2025/02/08 dt. JIQ

import 'package:flutter/material.dart';
import 'ld_disposable_intf.dart';

/// Interfície que declara les funcions que ha d'implementar un widget o una vista
/// per tal de poder controlar el seu cicle de vida.
abstract class LdCtrlLifecycleIntf<W extends StatefulWidget>
extends LdDisposableIntf {
  /// Equivalent a initState
  void onInit();

  /// Equivalent a didChangeDependencies
  void onDependenciesResolved();

  /// Equivalent a didUpdateWidget
  void onWidgetUpdated(covariant W pOldWidget);

  /// Equivalent a deactivate
  void onDeactivate();

  /// Allibera qualsevol recurs que hagi estat assignat a la instància.
  @override void dispose();

  /// Opcional: notifica quan la vista ha estat construïda.
  void onRendered(BuildContext pBCtx);
}