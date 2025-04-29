// event_system.dart
// Sistema d'events simplificat
// Created: 2025/04/29

import 'dart:async';
import 'package:ld_wbench5/utils/debug.dart';
import 'package:ld_wbench5/utils/full_set.dart';

/// Tipus d'events de l'aplicació
enum EventType {
  /// Canvi en el tema de l'aplicació
  themeChanged,
  /// Canvi en l'idioma de l'aplicació
  languageChanged,
  /// Canvi en l'estat de l'aplicació (primer pla, fons, etc.)
  applicationStateChanged,
  /// Reconstrucció de la UI
  rebuildUI,
  /// Events personalitzats
  custom,
}

/// Event bàsic de l'aplicació
class LdEvent {
  /// Tipus d'event
  final EventType type;
  
  /// Dades associades a l'event
  final Map<String, dynamic> data;
  
  /// Tag de l'emissor de l'event
  final String? srcTag;
  
  /// Tags dels objectius de l'event (si és buit, l'event és per a tothom)
  final List<String>? tgtTags;
  
  /// Cert només quan l'event es dóna per consumit.
  final FullSet<bool> _consumed = FullSet<bool>(pInst: false);
  /// Cert només quan l'event es dóna per consumit.
  bool get isConsumed => _consumed.get()!;
  /// Estableix si l'event està consumit o no ho està.
  set isConsumed(bool pCons) => _consumed.set(pCons);

  /// Crea un nou event
  LdEvent({
    required this.type,
    this.data = const {},
    this.srcTag,
    this.tgtTags,
  });
  
  /// Comprova si aquest event està dirigit a un tag específic
  bool isTargetedAt(String tag) => 
    tgtTags == null || tgtTags!.isEmpty || tgtTags!.contains(tag);
    
  @override
  String toString() {
    return 'SabinaEvent(type: $type, source: $srcTag, targets: $tgtTags, data: $data)';
  }
}

/// Gestor centralitzat d'events de l'aplicació
class EventBus {
  /// Singleton
  static final EventBus _instance = EventBus._();
  
  /// Factory que retorna la instància singleton
  factory EventBus() => _instance;
  
  /// Constructor privat
  EventBus._();
  
  /// Stream controller per a emetre events
  final _controller = StreamController<LdEvent>.broadcast();
  
  /// Stream d'events
  Stream<LdEvent> get events => _controller.stream;
  
  /// Emet un event a tots els subscriptors
  void emit(LdEvent event) {
    if (!_controller.isClosed) {
      Debug.info("EventBus: Emetent event de tipus ${event.type}");
      _controller.add(event);
    }
  }
  
  /// Tanca el stream controller
  void dispose() {
    Debug.info("EventBus: Alliberant recursos");
    _controller.close();
  }
}