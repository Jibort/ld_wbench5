// ld_app_bar.dart
// Widget adaptat per a la barra de títol.
// CreatedAt: 2025/02/09 dc. JIQ

import 'package:flutter/material.dart';
import 'package:ld_wbench5/03_core/ld_tag_builder.dart';
import 'package:ld_wbench5/03_core/widgets/ld_widget.dart';
import 'package:ld_wbench5/03_core/widgets/ld_widget_model.dart';
import 'package:ld_wbench5/10_tools/debug.dart';

/// Widget adaptat per a la barra de títol.
class   LdAppBar
extends LdWidget<LdAppBarCtrl, LdAppBar, LdAppBarModel> {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "LdAppBar";
  static final String _appBarTag = LdTagBuilder.newWidgetTag(LdAppBar.className);
  
  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  LdAppBar({ 
    required super.key, 
    required super.pView,
    String? pTag,
    required String pTitle,
    String? pSubTitle })
  : super(
      pTag: pTag?? _appBarTag,
      pModel: LdAppBarModel(
        pTitle: pTitle, 
        pSubTitle: pSubTitle
      ),
    ) {
    super.wCtrl = LdAppBarCtrl(
      pView: super.view, 
      pWidget: this,
      pTag: LdTagBuilder.newWidgetTag(LdAppBar.className),
    );
  }

  /// 📍 'ldTagMixin': Retorna la base del tag a fer servir en cas que no es proporcioni cap.
  @override String baseTag() => LdAppBar.className;

  /// 📍 'StatefulWidget': Retorna el controlador del Widget.
  @override LdWidgetCtrl<LdAppBarCtrl, LdAppBar, LdAppBarModel> createState() => wCtrl;
}

/// Model de dades del widget LdAppBar.
class LdAppBarModel
extends LdWidgetModel {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "LdAppBar";

  // 🧩 MEMBRES ------------------------
  String  _title;
  String? _subTitle;

  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  LdAppBarModel({
    super.isEnabled   = true,
    super.isVisible   = true,
    super.isFocusable = false,
    required String pTitle,
    String? pSubTitle, })
  : _title    = pTitle,
    _subTitle = pSubTitle;

  // 🪟 GETTERS I SETTERS --------------
  /// Retorna el títol de la barra de capçalera de la vista.
  String get title => _title;
  /// Actualitza el títol de la barra de capçalera de la vista.
  set title(String pTitle) => wCtrl.setState(() =>  _title = pTitle);

  /// Retorna el subtítol de la barra de capçalera de la vista.
  String? get subTitle => _subTitle;
  /// Actualitza el subtítol de la barra de capçalera de la vista.
  set subTitle(String? pSubTitle) => wCtrl.setState(() =>  _subTitle = pSubTitle);

  /// Actualitza els títol i subtítol de la barra de capçalera de la vista.
  void setTitles({ required String pTitle, String? pSubTitle }) {
    wCtrl.setState(() {
      _title    = pTitle;
      _subTitle = pSubTitle;
    });
  }

  // 📍 IMPLEMENTACIÓ ABSTRACTA -------
  /// 📍 'ldTagMixin': Retorna la base del tag a fer servir en cas que no es proporcioni cap.
  @override String baseTag() => LdAppBarModel.className;
}

class   LdAppBarCtrl 
extends LdWidgetCtrl<LdAppBarCtrl, LdAppBar, LdAppBarModel> {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "LdAppBarCtrl";
  
  // 🧩 MEMBRES ------------------------
  
  // 🛠️ CONSTRUCTORS/CLEANERS ---------  
  /// Constructor base del controlador.
  LdAppBarCtrl({ 
    required super.pView, 
    required super.pWidget,
    String? pTag,
  }): super(pTag: pTag?? LdTagBuilder.newCtrlTag(LdAppBarCtrl.className));

  /// 📍 'LdOnDisposableIntf': Called when this object is removed from the tree permanently.
  @override
  void onDispose() {
    Debug.info("[$tag.onDispose()]: Instància completament eliminada.");
    super.onDispose();
  }
  
  // 📍 IMPLEMENTACIÓ ABSTRACTA -------
  /// 📍 'ldTagMixin': Retorna la base del tag a fer servir en cas que no es proporcioni cap.
  @override String baseTag() => LdAppBarCtrl.className;

  // ♻️ CLICLE DE VIDA ----------------
  /// 📍 'LdCtrlLifecycleIntf': Equivalent a deactivate
  @override
  void onDeactivate() {
    Debug.info("[$tag.onDeactivate()]: Instància eliminada de l'arbre.");
  }

  /// 📍 'LdCtrlLifecycleIntf': Equivalent a initState
  @override
  void onInit() {
    Debug.info("[$tag.onInit()]: Instància insertada a l'arbre.");
  }

  /// 📍 'LdCtrlLifecycleIntf': Equivalent a didChangeDependencies
  @override
  void onDependenciesResolved() {
    Debug.info("[$tag.onDependenciesResolved()]: Dependència actualitzada.");
  }

  /// 📍 'LdCtrlLifecycleIntf': Opcional, notifica quan la vista ha estat construïda.
  @override
  void onRendered(BuildContext pBCtx) {
    Debug.info("[$tag.onInit()]: Instància insertada a l'arbre.");
  }


  /// 📍 'LdCtrlLifecycleIntf': Equivalent a didUpdateWidget
  @override
  void onWidgetUpdated(covariant LdAppBar pOldWidget) {
    widget = pOldWidget;
    Debug.info("[$tag.onInit()]: Instància insertada a l'arbre.");

  }
  
  // ⚙️📍 FUNCIONALITAT ----------------
  /// Creació de tot l'arbre de components de 'LdAppbar'.
  @override
  Widget buildWidget(BuildContext pBCtx) 
    => AppBar(
        title: (view.model.subTitle == null)
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
      actions: [],
    );
}
