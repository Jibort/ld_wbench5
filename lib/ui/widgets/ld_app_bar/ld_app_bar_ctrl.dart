// ld_app_bar_ctrl.dart
// Controlador del widget LdAppBar.
// Created: 2025-05-01 dc. JIQ
// Updated: 2025/05/05 dl. CLA - Millora del suport d'internacionalització

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
import 'package:ld_wbench5/ui/widgets/ld_app_bar/ld_app_bar.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Controlador del widget LdAppBar.
class LdAppBarCtrl extends LdWidgetCtrlAbs<LdAppBar> {
  /// Accions de la barra d'aplicació
  final List<Widget>? actions;
  
  /// Constructor
  LdAppBarCtrl(super.pWidget, { this.actions });
  
  /// Accelerador d'accés al model.
  LdAppBarModel get model => cWidget.wModel as LdAppBarModel;

  @override
  void initialize() {
    Debug.info("$tag: Inicialitzant controlador de la AppBar");
    
    // El registre com a observador del model ara es fa automàticament a la classe base
  }
  
  @override
  void update() {
    // No cal fer res de moment
  }
  
  @override
  void onEvent(LdEvent event) {
    Debug.info("$tag: Rebut esdeveniment ${event.eType.name}");
    
    // Gestionar canvis d'idioma
    if (event.eType == EventType.languageChanged) {
      Debug.info("$tag: Processant esdeveniment de canvi d'idioma");
      
      // JAB_Q: Actualitzar les traduccions del model
      // model.updateTranslations();
      
      // Forçar una reconstrucció de l'AppBar
      if (mounted) {
        setState(() {
          Debug.info("$tag: Forçant reconstrucció de l'AppBar amb el nou idioma");
        });
      }
    }
    
    // Gestionar reconstrucció global de la UI
    if (event.eType == EventType.rebuildUI) {
      Debug.info("$tag: Processant esdeveniment de reconstrucció de la UI");
      
      if (mounted) {
        setState(() {
          Debug.info("$tag: Reconstruint l'AppBar");
        });
      }
    }
  }
  
  @override
  Widget buildContent(BuildContext context) {
    Debug.info("$tag: Construint AppBar amb títol: '${model.titleKey}'");
    
    return (model.subTitleKey != null)
      ? AppBar(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(model.titleKey, style: TextStyle(fontSize: 20.0.sp)),
              Text(model.subTitleKey!, style: TextStyle(fontSize: 14.0.sp)),
            ],
          ),
          actions: actions,
        )
      : AppBar(
        title: Text(model.titleKey),
        actions: actions,
      );
  }
}