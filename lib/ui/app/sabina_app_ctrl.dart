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
  SabinaApp get app => _app.get()!;

  /// Estableix la referència a la instància de l'aplicació.
  set app(SabinaApp pPage) => _app.set(pPage);

  /// Subscripció als events
  StreamSubscription<LdEvent>? _subcEvent;
  
  /// Mode del tema actual
  ThemeMode _themeMode = ThemeMode.system;
  
  // CLA_1: /// Indicador de reconstrucció per canvi d'idioma
  // CLA_1: bool _languageChanged = false;
  
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
  
  void _handleEvent(LdEvent event) {
    Debug.info("SabinaApp: Received event ${event.eType.name}");

    if (event.eType == EventType.languageChanged || 
        event.eType == EventType.themeChanged || 
        event.eType == EventType.rebuildUI) {
        
      // Per als canvis de tema, actualitzem el themeMode
      if (event.eType == EventType.themeChanged) {
        _themeMode = ThemeService.s.themeMode;
      }

      // Una sola crida a setState per a tots els tipus d'events que requereixen reconstrucció
      setState(() {
        Debug.info("SabinaApp: Rebuilding app due to ${event.eType.name}");
      });
    }
  }

  // CLA_1: Gestiona els events rebuts
  // CLA_1: void _handleEvent(LdEvent event) {
  // CLA_1:   Debug.info("SabinaApp: Received event ${event.eType.name}");
  // CLA_1:  
  // CLA_1:   if (event.eType == EventType.languageChanged || event.eType == EventType.rebuildUI) {
  // CLA_1:     Debug.info("SabinaApp: Rebuilding app due to ${event.eType == EventType.languageChanged ? 'language change' : 'global event'}");
  // CLA_1:     setState(() {
  // CLA_1:       //  No need for the complex flag mechanism
  // CLA_1:     });
  // CLA_1:   }
  // CLA_1:    
  // CLA_1:   // Handle theme changes as before
  // CLA_1:   if (event.eType == EventType.themeChanged) {
  // CLA_1:     setState(() {
  // CLA_1:       _themeMode = ThemeService.s.themeMode;
  // CLA_1:       Debug.info("SabinaApp: Updating theme to $_themeMode");
  // CLA_1:     });
  // CLA_1:   }
  // CLA_1: }

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
    Debug.info("SabinaApp: Construint aplicació. Tema: $_themeMode");
    
    return ScreenUtilInit(
      designSize: designSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        // Ara ScreenUtil ja està preparat
        _themeMode = ThemeService.s.themeMode;
  
        final app = MaterialApp(
          title: L.tx(L.sSabina),
          debugShowCheckedModeBanner: false,
          theme: ThemeService.s.lightTheme,
          darkTheme: ThemeService.s.darkTheme,
          themeMode: _themeMode,
          home: TestPage(pTitleKey: L.sAppSabina, pSubTitleKey: L.sWelcome),
        );
        
        return app;
      }
    );
  }
  
  // CLA_1: @override
  // CLA_1: Widget build(BuildContext pBCtx) {
  // CLA_1:   Debug.info("SabinaApp: Construint aplicació. Tema: $_themeMode, Idioma canviat: $_languageChanged");
  // CLA_1: 
  // CLA_1:   return ScreenUtilInit(
  // CLA_1:     designSize: designSize,
  // CLA_1:     minTextAdapt: true,
  // CLA_1:     splitScreenMode: true,
  // CLA_1:     builder: (context, child) {
  // CLA_1:       // Ara ScreenUtil ja està preparat
  // CLA_1:       _themeMode = ThemeService.s.themeMode;
  // CLA_1: 
  // CLA_1:       final app = MaterialApp(
  // CLA_1:         title: L.sSabina, // Utilitzem la funció tx per a totes les traduccions
  // CLA_1:         debugShowCheckedModeBanner: false,
  // CLA_1:         theme: ThemeService.s.lightTheme,
  // CLA_1:         darkTheme: ThemeService.s.darkTheme,
  // CLA_1:         themeMode: _themeMode,
  // CLA_1:         home: TestPage(pTitleKey: L.sAppSabina, pSubTitleKey: L.sWelcome), // JAB_Q: child ?? 
  // CLA_1:       );
  // CLA_1:    
  // CLA_1:       // Reiniciar el flag només després que hagi passat un temps adequat
  // CLA_1:       if (_languageChanged) {
  // CLA_1:         // Incrementar el delay per assegurar que la UI es reconstrueix completament
  // CLA_1:         WidgetsBinding.instance.addPostFrameCallback((_) {
  // CLA_1:           // Utilitzar un timer per donar més temps
  // CLA_1:           Future.delayed(const Duration(milliseconds: 500), () {
  // CLA_1:             if (mounted) {
  // CLA_1:               setState(() {
  // CLA_1:                 _languageChanged = false;
  // CLA_1:                 Debug.info("SabinaApp: Flag de canvi d'idioma reiniciat després de la reconstrucció");
  // CLA_1:               });
  // CLA_1:             }
  // CLA_1:           });
  // CLA_1:         });
  // CLA_1:       }
  // CLA_1:    
  // CLA_1:       return app;
  // CLA_1:     }
  // CLA_1:   );
  // CLA_1: }
}