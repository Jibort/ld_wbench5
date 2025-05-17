// ld_app_bar_ctrl.dart
// Controlador del widget LdAppBar.
// Created: 2025-05-01 dc. JIQ
// Updated: 2025/05/05 dl. CLA - Millora del suport d'internacionalització
// Updated: 2025/05/12 dt. CLA - Correcció per seguir l'arquitectura unificada

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_ctrl_abs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/ui/widgets/ld_app_bar/ld_app_bar.dart';
import 'package:ld_wbench5/ui/widgets/ld_app_bar/ld_app_bar_model.dart';

/// Controlador del widget LdAppBar.
class LdAppBarCtrl extends LdWidgetCtrlAbs<LdAppBar> {
  /// Constructor
  LdAppBarCtrl(super.pWidget);

  @override
  void initialize() {
    //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: Inicialitzant controlador de la AppBar");
    
    // Crear el model amb la configuració del widget
    final config = widget.config;
    final titleKey = config[cfTitleKey] as String?;
    final subTitleKey = config[cfSubTitleKey] as String?;
    
    if (titleKey != null) {
      model = LdAppBarModel(
        widget,
        pTitleKey: titleKey,
        pSubTitleKey: subTitleKey,
      );
    }
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
      
      // Actualitzar les traduccions del model
      if (model != null) {
        (model as LdAppBarModel).updateTranslations();
      }
      
      // Forçar una reconstrucció de l'AppBar
      if (mounted) {
        setState(() {
          //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: Forçant reconstrucció de l'AppBar amb el nou idioma");
        });
      }
    }
    
    // Gestionar reconstrucció global de la UI
    if (event.eType == EventType.rebuildUI) {
      //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: Processant esdeveniment de reconstrucció de la UI");
      
      if (mounted) {
        setState(() {
          //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: Reconstruint l'AppBar");
        });
      }
    }
  }
  
  @override
  Widget buildContent(BuildContext context) {
    //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: Construint AppBar");
    
    final config = widget.config;
    final appBarModel = model as LdAppBarModel?;
    
    // Obtenir el títol (widget o text traduït)
    Widget? titleWidget = config[cfTitle] as Widget?;
    String? titleKey = config[cfTitleKey] as String?;
    String? subTitleKey = config[cfSubTitleKey] as String?;
    
    // Si hi ha un widget títol directe, utilitzar-lo
    if (titleWidget != null) {
      return AppBar(
        title: titleWidget,
        leading: config[cfLeading] as Widget?,
        actions: config[cfActions] as List<Widget>?,
        backgroundColor: config[cfBackgroundColor] as Color?,
        foregroundColor: config[cfForegroundColor] as Color?,
        elevation: config[cfElevation] as double?,
        centerTitle: config[cfCenterTitle] as bool?,
        primary: config[cfPrimary] as bool? ?? true,
        flexibleSpace: config[cfFlexibleSpace] as Widget?,
        bottom: config[cfBottom] as PreferredSizeWidget?,
        iconTheme: config[cfIconTheme] as IconThemeData?,
        actionsIconTheme: config[cfActionsIconTheme] as IconThemeData?,
        excludeHeaderSemantics: config[cfExcludeHeaderSemantics] as bool? ?? false,
        titleSpacing: config[cfTitleSpacing] as double?,
        toolbarOpacity: config[cfToolbarOpacity] as double? ?? 1.0,
        bottomOpacity: config[cfBottomOpacity] as double? ?? 1.0,
        toolbarHeight: config[cfToolbarHeight] as double?,
        leadingWidth: config[cfLeadingWidth] as double?,
        toolbarTextStyle: config[cfToolbarTextStyle] as TextStyle?,
        titleTextStyle: config[cfTitleTextStyle] as TextStyle?,
        systemOverlayStyle: config[cfSystemOverlayStyle] as SystemUiOverlayStyle?,
        forceMaterialTransparency: config[cfForceMaterialTransparency] as bool? ?? false,
        clipBehavior: config[cfClipBehavior] as Clip?,
      );
    }
    
    // Si hi ha claus de títol/subtítol i model, construir AppBar amb textos traduïts
    if (titleKey != null && appBarModel != null) {
      if (subTitleKey != null && appBarModel.subTitleKey != null) {
        // AppBar amb títol i subtítol
        return AppBar(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(appBarModel.titleKey, style: TextStyle(fontSize: 20.0.sp)),
              Text(appBarModel.subTitleKey!, style: TextStyle(fontSize: 14.0.sp)),
            ],
          ),
          leading: config[cfLeading] as Widget?,
          actions: config[cfActions] as List<Widget>?,
          backgroundColor: config[cfBackgroundColor] as Color?,
          foregroundColor: config[cfForegroundColor] as Color?,
          // Afegir la resta de paràmetres...
        );
      } else {
        // AppBar només amb títol
        return AppBar(
          title: Text(appBarModel.titleKey),
          leading: config[cfLeading] as Widget?,
          actions: config[cfActions] as List<Widget>?,
          backgroundColor: config[cfBackgroundColor] as Color?,
          foregroundColor: config[cfForegroundColor] as Color?,
          // Afegir la resta de paràmetres...
        );
      }
    }
    
    // AppBar buit per defecte
    return AppBar(
      title: const Text("AppBar"),
      leading: config[cfLeading] as Widget?,
      actions: config[cfActions] as List<Widget>?,
      backgroundColor: config[cfBackgroundColor] as Color?,
      foregroundColor: config[cfForegroundColor] as Color?,
    );
  }
}