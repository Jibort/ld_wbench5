// event_system.dart
// Sistema d'events simplificat
// Created: 2025/04/29 dt. CLA[JIQ]

import 'dart:async';

import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Gestor centralitzat d'events de l'aplicació
class EventBus {
  /// Singleton
  static final EventBus _inst = EventBus._();
  static EventBus get s => _inst;

  /// Factory que retorna la instància singleton
  factory EventBus() => _inst;
  
  /// Constructor privat
  EventBus._();
  
  /// Stream controller per a emetre events
  final _ctrl = StreamController<LdEvent>.broadcast();
  
  /// Stream d'events
  Stream<LdEvent> get events => _ctrl.stream;
  
  /// Retorna un oïdor d'events de l'Streeam.
  StreamSubscription<LdEvent> listen(void Function(LdEvent) pLstner) 
  => events.listen(pLstner);

  /// Desconnecta l'oïdor dels events de l'Stream.ç
  void cancel(StreamSubscription<LdEvent>? pLstn) 
  => pLstn?.cancel();

  /// Emet un event a tots els subscriptors
  void emit(LdEvent event) {
    if (!_ctrl.isClosed) {
      Debug.info("EventBus: Emetent event de tipus ${event.eType}");
      _ctrl.add(event);
    }
  }
  
  /// Tanca el stream controller
  void dispose() {
    Debug.info("EventBus: Alliberant recursos ...");
    _ctrl.close();
    Debug.info("EventBus: ... Recursos alliberats");
  }
}