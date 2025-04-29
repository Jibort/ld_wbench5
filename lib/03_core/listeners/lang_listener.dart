// lang_listener.dart
// Simplificació per a la gestió d'events associats a les vistes.
// CreatedAt: 2025/04/26 ds. JIQ

import 'package:ld_wbench5/03_core/streams/import.dart';
import 'package:ld_wbench5/09_intl/L.dart';

/// Interfície d'especialització en escoltar events associats als idiomes.
abstract class LangListenerIntf {
  /// Gestió dels events de l'Stream del gestor d'idiomes.
  void listenLangEvent(LangEvent pEnv);

  /// Gestió dels errors a l'Stream del gestor d'idiomes.
  void onLangStreamError(Object pError, StackTrace pTrace);

  /// Gestió ??? a l'Stream del gestor d'idiomes.
  void onLangStreamDone();
}

// Simplificació per a la gestió d'events associats als idiomes.
class LangStreamListener
extends LdStreamListenerAbs {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "LangStreamListener";
  
  // 🧩 MEMBRES ------------------------
  final LangListenerIntf _lstn;

  // 🛠️ CONSTRUCTORS/CLEANERS --------- 
  LangStreamListener({
    super.keyTag = "LangStreamListener",
    required LangListenerIntf pLstn })
  : _lstn = pLstn
  { emtTheme = L.single;
    sub = emtTheme.subscribe(this);
  }

  // 📍 'LdStreamListenerIntf:LdDisposableIntf': Allibera els recursos i les subscripcions.
  @override void dispose() {
    emtTheme.unsubscribe(this);
    super.dispose();
  }

  /// 📍 'LdStreamListenerIntf: Processa els events d'idiomes que arribin per l'Stream.
  @override
  void listenStream(LangEvent pEnv) => _lstn.listenLangEvent(pEnv);

  /// 📍 'LdStreamListenerIntf:  ???
  @override
  void onStreamDone() => _lstn.onLangStreamDone();

  /// 📍 'LdStreamListenerIntf: Processa els errors provocats per l'Stream dels idiomes.
  @override
  void onStreamError(Object pError, StackTrace pSTrace) => _lstn.onLangStreamError(pError, pSTrace);
  
  @override bool? get cancelOnErrorStream => true;
  
  @override
  String get keyTag => className;
  
  /// 'LdTagMixin': Retorna el tag base per a utilitzar quan no se n'ofereix un concret.
  @override String baseTag() => className;
}

