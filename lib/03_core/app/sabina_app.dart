// ld_app.dart
// Generalització del widget principal de l'aplicació.
// CreatedAt: 2025/04/08 dt. JIQ

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ld_wbench5/01_pages/ui_consts.dart';
import 'package:ld_wbench5/03_core/mixins/stream_receiver_mixin.dart';
import 'package:ld_wbench5/03_core/streams/events/rebuild_event.dart';
import 'package:ld_wbench5/08_theme/events/theme_model.dart';
import 'package:ld_wbench5/08_theme/ld_theme.dart';
import 'package:ld_wbench5/09_intl/events/lang_changed_event.dart';
import 'package:ld_wbench5/10_tools/debug.dart';

import 'package:ld_wbench5/routes.dart';
import 'package:ld_wbench5/03_core/ld_model.dart';
import 'package:ld_wbench5/03_core/mixins/stream_emitter_mixin.dart';
import 'package:ld_wbench5/03_core/streams/stream_envelope.dart';
import 'package:ld_wbench5/09_intl/L.dart';

/// Generalització del widget principal de l'aplicació.
class   SabinaApp
extends StatelessWidget
with    StreamEmitterMixin<StreamEnvelope<LdModel>, LdModel>,
        StreamReceiverMixin<StreamEnvelope<LdModel>, LdModel> {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "SabinaApp";
  static SabinaApp? _inst;

  // 📐 FUNCIONALITAT ESTÀTICA ---------
  /// Retorna la instància singleton del widget aplicació.
  static SabinaApp get inst {  
  _inst ??= SabinaApp._();
    return _inst!;
  }

  // 🧩 MEMBRES ------------------------
  StreamSubscription<StreamEnvelope<LdModel>>? _subsTheme;
  StreamSubscription<StreamEnvelope<LdModel>>? _subsLang;


  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  /// Constructor fosc i unic de l'aplicació.
  SabinaApp._() {
    WidgetsFlutterBinding.ensureInitialized();
    L.devLocale = WidgetsBinding.instance.platformDispatcher.locale;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _subsTheme = LdTheme.single.subscribe(pLstn: listened, pOnDone: onDone, pOnError: onError);
      _subsLang  = L.single.subscribe(pLstn: listened, pOnDone: onDone, pOnError: onError);

    });
  }

  /// Alliberem la subscripció
  void dispose() {
    LdTheme.single.unsubscribe(_subsTheme);
    L.single.unsubscribe(_subsLang);
  }

  // ♻️ CLICLE DE VIDA ----------------
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
  
  @override
  void listened(StreamEnvelope<LdModel> pEnv) {
    Debug.info("SabinaApp.listened(...): Executant...");  
    if (pEnv.hasModel) {
      switch (pEnv.model) {
      case ThemeEventModel _:
      case LangChangedEvent _:
        send(pEnv);
        break;
      } 
    } else {
      switch (pEnv) {
      case RebuildEvent re:
        send(re);
        break;
      case LangChangedEvent re:
        send(re);
        break;
      }
    }
    Debug.info("SabinaApp.listened(...): ...Executat");  
  }
  
  @override
  void onDone() {
    Debug.info("SabinaApp.onDone(): Executat!");
  }
  
  @override
  void onError(Object pError, StackTrace pSTrace) {
    String msg = "Error: ${pError.toString()}\nTrace: ${pSTrace.toString()}";
    Debug.fatal("SabinaApp.onError(...): $msg", Exception(msg));
  }
}