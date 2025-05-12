// sabina_app_model.dart
// Model del widget principal de l'aplicació.
// Created: 2025/05/03 ds. JIQ


import 'package:ld_wbench5/core/ld_model_abs.dart';
import 'package:ld_wbench5/ui/app/sabina_app.dart';
import 'package:ld_wbench5/ui/extensions/map_extensions.dart';
import 'package:ld_wbench5/utils/once_set.dart';

/// Model del widget principal de l'aplicació.
class SabinaAppModel
extends LdModelAbs {
  /// Referència a la instància de l'aplicació.
  final OnceSet<SabinaApp> _app = OnceSet<SabinaApp>();

  /// Retorna la referència a la instància de l'aplicació.
  SabinaApp get app => _app.get()!;

  /// Estableix la referència a la instància de l'aplicació.
  set app(SabinaApp pPage) => _app.set(pPage);

  /// CONSTRUCTORS --------------------
  SabinaAppModel({ required SabinaApp pApp }) { app = pApp; }

  // 'LdPageModelAbs' -----------------
  @override
  void fromMap(LdMap pMap) => super.fromMap(pMap);

  /// Retorna un mapa amb els membres del model.
  @override
  LdMap<dynamic> toMap() => super.toMap();

  @override
  getField({required String pKey, bool pCouldBeNull = true, String? pErrorMsg}) 
  => super.getField(pKey: pKey, pCouldBeNull: pCouldBeNull, pErrorMsg: pErrorMsg);

  @override
  bool setField({required String pKey, dynamic pValue, bool pCouldBeNull = true, String? pErrorMsg}) 
  => super.setField(pKey: pKey, pValue: pValue, pCouldBeNull: pCouldBeNull, pErrorMsg: pErrorMsg);
}