// lib/ui/widgets/ld_foldable_container/ld_foldable_container_widget.dart
// Widget contenidor expandible/plegable amb capçalera persistent i botó de toggle.
// Created: 2025/05/17 ds. GPT(JIQ)

import 'package:flutter/material.dart';

export "ld_foldable_container_ctrl.dart";
export "ld_foldable_container_model.dart";

/// Widget contenidor expandible/plegable amb capçalera persistent i botó de toggle.
class   LdFoldableContainer 
extends StatefulWidget {
  final Widget header;
  final Widget child;
  final bool initiallyExpanded;

  const LdFoldableContainer({
    super.key,
    required this.header,
    required this.child,
    this.initiallyExpanded = false,
  });

  @override
  State<LdFoldableContainer> createState() => LdFoldableContainerCtrl();
}
