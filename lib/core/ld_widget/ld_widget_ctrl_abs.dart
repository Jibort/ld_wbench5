// ld_widget_ctrl_abs.dart
// Controlador del Widget base per a l'aplicació.
// Amb gestió de visibilitat, focus i estat actiu.
// Created: 2025/04/29 dt. CLA[JIQ]
// Updated: 2025/05/03 ds. CLA

import 'dart:async';
import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/event_bus/event_bus.dart';
import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/ld_model_abs.dart';
import 'package:ld_wbench5/core/ld_taggable_mixin.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
import 'package:ld_wbench5/core/lifecycle_interface.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Controlador base pels widgets.
abstract   class LdWidgetCtrlAbs<T extends LdWidgetAbs>
extends    State<T>
with       LdTaggableMixin
implements LdLifecycleIntf, LdModelObserverIntf {
  /// Retorna el widget associat al controlador amb el tipus correcte.
  T get cWidget => widget;
  
  /// Subscripció als events de l'aplicació
  StreamSubscription<LdEvent>? _subcEvent;
  
  /// PROPIETATS DE VISUALITZACIÓ I INTERACCIÓ ===================================
  /// Flag de visibilitat del widget
  bool _isVisible = true;
  /// Retorna si el widget és visible
  bool get isVisible => _isVisible;
  /// Estableix si el widget és visible i reconstrueix la UI si és necessari
  set isVisible(bool value) {
    if (_isVisible != value && mounted) {
      setState(() {
        _isVisible = value;
        Debug.info("$tag: Visibilitat canviada a $value");
      });
    } else if (_isVisible != value) {
      // Si no està muntat (durant la inicialització), només canviem el valor
      _isVisible = value;
      Debug.info("$tag: Visibilitat canviada a $value (sense reconstrucció)");
    }
  }

  /// Node de focus pel widget
  final FocusNode _focusNode = FocusNode();
  /// Retorna el node de focus del widget
  FocusNode get focusNode => _focusNode;
  /// Indica si el widget té el focus
  bool get hasFocus => _focusNode.hasFocus;
  
  /// Flag que indica si el widget pot rebre focus
  bool _canFocus = true;
  /// Retorna si el widget pot rebre focus
  bool get canFocus => _canFocus;
  /// Estableix si el widget pot rebre focus i reconstrueix la UI si és necessari
  set canFocus(bool value) {
    if (_canFocus != value && mounted) {
      setState(() {
        _canFocus = value;
        if (!value && hasFocus) {
          _focusNode.unfocus();
        }
        Debug.info("$tag: Capacitat de focus canviada a $value");
      });
    } else if (_canFocus != value) {
      // Si no està muntat (durant la inicialització), només canviem el valor
      _canFocus = value;
      if (!value && hasFocus) {
        _focusNode.unfocus();
      }
      Debug.info("$tag: Capacitat de focus canviada a $value (sense reconstrucció)");
    }
  }
  
  /// Flag que indica si el widget està actiu (enabled)
  bool _isEnabled = true;
  /// Retorna si el widget està actiu
  bool get isEnabled => _isEnabled;
  /// Estableix si el widget està actiu i reconstrueix la UI si és necessari
  set isEnabled(bool value) {
    if (_isEnabled != value && mounted) {
      setState(() {
        _isEnabled = value;
        if (!value && hasFocus) {
          _focusNode.unfocus();
        }
        Debug.info("$tag: Estat d'activació canviat a $value");
      });
    } else if (_isEnabled != value) {
      // Si no està muntat (durant la inicialització), només canviem el valor
      _isEnabled = value;
      if (!value && hasFocus) {
        _focusNode.unfocus();
      }
      Debug.info("$tag: Estat d'activació canviat a $value (sense reconstrucció)");
    }
  }
  
  /// Demana focus per aquest widget si pot rebre'l i està actiu
  void requestFocus() {
    if (canFocus && isEnabled && isVisible) {
      _focusNode.requestFocus();
      Debug.info("$tag: Focus demanat");
    }
  }
  
  /// Configura l'estat del widget (visible, focus, enabled) i reconstrueix la UI
  void setWidgetState({
    bool? visible,
    bool? canFocus,
    bool? enabled,
  }) {
    bool needsUpdate = false;
    
    if (visible != null && _isVisible != visible) {
      _isVisible = visible;
      needsUpdate = true;
    }
    
    if (canFocus != null && _canFocus != canFocus) {
      _canFocus = canFocus;
      if (!canFocus && hasFocus) {
        _focusNode.unfocus();
      }
      needsUpdate = true;
    }
    
    if (enabled != null && _isEnabled != enabled) {
      _isEnabled = enabled;
      if (!enabled && hasFocus) {
        _focusNode.unfocus();
      }
      needsUpdate = true;
    }
    
    if (needsUpdate && mounted) {
      setState(() {
        Debug.info("$tag: Estat del widget actualitzat");
      });
    } else if (needsUpdate) {
      Debug.info("$tag: Estat del widget actualitzat (sense reconstrucció)");
    }
  }
  
  /// Toggle per canviar la visibilitat
  void toggleVisibility() {
    Debug.info("$tag: Cridant a toggleVisibility()");
    if (mounted) {
      setState(() {
        _isVisible = !_isVisible;
        Debug.info("$tag: Visibilitat alternada a $_isVisible");
      });
    } else {
      _isVisible = !_isVisible;
      Debug.info("$tag: Visibilitat alternada a $_isVisible (sense reconstrucció)");
    }
  }
  
  /// Toggle per canviar l'estat actiu
  void toggleEnabled() {
    Debug.info("$tag: Cridant a toggleEnabled()");
    if (mounted) {
      setState(() {
        _isEnabled = !_isEnabled;
        Debug.info("$tag: Estat d'activació alternat a $_isEnabled");
      });
    } else {
      _isEnabled = !_isEnabled;
      Debug.info("$tag: Estat d'activació alternat a $_isEnabled (sense reconstrucció)");
    }
  }
  
  /// CONSTRUCTOR ---------------------
  LdWidgetCtrlAbs(T pWidget, {
    bool isVisible = true,
    bool canFocus = true,
    bool isEnabled = true
  }) {
    // Assignem els valors directament sense cridar setState
    _isVisible = isVisible;
    _canFocus = canFocus;
    _isEnabled = isEnabled;
    
    // Configurar listener de focus per debugging
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        Debug.info("$tag: Ha rebut el focus");
      } else {
        Debug.info("$tag: Ha perdut el focus");
      }
    });
  }

  /// Inicialitza el controlador
  @override
  void initState() {
    super.initState();
    tag = '${widget.tag}_Ctrl';
    _subcEvent = EventBus.s.listen(_handleEvent);
    
    // Registrar-se com a observador del model si existeix
    _attachToModel();
    
    initialize();
    Debug.info("$tag: Controlador inicialitzat");
  }
  
  /// Vincula el controlador com a observador del model, si existeix
  void _attachToModel() {
    try {
      if (widget.hasModel) {
        try {
          final model = widget.wModel;
          model.attachObserver(this);
          Debug.info("$tag: Registrat com a observador del model");
        } catch (e) {
          Debug.warn("$tag: Error en registrar-se com a observador: ${e.toString()}");
        }
      } else {
        Debug.info("$tag: Widget sense model, no cal registrar-se com a observador");
      }
    } catch (e) {
      Debug.warn("$tag: No s'ha pogut registrar com a observador: ${e.toString()}");
    }
  }

  
  /// Processa un event rebut
