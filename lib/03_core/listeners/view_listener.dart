// view_listener.dart
// Simplificació per a la gestió d'events associats a una vista..
// CreatedAt: 2025/04/24 dj. JIQ

import 'package:ld_wbench5/03_core/event/view/view_event.dart';
import 'package:ld_wbench5/03_core/streams/import.dart';
import 'package:ld_wbench5/08_theme/ld_theme_serv.dart';
import 'package:ld_wbench5/09_intl/L.dart';

/// Interfície d'especialització en escoltar events associats a una vista..
abstract class ViewListenerIntf {
  /// Gestió dels events de l'Stream del gestor d'idiomes.
  void listenViewEvent(ViewEvent pEnv);

  /// Gestió dels errors a l'Stream del gestor d'idiomes.
  void onViewStreamError(Object pError, StackTrace pTrace);

  /// Gestió ??? a l'Stream de l'aplicació.
  void onViewStreamDone();
}

// Simplificació per a la gestió d'events associats a una vista..
class ViewStreamListener
extends LdStreamListenerAbs {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "ViewStreamListener";
  
  // 🧩 MEMBRES ------------------------
  final ViewListenerIntf _lstn;

  // 🛠️ CONSTRUCTORS/CLEANERS --------- 
  ViewStreamListener({
    super.keyTag = "ViewStreamListener",
    required ViewListenerIntf pLstn })
  : _lstn = pLstn
  { emtTheme = LdThemeServ.single;
    sub = emtTheme.subscribe(this);
  }

  /// 📍 'LdStreamListenerIntf:LdDisposableIntf': Allibera els recursos i les subscripcions.
  @override void dispose() {
    emtTheme.unsubscribe(this);
    super.dispose();
  }

  /// 📍 'LdStreamListenerIntf: Processa els events de la vista que arribin per l'Stream.
  @override
  void listenStream(ViewEvent pEnv) => _lstn.listenViewEvent(pEnv);

  /// 📍 'LdStreamListenerIntf:  ???
  @override
  void onStreamDone() => _lstn.onViewStreamDone();

  /// 📍 'LdStreamListenerIntf: Processa els errors provocats per l'Stream dels idiomes.
  @override
  void onStreamError(Object pError, StackTrace pSTrace) => _lstn.onViewStreamError(pError, pSTrace);
  
  @override bool? get cancelOnErrorStream => true;
  
  @override
  String get keyTag => className;
  
  /// 'LdTagMixin': Retorna el tag base per a utilitzar quan no se n'ofereix un concret.
  @override String baseTag() => className;
}

