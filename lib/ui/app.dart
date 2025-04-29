// app.dart
// Widget principal de l'aplicació
// Created: 2025/04/29 dt. CLA[JIQ]

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:ld_wbench5/core/ld_taggable_mixin.dart';
import 'package:ld_wbench5/core/event_system.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/services/theme_service.dart';
import 'package:ld_wbench5/services/L.dart';
import 'package:ld_wbench5/ui/ui_consts.dart';
import 'package:ld_wbench5/utils/debug.dart';
import 'package:ld_wbench5/ui/pages/test_page.dart';

/// Widget principal de l'aplicació
class   SabinaApp 
extends StatefulWidget 
with    LdTaggableMixin {
  /// Instància singleton
  static final SabinaApp _inst = SabinaApp._();
  static SabinaApp get inst => _inst;
  
  /// Constructor privat
  SabinaApp._() {
    tag = className;
  }
  
  @override
  State<SabinaApp> createState() => _SabinaAppState();
}

class _SabinaAppState extends State<SabinaApp> with WidgetsBindingObserver {
  /// Subscripció als events
  StreamSubscription? _eventSubscription;
  
  /// Mode del tema actual
  ThemeMode _themeMode = ThemeMode.system;
  
  @override
  void initState() {
    super.initState();
    Debug.info("SabinaApp: inicialitzant");
    
    // Registrar observer per als canvis del sistema
    WidgetsBinding.instance.addObserver(this);
    
    // Inicialitzar idioma
    L.deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
    
    // Subscriure's als events
    _eventSubscription = EventBus().events.listen(_handleEvent);
    
    // NO Inicialitzar tema
    // _themeMode = ThemeService.instance.themeMode;
  }
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _eventSubscription?.cancel();
    super.dispose();
  }
  
  /// Gestiona els events rebuts
  void _handleEvent(LdEvent event) {
    if (event.type == EventType.themeChanged) {
      setState(() {
        _themeMode = ThemeService.inst.themeMode;
      });
    }
  }
  
  /// Gestiona els canvis en l'estat del cicle de vida de l'aplicació
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    Debug.info("SabinaApp: Canvi d'estat del cicle de vida: $state");
    
    EventBus().emit(LdEvent(
      type: EventType.applicationStateChanged,
      srcTag: widget.tag,
      data: {
        mfLifecycleState: state.toString(),
      },
    ));
  }
  
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: designSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        // Ara ScreenUtil ja està preparat
        _themeMode = ThemeService.inst.themeMode;

        return MaterialApp(
          title: L.sSabina.tx,
          debugShowCheckedModeBanner: false,
          theme: ThemeService.inst.lightTheme,
          darkTheme: ThemeService.inst.darkTheme,
          themeMode: _themeMode,
          home: child ?? TestPage(),
        );
      }
    );
  }
}