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
  
  /// Registres de components per tipus d'event
  final Map<EventType, Set<String>> _componentsByEventType = {};

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
  void emit(LdEvent pEvent) {
    if (!_ctrl.isClosed) {
      Debug.info("EventBus: Emitting event of type ${pEvent.eType} from ${pEvent.srcTag} to targets ${pEvent.tgtTags}");
      _ctrl.add(pEvent);
    }
  }

  /// Emet un event a un component específic o subconjunt de components
  void emitTargeted(LdEvent event, {required List<String> targets}) {
    if (!_ctrl.isClosed) {
      // Assegurar-nos que el event té els targets correctes
      LdEvent targetedEvent = LdEvent(
        eType: event.eType,
        srcTag: event.srcTag,
        eData: event.eData,
        tgtTags: targets,
      );

      Debug.info("EventBus: Emitting targeted event of type ${event.eType} from ${event.srcTag} to targets $targets");
      _ctrl.add(targetedEvent);
    }
  }
  
  /// Registra un component per rebre un tipus específic d'event
  void registerForEvent(String tag, EventType eventType) {
    if (!_componentsByEventType.containsKey(eventType)) {
      _componentsByEventType[eventType] = {};
    }
    _componentsByEventType[eventType]!.add(tag);
    Debug.info("EventBus: Component $tag registrat per rebre events $eventType");
  }

  /// Emet un event als components registrats per aquest tipus d'event
  void emitToRegistered(LdEvent event) {
    if (!_ctrl.isClosed) {
      if (_componentsByEventType.containsKey(event.eType)) {
        List<String> targets = _componentsByEventType[event.eType]!.toList();
        LdEvent targetedEvent = LdEvent(
          eType: event.eType,
          srcTag: event.srcTag,
          eData: event.eData,
          tgtTags: targets,
        );
        
        Debug.info("EventBus: Emitting event of type ${event.eType} to registered components: $targets");
        _ctrl.add(targetedEvent);
      } else {
        // Si no hi ha components registrats, enviar a tothom
        emit(event);
      }
    }
  }
  
  /// Tanca el stream controller
  void dispose() {
    Debug.info("EventBus: Alliberant recursos ...");
    _ctrl.close();
    Debug.info("EventBus: ... Recursos alliberats");
  }
}
