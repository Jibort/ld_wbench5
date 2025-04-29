// ld_stream_listener_intf.dart
// Interfície per a la recepció d'events dels streams.
// CreateAt: 2025/04/20 dg. JIQ

import 'dart:async';

import 'package:ld_wbench5/03_core/interfaces/ld_disposable_intf.dart';
import 'package:ld_wbench5/03_core/ld_bindings.dart';
import 'package:ld_wbench5/03_core/mixins/stream_emitter_mixin.dart';
import 'package:ld_wbench5/03_core/event/stream/stream_event.dart';
import 'package:ld_wbench5/03_core/tag/ld_tag_mixin.dart';
import 'package:ld_wbench5/10_tools/once_set.dart';

/// Interfície per a la recepció d'events dels streams.
abstract   class LdStreamListenerAbs
with       LdTagMixin
implements LdDisposableIntf {
  // 🧩 MEMBRES ------------------------
  final String keyTag;
  final OnceSet<StreamEmitterMixin> _emitter = OnceSet<StreamEmitterMixin>();
  final OnceSet<StreamSubscription> _sub     = OnceSet<StreamSubscription>();

  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  /// Constructor de la interfície d'oïdor d'streams.
  LdStreamListenerAbs({ this.keyTag = "lstn" }) {
    registerTag(pTag: keyTag, pInst: this);
  }

  @override void dispose() {
    LdBindings.remove(keyTag);
    super.dispose();
  }

  // 🪟 GETTERS I SETTERS --------------
  StreamSubscription get sub       => _sub.get();
  set sub(StreamSubscription pSub) => _sub.set(pSub);

  StreamEmitterMixin get emtTheme        => _emitter.get();
  set emtTheme(StreamEmitterMixin pCtrl) => _emitter.set(pCtrl);

  // ⚙️📍 FUNCIONALITAT SUBSCRIPCIÓ ----
  /// 📍 'LdStreamListenerIntf': Escolta les dades que rep dels streams en sobres.
  void listenStream(covariant StreamEvent pEnv);

  /// 📍 'LdStreamListenerIntf': Resposta a una possible situació d'error en la gestió dels streams.
  void onStreamError(Object pError, StackTrace pTrace);

  /// 📍 'LdStreamListenerIntf': Resposta al tancament de l'Stream???.
  void onStreamDone();

  /// 📍 'LdStreamListenerIntf': Retorna cert només si en cas d'error en els Streams s'han de cancel·lar.
  bool? get cancelOnErrorStream => true;
}
