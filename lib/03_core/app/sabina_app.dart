// ld_app.dart
// Generalització del widget principal de l'aplicació.
// CreatedAt: 2025/04/08 dt. JIQ

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:ld_wbench5/03_core/app/sabina_app_state.dart';
import 'package:ld_wbench5/03_core/event/app/app_event_model.dart';
import 'package:ld_wbench5/03_core/event/intl/lang_changed_event.dart';
import 'package:ld_wbench5/03_core/event/theme/theme_event.dart';
import 'package:ld_wbench5/03_core/listeners/lang_listener.dart';
import 'package:ld_wbench5/03_core/streams/import.dart';
import 'package:ld_wbench5/03_core/event/theme/theme_event_model.dart';
import 'package:ld_wbench5/03_core/listeners/theme_listener.dart';
import 'package:ld_wbench5/03_core/tag/ld_tag_mixin.dart';
import 'package:ld_wbench5/09_intl/L.dart';
import 'package:ld_wbench5/10_tools/debug.dart';
import 'package:ld_wbench5/10_tools/once_set.dart';

/// Generalització del widget principal de l'aplicació.
class      SabinaApp
extends    StatefulWidget
with       LdTagMixin,
           WidgetsBindingObserver,
           StreamEmitterMixin,
           StreamReceiverMixin
implements ThemeListenerIntf,
           LangListenerIntf {
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
  final OnceSet<ThemeStreamListener> _lstnTheme = OnceSet<ThemeStreamListener>();
  final OnceSet<LangStreamListener>  _lstnLang  = OnceSet<LangStreamListener>();

  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  /// Constructor fosc i unic de l'aplicació.
  SabinaApp._() { 
    WidgetsFlutterBinding.ensureInitialized();
    L.devLocale = WidgetsBinding.instance.platformDispatcher.locale;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _lstnTheme.set(ThemeStreamListener(pLstn: this));
      _lstnLang.set(LangStreamListener(pLstn: this));
    });
  }

  /// Alliberem les subscripcions
  @override void dispose() {
    _lstnTheme.get().emtTheme.unsubscribe(_lstnTheme.get());
    _lstnLang.get().emtTheme.unsubscribe(_lstnLang.get());
    super.dispose();
  }

  // ♻️📍 'WidgetsBindingObserver' ==================================================
  @override void didChangeMetrics() {
    send(
      AppEventModel.envelope(
        pSrc:   tag,
        pModel: AppEventModel(
          pEType: AppEventTypeEnum.changeMetrics,
        ),
      )
    );
  }
  
  @override void didChangeTextScaleFactor() {
    send(
      AppEventModel.envelope(
        pSrc:   tag,
        pModel: AppEventModel(
          pEType: AppEventTypeEnum.changeTextScaleFactor,
        ),
      )
    );
  }

  @override void didChangeAppLifecycleState(AppLifecycleState pState) {
    send(
      AppEventModel.envelope(
        pSrc:   tag,
        pModel: AppEventModel(
          pEType: AppEventTypeEnum.changeAppLifecycleState,
        ),
      )
    );
  }

  @override Future<AppExitResponse> didRequestAppExit() async {
    Debug.info("SabinaApp.didRequestAppExit(): El sistema demana acabar l'execució de 'SabinaApp'!");  
    return AppExitResponse.exit;
  }

  @override void didHaveMemoryPressure() {
    Debug.info("SabinaApp.didHaveMemoryPressure(): Escassos de memòria!");  

  }
  // ♻️📍 'ThemeListenerIntf' ==================================================
  // 📍 'ThemeListenerIntf': Oïdor d'events provinents de l'Stream de 'LdTheme'.
  @override void listenThemeEvent(ThemeEvent pEvent) {
    Debug.info("SabinaApp.listenThemeEvent(event): Executant...");  
    if (pEvent.hasModel) {
      switch (pEvent.model) {
        case ThemeEventModel _:
          send(pEvent);
          break;
        // default:
        // String msg = "${L.sAppSabina}.listenThemeEvent(event): Tipus d'event no admés '${pEvent.instClassName}";
        // Debug.fatal(msg, Exception(msg));
      } 
    } else {
      switch (pEvent) {
        case RebuildEvent re:
          send(re);
          break;
        default:
          String msg = "${L.sAppSabina}.listenThemeEvent(event): Tipus d'event no admés '${pEvent.instClassName}";
          Debug.fatal(msg, Exception(msg));
      }
    }
    Debug.info("SabinaApp.listenThemeEvent(event): ...Executat");  
  }
  
  // 📍 'ThemeListenerIntf': ???
  @override void onThemeStreamDone() => Debug.info("SabinaApp.onThemeStreamDone(): Executat!");

  /// 📍 'ThemeListenerIntf': Processa els errors provocats pel gestor del Tema Visual.
  @override void onThemeStreamError(Object pError, StackTrace pSTrace) {
    String msg = "Error: ${pError.toString()}\nTrace: ${pSTrace.toString()}";
    Debug.fatal("SabinaApp.onThemeStreamError(...): $msg", Exception(msg));
  }
  
  // ♻️📍 'LangListenerIntf' ===================================================
  // 📍 'ThemeListenerIntf': Oïdor d'events provinents de l'Stream del gestor d'idiomes.
  @override void listenLangEvent(LangEvent pEvent) {
    Debug.info("SabinaApp.listenLangEvent(event): Executant...");
    if (pEvent.hasModel) {
      switch (pEvent.model) {
        case LangEventModel _:
          send(pEvent);
          break;
        default:
          String msg = "${L.sAppSabina}.listenThemeEvent(event): Tipus d'event no admés '${pEvent.instClassName}";
          Debug.fatal(msg, Exception(msg));
      } 
    } else {
      switch (pEvent) {
        case LangChangedEvent lce:
          send(lce);
          break;
        default:
          String msg = "${L.sAppSabina}.listenThemeEvent(event): Tipus d'event no admés '${pEvent.instClassName}";
          Debug.fatal(msg, Exception(msg));
      }
    }
    Debug.info("SabinaApp.listenLangEvent(event): ...Executat");
  }
  
  // 📍 'LangListenerIntf': ???
  @override void onLangStreamDone() => Debug.info("SabinaApp.onLangStreamDone(): Executat!");

  /// 📍 'LangListenerIntf': Processa els errors provocats pel gestor d'idiomes.
  @override void onLangStreamError(Object pError, StackTrace pSTrace) {
    String msg = "Error: ${pError.toString()}\nTrace: ${pSTrace.toString()}";
    Debug.fatal("SabinaApp.onLangStreamError(...): $msg", Exception(msg));
   }
  
  /// 📍 'LdMixinTag': Retorna el tag base per a utilitzar quan no se n'ofereix un concret.
  @override String baseTag() => className;

  /// 📍 'StatefulWidget': Retorna l'state del widget.
  @override
  State<StatefulWidget> createState() => SabinaAppState();
}
