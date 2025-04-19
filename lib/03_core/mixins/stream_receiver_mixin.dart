// ld_stream_listener_mixin.dart
// Oïdor de sobres d'un emissor d'stream.
// CreatedAt: 2025/02/11 ds. JIQ


import 'dart:async';

import '../ld_model.dart';
import '../streams/stream_envelope.dart';

/// Oïdor de sobres d'un emissor d'stream.
mixin StreamReceiverMixin<E extends StreamEnvelope<M>, M extends LdModel> {
  // 🧩 MEMBRES ------------------------
  late final StreamSubscription<E>? sLstn;

  // ⚙️📍 FUNCIONALITAT ABSTRACTA ------
  /// Recepció d'un sobre a través de l'oïdor de l'stream.
  void listened(E pEnv);

  /// Gestió dels errors produïts en el transcurs del funcionament de l'Stream.
  void onError(Object pError, StackTrace pSTrace);
  
  /// Crec que s'executa un cop s'ha produït l'execució de 'listened(E pEnv)'.
  void onDone();
}