// ld_stream_listener_mixin.dart
// Oïdor de sobres d'un emissor d'stream.
// CreatedAt: 2025/02/20 dg. JIQ

import 'dart:async';

import 'package:ld_wbench5/03_core/interfaces/ld_disposable_intf.dart';
import 'package:ld_wbench5/03_core/interfaces/ld_stream_listener_intf.dart';
import 'package:ld_wbench5/03_core/mixins/stream_emitter_mixin.dart';
import 'package:ld_wbench5/10_tools/ld_map.dart';

/// Receptor d'events des de diversos streams.
/// Mixin per a classes que volen subscriure's a streams i gestionar les subscripcions.
mixin StreamReceiverMixin
implements LdDisposableIntf {
  // 🧩 MEMBRES ------------------------
  /// Mapa de totes les subscripcions actives.
  final LdMap<LdStreamListenerAbs> _lstns = LdMap<LdStreamListenerAbs>.empty();

  // ⚙️ DISPOSE -----------------------
  /// 📍 'LdDisposableIntf': Allibera tots els recursos.
  @override
  void dispose() {
    // Cancel·lar les subscripcions.
    _lstns.forEach((String pKey,LdStreamListenerAbs pSub) {
      pSub.emtTheme.unsubscribe(pSub);
    });
    _lstns.clear();
  }

  // ⚙️ SUBSCRIPCIÓ/DESUBSCRIPCIÓ -----
  /// Subscriu's a un stream evitant subscripcions duplicades al mateix stream.
  /// Torna la subscripció per si es vol gestionar externament.
  StreamSubscription subscribeToEmitter(
    StreamEmitterMixin pCtrl, 
    LdStreamListenerAbs pLstn) {
      if (_lstns.containsKey(pLstn.keyTag)) {
        _lstns[pLstn.keyTag]!.sub.cancel();
        unsubscribeFromEmitter(_lstns[pLstn.keyTag]!);
      }
    pLstn.sub = pCtrl.subscribe(pLstn);
    _lstns[pLstn.keyTag] = pLstn;
    return pLstn.sub;
  }

  /// Cancel·la una subscripció específica.
  void unsubscribeFromEmitter(LdStreamListenerAbs pLstn) {
    pLstn.emtTheme.unsubscribe(pLstn);
    _lstns.remove(pLstn.keyTag);
  }

  /// Cancel·la totes les subscripcions.
  void cancelAllSubscriptions() {
    for (LdStreamListenerAbs lstn in _lstns.values) {
      lstn.sub.cancel();
      unsubscribeFromEmitter(lstn);
    }
    _lstns.clear();
  }

  /// S'ha de cridar quan l'objecte s'allibera.
  void disposeSubscriptions() => cancelAllSubscriptions();
}
