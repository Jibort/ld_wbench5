// sabina_app_state.dart
// Estat del widget que correspon a la classe 'SabinaApp'.
// CreatedAt: 2025/04/25 dv. JIQ

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:ld_wbench5/01_pages/ui_consts.dart';
import 'package:ld_wbench5/03_core/app/sabina_app.dart';
import 'package:ld_wbench5/09_intl/L.dart';
import 'package:ld_wbench5/routes.dart';

/// Estat del widget que correspon a la classe 'SabinaApp'.
class   SabinaAppState
extends State<SabinaApp> {

  // 🛠️ CONSTRUCTOR/DISPOSE -----------
  SabinaAppState();

  // ⚙️📍 IMPLEMENTACIÓ ABSTRACTA ------
  /// ♻️📍 'State': Construtor del widget.
  @override
  Widget build(BuildContext pBCtx) 
  => ScreenUtilInit(
      // Tamaño de diseño base (normalmente el tamaño en el que diseñaste la UI)
      designSize:      resSabina,
      minTextAdapt:    true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        title: L.sSabina.tx,
        debugShowCheckedModeBanner: false,
        routes: pageRoutes,
        initialRoute: rootPage,
      ),
  );
  
}