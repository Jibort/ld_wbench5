//lib/ui/widgets/ld_button/ld_button_ctrl.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_ctrl_abs.dart';
import 'package:ld_wbench5/core/L10n/string_tx.dart'; // ADDED: Import for translation
import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/services/L.dart';
import 'package:ld_wbench5/ui/extensions/map_extensions.dart';
import 'package:ld_wbench5/ui/widgets/ld_button/ld_button.dart';
import 'package:ld_wbench5/utils/debug.dart';
import 'package:ld_wbench5/ui/widgets/ld_button/ld_button_model.dart';

class LdButtonCtrl extends LdWidgetCtrlAbs<LdButton> {
  // Constructor that calls the parent constructor
  LdButtonCtrl() : super(config);
  
  @override
  void initialize() {
    final config = this.config;
    
    try {
      _model = LdButtonModel.fromMap(config);
    } catch (e) {
      Debug.error("$tag: Error creating model: $e");
      _model = LdButtonModel.fromMap({});
    }
  }
  
  @override
  void dispose() {
    _model?.dispose();
    _model = null;
    super.dispose();
  }
  
  LdButtonModel? _model;
  LdButtonModel? get model => _model;
  
  // IMPLEMENTED: Required abstract method
  @override
  Widget buildContent() {
    return ElevatedButton(
      onPressed: enabled ? onPressed : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(IconData(int.parse(icon!), fontFamily: 'MaterialIcons')),
            const SizedBox(width: 8),
          ],
          Text(label),
        ],
      ),
    );
  }
  
  // IMPLEMENTED: Required abstract method
  @override
  void onEvent(LdEvent event) {
    // Handle events if needed
    // For now, delegate to superclass
    super.onEvent(event);
  }
  
  // IMPLEMENTED: Required abstract method
  @override
  void update(List<String> aspects) {
    // Update specific aspects of the widget
    // Trigger rebuild if necessary
    notifyListeners(aspects);
  }
  
  void onPressed() {
    final onPressedCallback = config[efOnPressed] as Function()?;
    if (onPressedCallback != null) {
      onPressedCallback();
    }
  }

  // FIXED: Apply translation to label
  String get label {
    final labelText = config[cfLabel] as String? ?? "";
    if (labelText.isEmpty) return labelText;
    
    // Apply translation if needed
    return labelText.tx;
  }
  
  // Other getters for button properties
  bool get enabled => config[cfIsEnabled] as bool? ?? true;
  
  // Button styles
  String? get icon => config[cfIcon] as String?;
  Map<String, dynamic>? get buttonStyle => config[cfButtonStyle] as Map<String, dynamic>?;
}