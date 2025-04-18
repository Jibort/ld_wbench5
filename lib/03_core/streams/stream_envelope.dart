// stream_envelope.dart
// Encapçulament de tots els missatges enviats a través d'un stream.
// CreatedAt: 2025/04/12 ds. JIQ

import '../ld_model.dart';
import '../../10_tools/date_times.dart';
import '../../10_tools/null_mang.dart';

class StreamEnvelope<M extends LdModel> {
  // 📦 MEMBRES ESTÀTICS ---------------
  static final String className = "StreamEnvelope";
  
  // 🧩 MEMBRES ------------------------
  final DateTime     _sentAt = DateTime.now();
  final String       _srcTag;
  final List<String> _tgtTags;
  final M?           _model;

  // 🛠️ CONSTRUCTORS/CLEANERS ---------
  StreamEnvelope({
    required String pSrc,
    List<String>? pTgts,
    M? pModel })
  : _srcTag  = pSrc,
    _tgtTags = List<String>.from(pTgts?? [], growable: true),
    _model = pModel;

  // 🪟 GETTERS I SETTERS --------------
  DateTime         get sentAt   => _sentAt;
  String           get srcTag   => _srcTag;
  List<String>     get tgtTags  => _tgtTags;
  Iterator<String> get iterTgts => _tgtTags.iterator;
  M?               get model    => _model;
  bool             get hasModel => _model!= null;

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
  @override
  String toString() => """
    when:    ${toIso8601(sentAt)}
    source:  $_srcTag
    targets: ${(isEmpty(tgtTags))? "Tothom": tgtTags.toString()}
    model:   ${(isNull(_model))? "Desconegut": _model!.baseTag}
    what:    ${(isNull(_model))? "[!?]": _model!.toJson()}
  """;
}