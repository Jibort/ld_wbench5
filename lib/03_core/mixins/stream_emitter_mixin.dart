// stream_emitter_mixin.dart
// Administrador d'un stream pels seus oïdors.
// CreatedAt: 2025/08/12 ds. JIQ

import 'dart:async';

import 'package:ld_wbench5/03_core/streams/stream_envelope.dart';

import '../ld_model.dart';

/// Administrador d'un stream pels seus oïdors.
mixin StreamEmitterMixin<E extends StreamEnvelope<M>, M extends LdModel> {
  // 🧩 MEMBRES ------------------------
  final StreamController<E> _sCtrl = StreamController<E>.broadcast();
  bool _isPaused = false;

  // 🪟 GETTERS I SETTERS --------------
  Stream<E>? get stream   => !isClosed ? _sCtrl.stream: null;
  bool       get isPaused => isClosed || _isPaused;
  bool       get isClosed => _sCtrl.isClosed;

  // ♻️ CLICLE DE VIDA ----------------
  /// Impedeix temporalment que s'afegeixin sobres a l'stream.
  void pauseStream() => _isPaused = !isClosed ? true: _isPaused;

  /// Torna a permete afegir sobres a l'stream.
  void unPaunseStream() => _isPaused = false;

  /// Tanca definitivament l'stream.
  void closeStream() => _sCtrl.close();

  // ⚙️ FUNCIONALITAT -----------------
  /// Subscriu un oidor a l'stream associat al controlador.
  StreamSubscription<E>? subscribe({
    required void Function(E) pLstn,
    Function? pOnError,
    void Function()? pOnDone,
    bool? cancelOnError })
    => (stream != null)
      ? stream!.listen(
          pLstn,
          onError: pOnError,
          onDone: pOnDone, 
          cancelOnError: cancelOnError
        )
      : null;

  /// Dessubscriu un oidor de l'stream associat al controlador.
  void unsubscribe(StreamSubscription<E>? pLstn) =>
    (pLstn != null)? pLstn.cancel(): {};

  /// Envia un sobre per l'stream.
  bool send(E pEnvelope) {
    if (isPaused || isClosed) return false;
    _sCtrl.add(pEnvelope);
    return true;
  }
}
