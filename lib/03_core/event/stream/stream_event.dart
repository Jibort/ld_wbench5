// stream_event.dart
// Encapçulament de tots els missatges enviats a través d'un stream.
// CreatedAt: 2025/04/12 ds. JIQ

import 'package:ld_wbench5/03_core/mixins/import.dart';
import 'package:ld_wbench5/03_core/model/ld_model_abs.dart';
import 'package:ld_wbench5/10_tools/date_times.dart';
import 'package:ld_wbench5/10_tools/null_mang.dart';
import 'package:ld_wbench5/10_tools/once_set.dart';

// typedef StreamEventWModel = StreamEvent;

abstract class StreamEventWModel
extends StreamEvent {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "StreamEventWModel";
  
  // 🧩 MEMBRES ------------------------
  final LdModelAbs _model;

  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  StreamEventWModel({
    required super.pSrc,
    super.pTgts,
    required LdModelAbs pModel })
  : _model = pModel;

  // 🪟 GETTERS I SETTERS --------------
  LdModelAbs get model  => _model;
  @override get hasModel => true;

  // ⚙️ FUNCIONALITAT -----------------
  /// 📍 'Object': Retorna una representació textual de l'event d'Stream.
  @override
  String toString() => """
    when:    ${toIso8601(sentAt)}
    source:  $_srcTag
    targets: ${(isEmpty(tgtTags))? "Tothom": tgtTags.toString()}
    model:   ${(isNull(_model))? "Desconegut": _model.baseTag}
    what:    ${(isNull(_model))? "[!?]": _model.toJson()}
  """;
  
  // 📍 'LdTagMixin:LdTagIntf': Retorna la base del tag a fer servir en cas que no es proporcioni cap.
  @override String baseTag() => className;
}

abstract class StreamEvent
with  LdTagMixin {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "StreamEvent";
  
  // 🧩 MEMBRES ------------------------
  final DateTime      _sentAt = DateTime.now();
  final String        _srcTag;
  final List<String>  _tgtTags;
  final OnceSet<bool> _consumed = OnceSet<bool>(pInst: false);

  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  StreamEvent({
    required String pSrc,
    List<String>? pTgts,
    LdModelAbs? pModel })
  : _srcTag  = pSrc,
    _tgtTags = List<String>.from(pTgts?? [], growable: true);

  // 🪟 GETTERS I SETTERS --------------
  DateTime         get sentAt        => _sentAt;
  String           get srcTag        => _srcTag;
  List<String>     get tgtTags       => _tgtTags;
  Iterator<String> get iterTgts      => _tgtTags.iterator;
  bool             get hasModel      => false;
  String           get instClassName => className;
  bool             get isConsumed    => _consumed.get();
  set         isConsumed(bool pCons) => _consumed.set(pCons);


  // ⚙️ FUNCIONALITAT -----------------
  int get length => _tgtTags.length;

  String? tgtAt(int pIdx) =>
    (pIdx >= 0 && pIdx < length)
      ? _tgtTags[pIdx]
      : null;

  int addTgt(String pTag) {
    if (!tgtTags.contains(pTag)) {
      tgtTags.add(pTag);
    }
    return tgtTags.length;
  }

  int addTgts(List<String> pTgts) {
    for (var tag in pTgts) {
      if (!tgtTags.contains(tag)) {
        tgtTags.add(tag);
      }
    }
    return tgtTags.length;
  }

  // ⚙️ FUNCIONALITAT ESTESA ----------
  /// 📍 'Object': Retorna una representació textual de l'event d'Stream.
  @override
  String toString() => """
    when:    ${toIso8601(sentAt)}
    source:  $_srcTag
    targets: ${(isEmpty(tgtTags))? "Tothom": tgtTags.toString()}
  """;
  
  // 📍 'LdTagMixin:LdTagIntf': Retorna la base del tag a fer servir en cas que no es proporcioni cap.
  @override String baseTag() => className;
}