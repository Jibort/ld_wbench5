// ld_test_01_ctrl.dart
// Controlador específic de la vista de proves 'LdTest01'.
// CreatedAt: 2025/04/08 dt. JIQ

import 'package:flutter/material.dart';

import 'ld_test_01.dart';
import 'package:ld_wbench5/02_widgets/ld_button/ld_button.dart';
import 'package:ld_wbench5/02_widgets/ld_scaffold/ld_scaffold.dart';
import 'package:ld_wbench5/03_core/ld_tag_builder.dart';
import 'package:ld_wbench5/03_core/views/ld_view_ctrl.dart';
import 'package:ld_wbench5/08_theme/ld_theme.dart';
import 'package:ld_wbench5/09_intl/L.dart';
import 'package:ld_wbench5/10_tools/debug.dart';

/// Controlador específic de la vista de proves 'LdTest01'.
class   LdTest01Ctrl
extends LdViewCtrl<LdTest01> {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "LdTest01Ctrl";

  // 🧩 MEMBRES ------------------------
  late final String _tagBtnLang;
  late final String _tagBtnTheme;

  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  /// Constructor bàsic del controlador de la vista 'LdTest01'.
  LdTest01Ctrl({ 
    required super.pView, super.pTag });

  /// 📍 'ldTagMixin': Retorna la base del tag a fer servir en cas que no es proporcioni cap.
  @override String baseTag() => LdTest01Ctrl.className;

  // ♻️ CLICLE DE VIDA ----------------
  /// 📍 'LdCtrlLifecycleIntf': Called when this object is inserted into the tree.
  @override
  void onInit() {
    _tagBtnLang  = LdTagBuilder.newWidgetTag("btnLang");
    _tagBtnTheme = LdTagBuilder.newWidgetTag("btnTheme");
    Debug.info("[$tag.onInit()]: Instància inserida a l'arbre.");
  }
  
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
  
  /// 📍 'LdCtrlLifecycleIntf': Opcional, notifica quan la vista ha estat construïda.
  @override
  void onRendered(BuildContext pBCtx) {
    Debug.info("[$tag.onInit()]: Instància inserida a l'arbre.");
  }
  
  /// 📍 'LdCtrlLifecycleIntf': Equivalent a didUpdateWidget
  @override
  void onWidgetUpdated(LdTest01 pOldView) {
    view = pOldView;
  }
  
  /// 📍 'LdViewCtrl': Descripció explícita de l'arbre de widgets de la pàina 'LdTest01'.
  @override
  Widget buildView(BuildContext pBCtx)
    => LdScaffold(
      key: null,
      pView: view,
      pTitle: L.sSabina.tx,
      pSubTitle: L.sAppSabina.tx,
      pBody: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LdButton(
              key: null,
              pTag: _tagBtnLang,
              pView: view,
              text: "Canvia l'Idioma",
              onPressed: () {
                Locale oldL = L.currLocale();
                Locale newL = (oldL.languageCode == "es") ? Locale("ca"): Locale("es"); 
                L.setCurrLocale(newL);
              },
            ),
            LdButton(
              key: null,
              pTag: _tagBtnTheme,
              pView: view,
              text: "Canvia el Tema",
              onPressed: () {
                ThemeMode mode = LdTheme.single.themeMode;
                LdTheme.single.changeThemeMode((mode == ThemeMode.dark)?ThemeMode.light: ThemeMode.dark);
              },
            ),
          ],
        )
      )
    );

}