// ld_scaffold_ctrl.dart
// Controlador del widget LdScaffold.
// Created: 2025/05/03 ds. JIQ
// Updated: 2025/05/03 ds. CLA
// Updated: 2025/05/12 dt. CLA - Correcció per seguir l'arquitectura unificada

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_ctrl_abs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/ui/widgets/ld_scaffold/ld_scaffold.dart';

/// Controlador per al LdScaffold
class LdScaffoldCtrl extends LdWidgetCtrlAbs<LdScaffold> {
  /// Constructor
  LdScaffoldCtrl(super.pWidget);
  
  @override
  void initialize() {
    //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: Inicialitzant controlador del scaffold");
  }
  
  @override
  void update() {
    // No cal fer res de moment
  }
  
  @override
  void onEvent(LdEvent event) {
    //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: Rebut esdeveniment ${event.eType.name}");
    
    // Gestionar canvis d'idioma
    if (event.eType == EventType.languageChanged) {
      //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: Processant esdeveniment de canvi d'idioma");
      
      // Forçar una reconstrucció del Scaffold
      if (mounted) {
        setState(() {
          //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: Forçant reconstrucció del Scaffold amb el nou idioma");
        });
      }
    }
    
    // Gestionar reconstrucció global de la UI
    if (event.eType == EventType.rebuildUI) {
      //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: Processant esdeveniment de reconstrucció de la UI");
      
      if (mounted) {
        setState(() {
          //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: Reconstruint el Scaffold");
        });
      }
    }
  }
  
  @override
  Widget buildContent(BuildContext context) {
    //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: Construint Scaffold");
    
    // Obtenir configuració del widget
    final config = widget.config;
    
    return Scaffold(
      appBar: config[cfAppBar] as PreferredSizeWidget?,
      body: config[cfBody] as Widget?,
      floatingActionButton: config[cfFloatingActionButton] as Widget?,
      floatingActionButtonLocation: config[cfFloatingActionButtonLocation] as FloatingActionButtonLocation?,
      floatingActionButtonAnimator: config[cfFloatingActionButtonAnimator] as FloatingActionButtonAnimator?,
      persistentFooterButtons: config[cfPersistentFooterButtons] as List<Widget>?,
      drawer: config[cfDrawer] as Widget?,
      endDrawer: config[cfEndDrawer] as Widget?,
      bottomNavigationBar: config[cfBottomNavigationBar] as Widget?,
      bottomSheet: config[cfBottomSheet] as Widget?,
      backgroundColor: config[cfBackgroundColor] as Color?,
      drawerDragStartBehavior: config[cfDrawerDragStartBehavior] as DragStartBehavior? ?? DragStartBehavior.start,
      extendBody: config[cfExtendBody] as bool? ?? false,
      extendBodyBehindAppBar: config[cfExtendBodyBehindAppBar] as bool? ?? false,
      drawerScrimColor: config[cfDrawerScrimColor] as Color?,
      drawerEdgeDragWidth: config[cfDrawerEdgeDragWidth] as double?,
      drawerEnableOpenDragGesture: config[cfDrawerEnableOpenDragGesture] as bool? ?? true,
      endDrawerEnableOpenDragGesture: config[cfEndDrawerEnableOpenDragGesture] as bool? ?? true,
      resizeToAvoidBottomInset: config[cfResizeToAvoidBottomInset] as bool?,
    );
  }
}