// stream_receiver_widget.dart
// Gestor específic per a Widgets de rececpció de dades a través d'streams.
// CreatedAt: 2025/04/20 dg. CLA[JIQ]

// ignore_for_file: unused_element_parameter

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ld_wbench5/03_core/abstraction/ld_widget_abs.dart';
import 'package:ld_wbench5/03_core/streams/import.dart';
import 'package:ld_wbench5/10_tools/debug.dart';

/// Mixin específic per a Widgets que necessiten rebre events i reconstruir-se.
/// Estén [StreamReceiverMixin] i afegeix funcionalitat específica per a Widgets de Flutter.
mixin StreamReceiverWidgetMixin
on         State<LdWidgetAbs>
implements StreamReceiverMixin {
  // 🧩 MEMBRES ------------------------
  bool _isRebuildScheduled = false;

  void _rebuildSubsriber(StreamEvent pEvt)
  => ((envelope) {
    if (mounted && !_isRebuildScheduled) {
      _isRebuildScheduled = true;
      
      // Utilitzem scheduleMicrotask per diferir el setState
      // Això evita problemes quan s'actualitza mentre ja s'està construint
      scheduleMicrotask(() {
        if (mounted) {
          // El setState pot ser buit perquè només necessitem forçar un rebuild
          setState(() { });
          // Reiniciem la bandera un cop programada l'actualització
          _isRebuildScheduled = false;
        }
      });
    }
  });

  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  @override void dispose() => super.dispose();

  /// Subscriu el widget a un stream que provocarà un rebuild
  /// 
  /// El Stream ha d'emetre objectes de tipus [StreamEvent] amb [RebuildEvent]
  /// Quan es rep un event, s'executa setState per a reconstruir el widget
  void subscribeToRebuild({
    required StreamEmitterMixin pCtrl, 
    required String keyTag, 
    void Function(StreamEvent)? pLstn })
  { final LdStreamListenerAbs lstn 
      = _ListenerToRebuild(keyTag: keyTag, lstn: pLstn ?? _rebuildSubsriber);
    subscribeToEmitter(pCtrl, lstn);
  }
}

class _ListenerToRebuild
extends LdStreamListenerAbs {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "_ListenerToRebuild";
  // Funció estàtica que serveix com a valor per defecte d'OnError.
  static void _onError(Object error, StackTrace stackTrace) {}
  // Funció estàtica que serveix com a valor per defecte d'OnDone.
  static void _onDone() {}

  // 🧩 MEMBRES ------------------------
  final void Function(StreamEvent pEnv) lstn;
  final void Function() onDone;
  final void Function(Object, StackTrace) onError;

  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  _ListenerToRebuild({
    super.keyTag, 
    required this.lstn,
    this.onDone  = _onDone,
    this.onError = _onError,
  });
  
  @override dispose() {
    Debug.info("Alliberant l'oïdor a events 'RebuildEvent'.");
    super.dispose();
  }

  // ⚙️📍 FUNCIONALITAT SUBSCRIPCIÓ ----
  /// 📍 'LdStreamListenerIntf': Escolta les dades que rep dels streams en sobres.
  @override listenStream(StreamEvent pEnv) => lstn(pEnv);

  /// 📍 'LdStreamListenerIntf': Resposta a una possible situació d'error en la gestió dels streams.
  @override onStreamError(Object pError, StackTrace pTrace) => onError(pError, pTrace);

  /// 📍 'LdStreamListenerIntf': Resposta al tancament de l'Stream???.
  @override onStreamDone() => onDone();

  /// 📍 'LdStreamListenerIntf': Retorna cert només si en cas d'error en els Streams s'han de cancel·lar.
  @override bool? get cancelOnErrorStream => true;
  
  /// 📍 'LdTagIntf': Retorna la base del tag a fer servir en cas que no es proporcioni cap.
  @override
  String baseTag() => className;
}