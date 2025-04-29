// theme_listener.dart
// Simplificació per a la gestió d'events associats al Tema Visual.
// CreatedAt: 2025/04/24 dj. JIQ

import 'package:ld_wbench5/03_core/event/theme/theme_event.dart';
import 'package:ld_wbench5/03_core/interfaces/ld_stream_listener_intf.dart';
import 'package:ld_wbench5/08_theme/ld_theme_serv.dart';

/// Interficie d'integració de l'oïdor dins una classe.
abstract class ThemeListenerIntf {
  /// Gestió dels events de l'Stream del gestor d'idiomes.
  void listenThemeEvent(ThemeEvent pEnv);

  /// Gestió dels errors a l'Stream del gestor d'idiomes.
  void onThemeStreamError(Object pError, StackTrace pTrace);

  /// Gestió ??? a l'Stream de l'aplicació.
  void onThemeStreamDone();
}

/// Simplificació per a la gestió d'events associats al Tema Visual.
/// Oïdor dels events d'Stream del Tema Visual.
class ThemeStreamListener
extends LdStreamListenerAbs {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "ThemeStreamListener";
  
  // 🧩 MEMBRES ------------------------
  final ThemeListenerIntf _lstn;

  // 🛠️ CONSTRUCTORS/CLEANERS --------- 
  ThemeStreamListener({
    super.keyTag = "_ThemeLstn",
    required ThemeListenerIntf pLstn })
  : _lstn = pLstn
  { emtTheme = LdThemeServ.single;
    sub = emtTheme.subscribe(this);
  }

  // 📍 'LdStreamListenerIntf:LdDisposableIntf': Allibera els recursos i les subscripcions.
  @override void dispose() {
    emtTheme.unsubscribe(this);
    super.dispose();
  }

  /// 📍 'LdStreamListenerIntf: Processa els events d'aplicació que arribin per l'Stream.
  @override
  void listenStream(ThemeEvent pEnv) => _lstn.listenThemeEvent(pEnv);

  /// 📍 'LdStreamListenerIntf: ???
  @override
  void onStreamDone() => _lstn.onThemeStreamDone();

  /// 📍 'LdStreamListenerIntf: Processa els errors provocats pel gestor del Tema Visual.
  @override
  void onStreamError(Object pError, StackTrace pSTrace) => _lstn.onThemeStreamError(pError, pSTrace);
  
  @override bool? get cancelOnErrorStream => true;
  
  @override String get keyTag => className;
  
  /// 📍 'LdTagMixin': Retorna el tag base per a utilitzar quan no se n'ofereix un concret.
  @override String baseTag() => className;
}