void _handleEvent(LdEvent event) {
  // Eliminar el filtratge per tag en events globals importants
  // i assegurar que tots els widgets rebin aquests events
  if (event.eType == EventType.languageChanged || 
      event.eType == EventType.themeChanged || 
      event.eType == EventType.rebuildUI || 
      event.isTargetedAt(tag)) {
    Debug.info("$tag: Processant event ${event.eType.name}");
    onEvent(event);
  }
}
  
  /// Mètode a sobreescriure per gestionar events
  void onEvent(LdEvent event);
  
  /// 'State': Actualitza el controlador quan canvien les dependències.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Debug.info("$tag: Dependències actualitzades");
    update();
  }
  
  /// 'State': Gestiona l'actualització del widget quan canvien les propietats
  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Obtenir els models antic i actual
    if (widget.hasModel && oldWidget.hasModel) {
      LdWidgetModelAbs oldModel = oldWidget.wModel;
      LdWidgetModelAbs newModel = widget.wModel;
      
      // Verificar si els models són diferents
      if (_shouldUpdateModel(oldModel, newModel)) {
        Debug.info("$tag: Model actualitzat, forçant reconstrucció");
        setState(() {
          // Forçar reconstrucció
        });
      }
    }
  }

  /// Determina si cal actualitzar el model basant-se en els canvis
  bool _shouldUpdateModel(LdWidgetModelAbs oldModel, LdWidgetModelAbs newModel) {
    // Implementació per defecte que compara els mapes dels models
    return !_areMapEqual(oldModel.toMap(), newModel.toMap());
  }

  /// Compara dos mapes recursivament
  bool _areMapEqual(Map<String, dynamic> map1, Map<String, dynamic> map2) {
    if (map1.length != map2.length) return false;
    
    for (final key in map1.keys) {
      if (!map2.containsKey(key)) return false;
      
      final value1 = map1[key];
      final value2 = map2[key];
      
      if (value1 is Map && value2 is Map) {
        if (!_areMapEqual(value1 as Map<String, dynamic>, value2 as Map<String, dynamic>)) {
          return false;
        }
      } else if (value1 is List && value2 is List) {
        if (!_areListEqual(value1, value2)) {
          return false;
        }
      } else if (value1 != value2) {
        return false;
      }
    }
    
    return true;
  }

  /// Compara dues llistes recursivament
  bool _areListEqual(List list1, List list2) {
    if (list1.length != list2.length) return false;
    
    for (int i = 0; i < list1.length; i++) {
      final value1 = list1[i];
      final value2 = list2[i];
      
      if (value1 is Map && value2 is Map) {
        if (!_areMapEqual(value1 as Map<String, dynamic>, value2 as Map<String, dynamic>)) {
          return false;
        }
      } else if (value1 is List && value2 is List) {
        if (!_areListEqual(value1, value2)) {
          return false;
        }
      } else if (value1 != value2) {
        return false;
      }
    }
    
    return true;
  }

  void _unregisterAsObserver() {
    // Desregistrar-se com a observador del model, si existeix
    try {
      if (widget.hasModel) {
        try {
          final model = widget.wModel;
          // No cal passar cap paràmetre, ja que ara el mètode pot desconnectar tots els observadors
          model.detachObserver();
          Debug.info("$tag: Desregistrat com a observador del model");
        } catch (e) {
          Debug.warn("$tag: Error en desregistrar-se com a observador: ${e.toString()}");
        }
      }
    } catch (e) {
      Debug.warn("$tag: No s'ha pogut desregistrar com a observador: ${e.toString()}");
    }
  }
  /// 'State': Allibera els recursos.
  @override
  void dispose() {
    Debug.info("$tag: Alliberant recursos ...");
    
    // Desregistrar-se com a observador del model, si existeix
    try {
      // Utilitzar el nou getter hasModel per comprovar si el widget té model
      if (widget.hasModel) {
        try {
          _unregisterAsObserver();
          Debug.info("$tag: Desregistrat com a observador del model");
        } catch (e) {
          // Pot fallar si el model no està correctament inicialitzat
          Debug.warn("$tag: Error en desregistrar-se com a observador: ${e.toString()}");
        }
      }
    } catch (e) {
      // Capturar qualsevol excepció durant l'intent de desregistre
      Debug.warn("$tag: No s'ha pogut desregistrar com a observador: ${e.toString()}");
    }
    
    EventBus.s.cancel(_subcEvent);
    _focusNode.dispose();
    super.dispose();
    Debug.info("$tag: ... Recursos alliberats");
  }
  
  @override
  void onModelChanged(LdModelAbs pModel, void Function() pfUpdate) {
    Debug.info("$tag: Model ha canviat");
    
    // Executa la funció d'actualització sempre
    pfUpdate();
    
    // Però només reconstrueix si està muntat
    if (mounted) {
      setState(() {
        Debug.info("$tag: Reconstruint després del canvi del model");
      });
    }
  }

  /// 'State': Construeix el widget.
  @override
  Widget build(BuildContext context) {
    Debug.info("$tag: Construint widget. isVisible=$_isVisible");
    
    // Si el widget no és visible, retornem un SizedBox buit
    if (!_isVisible) {
      return const SizedBox.shrink();
    }
    
    // Construïm el contingut del widget
    Widget content = buildContent(context);
    
    // Apliquem l'opacitat i l'absorció d'events si el widget no està actiu
    if (!_isEnabled) {
      content = Opacity(
        opacity: 0.5,
        child: AbsorbPointer(
          absorbing: true,
          child: content,
        ),
      );
    }
    
    return content;
  }

  // FUNCIONALITAT ABSTRACTA ----------
  /// Mètode que ha d'implementar cada widget per construir la seva UI
  /// Aquest mètode ha de gestionar el focus i l'estat del widget internament
  Widget buildContent(BuildContext context);

  /// Passarel·la de pas per a la crida a setState().
  @override setState(void Function() pFN) {
    super.setState(pFN);
   }
}
