// ld_test_01_ctrl.dart
// Controlador específic de la vista de proves 'LdTest01'.
// CreatedAt: 2025/04/08 dt. JIQ

import 'package:flutter/material.dart';
import 'package:ld_wbench5/01_pages/test/ld_test_01.dart';
import 'package:ld_wbench5/02_core/views/ld_view_ctrl.dart';
import 'package:ld_wbench5/10_tools/debug.dart';

/// Controlador específic de la vista de proves 'LdTest01'.
class   LdTest01Ctrl
extends LdViewCtrl<LdTest01> {
  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  /// Constructor bàsic del controlador de la vista 'LdTest01'.
  LdTest01Ctrl({ required super.pView });

  /// 📍 'ldTagMixin': Retorna la base del tag a fer servir en cas que no es proporcioni cap.
  @override String baseTag() => "LdTest01Ctrl";

  // ♻️ CLICLE DE VIDA ----------------
  /// 📍 'LdCtrlLifecycleIntf': Called when this object is removed from the tree.
  @override
  void onDeactivate() {
    Debug.info("[$tag.onDeactivate()]: Instància eliminada de l'arbre.");
  }
  
  /// 📍 'LdCtrlLifecycleIntf': Called when a dependency of this [State] object changes.
  @override
  void onDependenciesResolved() {
        Debug.info("[$tag.onDependenciesResolved()]: Dependència actualitzada.");

  }
  
  /// 📍 'LdOnDisposableIntf': Called when this object is removed from the tree permanently.
  @override
  void onDispose() {
    Debug.info("[$tag.onDispose()]: Instància completament eliminada.");
    super.onDispose();
  }
  
  /// 📍 'LdCtrlLifecycleIntf': Called when this object is inserted into the tree.
  @override
  void onInit() {
    Debug.info("[$tag.onInit()]: Instància insertada a l'arbre.");
  }
  
  /// 📍 'LdCtrlLifecycleIntf': Opcional, notifica quan la vista ha estat construïda.
  @override
  void onRendered(BuildContext pBCtx) {
    Debug.info("[$tag.onInit()]: Instància insertada a l'arbre.");
  }
  
  /// 📍 'LdCtrlLifecycleIntf': Equivalent a didUpdateWidget
  @override
  void onWidgetUpdated(LdTest01 pNewView) {
    view = pNewView;
  }
  
  /// 📍 'LdViewCtrl': Descripció explícita de l'arbre de widgets de la pàina 'LdTest01'.
  @override
  Widget buildView(BuildContext pBCtx)
    => Scaffold(
      appBar: AppBar(
        title: (model.subTitle == null)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(model.title)
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(model.title),
                Text(model.subTitle!),
              ],
            ),
        actions: [],),
    );
    
}