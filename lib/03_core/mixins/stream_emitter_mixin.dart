// stream_emitter_mixin.dart
// Administrador d'un stream per a un emissor d'events.
// CreatedAt: 2025/08/12 ds. JIQ

import 'dart:async';

import 'package:ld_wbench5/03_core/interfaces/ld_disposable_intf.dart';
import 'package:ld_wbench5/03_core/interfaces/ld_stream_listener_intf.dart';
import 'package:ld_wbench5/03_core/event/stream/stream_event.dart';
import 'package:ld_wbench5/10_tools/ld_map.dart';

/// Administrador d'un stream per a un emissor d'events.
mixin StreamEmitterMixin
implements LdDisposableIntf {
  // 🧩 MEMBRES ------------------------
  /// Controlador d'stream pels diferents tipus d'events.
  final StreamController<StreamEvent> _stCtrl = StreamController<StreamEvent>();
  final LdMap<StreamSubscription<StreamEvent>> _subs = LdMap<StreamSubscription<StreamEvent>>.empty();

  // ⚙️ DISPOSE -----------------------
  /// 📍 'LdDisposableIntf': Allibera tots els recursos.
  @override
  void dispose() {
    // Cancel·lar totes les subscripcions
    for (var sub in _subs.values) {
      sub.cancel();
    }
    _subs.clear();
    _stCtrl.close();
  }

  // 🪟 GETTERS I SETTERS --------------
  StreamController<StreamEvent> get stCtrl => _stCtrl;

  // ⚙️ SUBSCRIPCIÓ/DESUBSCRIPCIÓ -----
  /// Subscriu un oidor a l'stream associat al controlador.
  StreamSubscription<StreamEvent> subscribe(LdStreamListenerAbs pLstn) { 
    StreamSubscription<StreamEvent> sub = stream.listen(
      pLstn.listenStream,
      onError: pLstn.onStreamError,
      onDone:  pLstn.onStreamDone, 
      cancelOnError: pLstn.cancelOnErrorStream
    );
    _subs[pLstn.keyTag] = sub;
    return sub;
  }

  /// Dessubscriu un oidor de l'stream associat al controlador.
  void unsubscribe(LdStreamListenerAbs pLstn) {
    StreamSubscription<StreamEvent>? sub = _subs.remove(pLstn.keyTag);
    sub?.cancel();
  }

  void unsubscribeSubscription(StreamSubscription<StreamEvent> pSub) {
    // TODO: Validar repeticions de funcionalitat.
    pSub.cancel();
  }

  // ⚙️ FUNCIONALITAT -----------------
  /// Retorna la subscripció a amb la clau especificada.
  StreamSubscription<StreamEvent>? getSubscription(String pKey) => _subs[pKey];

  /// Retorna l'stream associat amb el controlador de streams identificat per 'pKey'.
  Stream<StreamEvent> get stream => _stCtrl.stream;

  /// Emet un sobre amb un model a l'stream amb la clau especificada.
  void send(StreamEvent pEnv) {
    if (!_stCtrl.isClosed) {
      _stCtrl.add(pEnv);
    }
  }
}
