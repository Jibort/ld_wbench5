// ld_widget_ctrl_abs.dart
// Controlador del Widget base per a l'aplicació.
// Amb gestió de visibilitat, focus i estat actiu.
// Created: 2025/04/29 dt. CLA[JIQ]
// Updated: 2025/05/03 ds. CLA
// ld_widget_ctrl_abs.dart
// Controlador del Widget base per a l'aplicació 
// Created: 2025/04/29 dt. CLA[JIQ]
// Updated: 2025/05/03 ds.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ld_wbench5/core/event_bus/event_bus.dart';
import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/ld_model.dart';
import 'package:ld_wbench5/core/ld_taggable_mixin.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
import 'package:ld_wbench5/core/lifecycle_interface.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Controlador base pels widgets.
abstract class LdWidgetCtrlAbs<T extends LdWidgetAbs>
    extends State<T>
    with LdTaggableMixin
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
    isVisible = !isVisible;
  }
  
  /// Toggle per canviar l'estat actiu
  void toggleEnabled() {
    isEnabled = !isEnabled;
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
    initialize();
    Debug.info("$tag: Controlador inicialitzat");
  }
  
  /// Processa un event rebut
  void _handleEvent(LdEvent event) {
    if (event.isTargetedAt(tag)) {
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
  
  /// 'State': Allibera els recursos.
  @override
  void dispose() {
    Debug.info("$tag: Alliberant recursos ...");
    EventBus.s.cancel(_subcEvent);
    _focusNode.dispose();
    super.dispose();
    Debug.info("$tag: ... Rescursos alliberats");
  }
  
  /// 'LdModelObserverIntf': Notifica que el model ha canviat.
  @override
  void onModelChanged(void Function() updateFunction) {
    if (mounted) setState(updateFunction);
  }
  
  /// 'State': Construeix el widget.
  @override
  Widget build(BuildContext context) {
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
}

// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:ld_wbench5/core/event_bus/event_bus.dart';
// import 'package:ld_wbench5/core/event_bus/ld_event.dart';
// import 'package:ld_wbench5/core/ld_model.dart';
// import 'package:ld_wbench5/core/ld_taggable_mixin.dart';
// import 'package:ld_wbench5/core/ld_widget/ld_widget_abs.dart';
// import 'package:ld_wbench5/core/lifecycle_interface.dart';
// import 'package:ld_wbench5/utils/debug.dart';

// /// Controlador base pels widgets.
// abstract   class LdWidgetCtrlAbs<T extends LdWidgetAbs>
// extends    State<T> 
// with       LdTaggableMixin
// implements LdLifecycleIntf, LdModelObserverIntf {
//   /// Retorna el widget associat al controlador amb el tipus correcte.
//   T get cWidget => widget;
  
//   /// Subscripció als events de l'aplicació
//   StreamSubscription<LdEvent>? _subcEvent;
  
//   /// CONSTRUCTOR ---------------------
//   LdWidgetCtrlAbs(T pWidget);

//   /// Inicialitza el controlador
//   @override initState() {
//     super.initState();
//     tag = '${widget.tag}_Ctrl';
//     _subcEvent = EventBus.s.listen(_handleEvent);
//     initialize();
//     Debug.info("$tag: Controlador inicialitzat");
//   }
  
//   /// Processa un event rebut
//   void _handleEvent(LdEvent event) {
//     if (event.isTargetedAt(tag)) {
//       Debug.info("$tag: Processant event ${event.eType.name}");
//       onEvent(event);
//     }
//   }
  
//   /// Mètode a sobreescriure per gestionar events
//   void onEvent(LdEvent event);
  
//   /// 'State': Actualitza el controlador quan canvien les dependències.
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     Debug.info("$tag: Dependències actualitzades");
//     update();
//   }
  
//   /// 'State': Allibera els recursos.
//   @override
//   void dispose() {
//     Debug.info("$tag: Alliberant recursos ...");
//     EventBus.s.cancel(_subcEvent);
//     super.dispose();
//     Debug.info("$tag: ... Rescursos alliberats");
//   }
  
//   /// 'LdModelObserverIntf': Notifica que el model ha canviat.
//   @override
//   void onModelChanged(void Function() updateFunction) {
//     if (mounted) setState(updateFunction);
//   }
  
//   /// 'State': Construeix el widget.
//   @override
//   Widget build(BuildContext context) => buildContent(context);

//   // FUNCIONALITAT ABSTRACTA ----------
//   /// Mètode que ha d'implementar cada widget per construir la seva UI
//   Widget buildContent(BuildContext context);
  
  
// }