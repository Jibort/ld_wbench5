// sabina_app_ctrl.dart
// Controlador principal de l'aplicació
// Created: 2025/05/03 ds. JIQ
// Updated: 2025/05/03 ds. CLA

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/services/L.dart';
import 'package:ld_wbench5/ui/pages/test_page/test_page.dart';
import 'package:ld_wbench5/ui/ui_consts.dart';
import 'package:ld_wbench5/core/event_bus/event_bus.dart';
import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/services/theme_service.dart';
import 'package:ld_wbench5/ui/app/sabina_app.dart';
import 'package:ld_wbench5/utils/debug.dart';
import 'package:ld_wbench5/utils/once_set.dart';

/// Controlador principal de l'aplicació
class   SabinaAppCtrl 
extends State<SabinaApp> 
with    WidgetsBindingObserver {
  /// Referència a la instància de l'aplicació.
  final OnceSet<SabinaApp> _app = OnceSet<SabinaApp>();

  /// Retorna la referència a la instància de l'aplicació.
  SabinaApp get app => _app.get(pCouldBeNull: false)!;

  /// Estableix la referència a la instància de l'aplicació.
  set app(SabinaApp pPage) => _app.set(pPage);

  /// Subscripció als events
  StreamSubscription<LdEvent>? _subcEvent;
  
  /// Mode del tema actual
  ThemeMode _themeMode = ThemeMode.system;
  
  /// Indicador de reconstrucció per canvi d'idioma
  bool _languageChanged = false;
  
  /// CONSTRUCTORS --------------------
  SabinaAppCtrl({ required SabinaApp pApp }) { app = pApp; }

  @override
  void initState() {
    super.initState();
    Debug.info("SabinaApp: inicialitzant");
    
    // Registrar observer per als canvis del sistema
    WidgetsBinding.instance.addObserver(this);
    
    // Inicialitzar idioma
    L.deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
    
    // Subscriure's als events
    _subcEvent = EventBus.s.listen(_handleEvent);
  }
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    EventBus.s.cancel(_subcEvent);
    super.dispose();
  }
  
  /// Gestiona els events rebuts
  void _handleEvent(LdEvent event) {
    Debug.info("SabinaApp: Rebut esdeveniment ${event.eType.name}");
  
    // Gestionar canvi de tema
    if (event.eType == EventType.themeChanged) {
      setState(() {
        _themeMode = ThemeService.s.themeMode;
        Debug.info("SabinaApp: Actualitzant tema a $_themeMode");
      });
    }
    
    // Gestionar canvi d'idioma o reconstrucció global
    if (event.eType == EventType.languageChanged || event.eType == EventType.rebuildUI) {
      setState(() {
        _languageChanged = true;
        Debug.info("SabinaApp: Reconstruint l'aplicació per canvi d'${event.eType == EventType.languageChanged ? 'idioma' : 'event global'}");
      });
    }
  }
  
  /// Gestiona els canvis en l'estat del cicle de vida de l'aplicació
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    Debug.info("SabinaApp: Canvi d'estat del cicle de vida: $state");
    
    EventBus.s.emit(LdEvent(
      eType: EventType.applicationStateChanged,
      srcTag: widget.tag,
      eData: {
        mfLifecycleState: state.toString(),
      },
    ));
  }
  
  @override
  Widget build(BuildContext pBCtx) {
    Debug.info("SabinaApp: Construint aplicació. Tema: $_themeMode, Idioma canviat: $_languageChanged");
    
    return ScreenUtilInit(
      designSize: designSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        // Ara ScreenUtil ja està preparat
        _themeMode = ThemeService.s.themeMode;

        final app = MaterialApp(
          title: L.sSabina.tx, // Asegurarnos de que siempre use la función tx
          debugShowCheckedModeBanner: false,
          theme: ThemeService.s.lightTheme,
          darkTheme: ThemeService.s.darkTheme,
          themeMode: _themeMode,
          home: child ?? TestPage(),
        );
        
        // Reiniciamos el flag después de construir la UI
        if (_languageChanged) {
          // Usar un post-frame callback para asegurar que el flag se reinicie después de la reconstrucción
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _languageChanged = false;
              Debug.info("SabinaApp: Flag de canvi d'idioma reiniciat després de la reconstrucció");
            });
          });
        }
        
        return app;
      }
    );
  }
}