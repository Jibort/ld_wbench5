// app_listener.dart
// Simplificació per a la gestió d'events associats a la gestió de l'aplicació.
// CreatedAt: 2025/04/24 dj. JIQ

import 'package:ld_wbench5/03_core/app/sabina_app.dart';
import 'package:ld_wbench5/03_core/event/app/app_event.dart';
import 'package:ld_wbench5/03_core/streams/import.dart';

/// Interfície d'especialització en escoltar events associats als idiomes.
abstract class AppListenerIntf {
  /// Gestió dels events de l'Stream del gestor d'idiomes.
  void listenAppEvent(AppEvent pEnv);

  /// Gestió dels errors a l'Stream del gestor d'idiomes.
  void onAppStreamError(Object pError, StackTrace pTrace);

  /// Gestió ??? a l'Stream de l'aplicació.
  void onAppStreamDone();
}

// Simplificació per a la gestió d'events associats a la gestión de l'aplicació.
class AppStreamListener
extends LdStreamListenerAbs {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "AppStreamListener";
  
  // 🧩 MEMBRES ------------------------
  final AppListenerIntf _lstn;

  // 🛠️ CONSTRUCTORS/CLEANERS --------- 
  AppStreamListener({
    super.keyTag = "AppStreamListener",
    required AppListenerIntf pLstn })
  : _lstn = pLstn
  { emtTheme = SabinaApp.inst;
    sub = emtTheme.subscribe(this);
  }

  // 📍 'LdStreamListenerIntf:LdDisposableIntf': Allibera els recursos i les subscripcions.
  @override void dispose() {
    emtTheme.unsubscribe(this);
    super.dispose();
  }

  /// 📍 'LdStreamListenerIntf: Processa els events d'idiomes que arribin per l'Stream.
  @override
  void listenStream(AppEvent pEnv) => _lstn.listenAppEvent(pEnv);

  /// 📍 'LdStreamListenerIntf:  ???
  @override
  void onStreamDone() => _lstn.onAppStreamDone();

  /// 📍 'LdStreamListenerIntf: Processa els errors provocats per l'Stream dels idiomes.
  @override
  void onStreamError(Object pError, StackTrace pSTrace) => _lstn.onAppStreamError(pError, pSTrace);
  
  @override bool? get cancelOnErrorStream => true;
  
  @override
  String get keyTag => className;
  
  /// 'LdTagMixin': Retorna el tag base per a utilitzar quan no se n'ofereix un concret.
  @override String baseTag() => className;
}

