// lib/ui/widgets/ld_foldable_container/ld_foldable_container_ctrl.dart
// Fitxer per al widget Ld Foldable Container
// Created: 2025/05/17 ds. GPT(JIQ)

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ld_wbench5/ui/widgets/ld_foldable_container/ld_foldable_container.dart';

class   LdFoldableContainerCtrl 
extends State<LdFoldableContainer> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          children: [
            widget.header,
            Positioned(
              right: 0,
              top: 0,
              child: IconButton(
                icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
                onPressed: _toggleExpanded,
              ),
            )
          ],
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: widget.child,
          crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
      ],
    );
  }
}