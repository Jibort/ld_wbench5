// lib/ui/widgets/ld_text/ld_text.dart
// Widget de text que suporta internacionalització automàtica
// Created: 2025/05/06 dt. CLA
// Updated: 2025/05/12 dt. CLA - Implementació del sistema de callbacks per models externs

import 'package:flutter/material.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
import 'package:ld_wbench5/core/ld_model_abs.dart';
import 'package:ld_wbench5/services/maps_service.dart';
import 'package:ld_wbench5/ui/extensions/map_extensions.dart';
import 'package:ld_wbench5/ui/widgets/ld_label/ld_label_ctrl.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/ui/widgets/ld_label/ld_label_model.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Widget Label personalitzat
/// 
/// Hereta de [LdWidgetAbs] per utilitzar l'arquitectura unificada
/// amb GlobalKey i LdTaggableMixin.
/// 
/// Tota la lògica està al [LdLabelCtrl].
class   LdLabel 
extends LdWidgetAbs {
  /// Mapa de callbacks registrats per models externs
  final Map<String, Function(LdModelAbs)> _modelCallbacks = {};
  
  LdLabel({
    Key? key,  
    super.pTag,
    String text = '',
    List<dynamic>? args,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    double? textScaleFactor,
    TextScaler? textScaler,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
    Color? selectionColor,
  }) : super(pKey: key) {
    // Configurar tots els camps
    final map = <String, dynamic>{
      // Configuració del controlador (cf)
      cfTextStyle: style,
      cfTextAlign: textAlign,
      cfTextDirection: textDirection,
      cfLocale: locale,
      cfSoftWrap: softWrap,
      cfOverflow: overflow,
      cfTextWidthBasis: textWidthBasis,
      cfTextHeightBehavior: textHeightBehavior,
      cfSemanticLabel: semanticsLabel,
      cfSelectionColor: selectionColor,
      
      // Camps adicionals
      if (strutStyle != null) cfStructStyle: strutStyle,
      if (textScaleFactor != null) cfTextScaleFactor: textScaleFactor,
      if (textScaler != null) cfTextScaler: textScaler,
      if (maxLines != null) cfMaxLines: maxLines,
      
      // Dades del model (mf)
      mfText: text,
      mfArgs: args,
    };
    
    MapsService.s.updateMap(tag, map);
  }

  /// Constructor alternatiu a partir d'un mapa
  LdLabel.fromMap(LdMap<dynamic> pConfig)
  : super(pConfig: pConfig) {
    Debug.info("$tag: LdLabel creat des d'un mapa");
  }

  @override
  LdLabelCtrl createCtrl() => LdLabelCtrl(this);

  // ACCESSORS PER A COMPATIBILITAT
  LdLabelModel? get model {
    final ctrl = wCtrl;
    if (ctrl is LdLabelCtrl) {
      return ctrl.model as LdLabelModel?;
    }
    return null;
  }

  LdLabelCtrl? get controller =>
    (wCtrl is LdLabelCtrl)
      ? wCtrl as LdLabelCtrl
      : null;

  // PROPIETATS DEL MODEL
  String get text => model?.displayText ?? "";
  set text(String value) {
    model?.updateField(mfText, value);
  }
  
  /// Arguments per format
  List<dynamic>? get args => model?.args;
  set args(List<dynamic>? value) {
    model?.args = value;
  }

  // SISTEMA DE CALLBACKS PER MODELS EXTERNS
  
  /// Registra un callback per quan canviï un model extern específic
  void registerModelCallback<T extends LdModelAbs>(T model, Function(T) callback) {
    final callbackKey = "${T.toString()}_${model.tag}";
    _modelCallbacks[callbackKey] = (m) => callback(m as T);
    
    // Registrar aquest LdLabel com a observador del model extern
    model.attachObserver(this);
    
    Debug.info("$tag: Registrat callback per model ${model.tag} de tipus $T");
  }
  
  /// Desregistra un callback per un model específic
  void unregisterModelCallback<T extends LdModelAbs>(T model) {
    final callbackKey = "${T.toString()}_${model.tag}";
    _modelCallbacks.remove(callbackKey);
    
    // Desregistrar com a observador del model extern
    model.detachObserver(this);
    
    Debug.info("$tag: Desregistrat callback per model ${model.tag} de tipus $T");
  }
  
  /// Desregistra tots els callbacks i observers
  void detachFromAllModels() {
    // Copiem les claus per evitar modificació concurrent
    final keys = _modelCallbacks.keys.toList();
    for (final key in keys) {
      _modelCallbacks.remove(key);
    }
    
    Debug.info("$tag: Desregistrats tots els callbacks");
  }
  
  /// Gestiona les notificacions dels models externs
  @override
  void onModelChanged(LdModelAbs pModel, void Function() pfUpdate) {
    Debug.info("$tag: Rebut canvi de model extern: ${pModel.tag}");
    
    // Buscar el callback apropiat
    String? matchingKey;
    for (final key in _modelCallbacks.keys) {
      if (key.contains(pModel.tag)) {
        matchingKey = key;
        break;
      }
    }
    
    if (matchingKey != null) {
      final callback = _modelCallbacks[matchingKey];
      if (callback != null) {
        Debug.info("$tag: Executant callback per model ${pModel.tag}");
        callback(pModel);
      }
    }
    
    // Executar la funció d'actualització
    pfUpdate();
    
    // Delegar al controlador si està disponible
    if (controller != null) {
      controller!.onModelChanged(pModel, pfUpdate);
    }
  }
}