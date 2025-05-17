// lib/ui/widgets/ld_theme_viewer/ld_theme_viewer_ctrl.dart
// Controlador per al visualitzador de temes
// Created: 2025/05/09 dv. JIQ

import 'package:flutter/material.dart';
import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_ctrl_abs.dart';
import 'package:ld_wbench5/services/theme_service.dart';
import 'package:ld_wbench5/ui/widgets/ld_theme_viewer/ld_theme_viewer.dart';
import 'package:ld_wbench5/core/extensions/color_extensions.dart';
import 'package:ld_wbench5/utils/debug.dart';

/// Classe auxiliar per representar un estil de text
class _TextItem {
  final String name;
  final TextStyle? style;
  final String sample;
  
  _TextItem({
    required this.name,
    required this.style,
    required this.sample,
  });
}

/// Controlador per al visualitzador de temes
class   LdThemeViewerCtrl 
extends LdWidgetCtrlAbs<LdThemeViewer> {
  /// Mostrar informació sobre TextTheme
  final bool showTextTheme;
  
  /// Mostrar informació sobre ColorScheme
  final bool showColorScheme;
  
  /// Mostrar en mode compacte
  final bool compact;
  
  /// Mida del color en mode compacte
  final double compactColorSize = 32.0;
  
  /// Mida del color en mode normal
  final double normalColorSize = 48.0;
  
  /// Constructor
  LdThemeViewerCtrl(
    super.pWidget, {
    this.showTextTheme = true,
    this.showColorScheme = true,
    this.compact = false,
  });
  
  @override
  void initialize() {
    Debug.info("$tag: Inicialitzant controlador");
  }
  
  @override
  void update() {
    // No cal fer res específic
  }
  
  @override
  void onEvent(LdEvent event) {
    Debug.info("$tag: Rebut event ${event.eType.name}");
    
    // Reconstruir quan canvia el tema
    if (event.eType == EventType.themeChanged) {
      if (mounted) {
        setState(() {
          Debug.info("$tag: Reconstruint visualitzador després del canvi de tema");
        });
      }
    }
  }
  
  /// Mida actual del color segons el mode
  double get _colorSize => compact ? compactColorSize : normalColorSize;
  
  @override
  Widget buildContent(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Títol
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tema: ${ThemeService.s.currentThemeName}",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ThemeService.s.isDarkMode ? "Fosc" : "Clar",
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const Divider(),
            
            // ColorScheme
            if (showColorScheme) ...[
              Text(
                "Color Scheme",
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              _buildColorSchemeGrid(context),
              const Divider(),
            ],
            
            // TextTheme
            if (showTextTheme) ...[
              Text(
                "Text Theme",
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              _buildTextThemeList(context),
            ],
          ],
        ),
      ),
    );
  }
  
  /// Construeix la graella de colors del ColorScheme
  Widget _buildColorSchemeGrid(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    // Llista de colors a mostrar
    final colorItems = [
      _ColorItem(
        name: "Primary",
        color: colorScheme.primary,
        textColor: colorScheme.onPrimary,
      ),
      _ColorItem(
        name: "Secondary",
        color: colorScheme.secondary,
        textColor: colorScheme.onSecondary,
      ),
      _ColorItem(
        name: "Surface",
        color: colorScheme.surface,
        textColor: colorScheme.onSurface,
      ),
      _ColorItem(
        name: "Background",
        color: Theme.of(context).scaffoldBackgroundColor,
        textColor: colorScheme.onSurface,
      ),
      _ColorItem(
        name: "Error",
        color: colorScheme.error,
        textColor: colorScheme.onError,
      ),
    ];
    
    if (compact) {
      // Vista compacta: tots els colors en una fila
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: colorItems.map((item) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: _buildCompactColorItem(context, item),
            );
          }).toList(),
        ),
      );
    } else {
      // Vista normal: graella de colors
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.0,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: colorItems.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return _buildColorItem(context, colorItems[index]);
        },
      );
    }
  }
  
  /// Construeix un item de color en mode normal
  Widget _buildColorItem(BuildContext context, _ColorItem item) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: _colorSize,
          height: _colorSize,
          decoration: BoxDecoration(
            color: item.color,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.setOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Center(
            child: Text(
              "Aa",
              style: TextStyle(
                color: item.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          item.name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
          ),
        ),
        Text(
          _colorToHex(item.color),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10,
            color: Theme.of(context).textTheme.bodySmall?.color?.setOpacity(0.7),
          ),
        ),
      ],
    );
  }
  
  /// Construeix un item de color en mode compacte
  Widget _buildCompactColorItem(BuildContext context, _ColorItem item) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: _colorSize,
          height: _colorSize,
          decoration: BoxDecoration(
            color: item.color,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.setOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          item.name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10,
          ),
        ),
      ],
    );
  }
  
  /// Construeix la llista d'estils de text
  Widget _buildTextThemeList(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    // Llista d'estils a mostrar
    final textItems = [
      _TextItem(
        name: "Headline Large",
        style: textTheme.headlineLarge,
        sample: "Headline L",
      ),
      _TextItem(
        name: "Headline Medium",
        style: textTheme.headlineMedium,
        sample: "Headline M",
      ),
      _TextItem(
        name: "Headline Small",
        style: textTheme.headlineSmall,
        sample: "Headline S",
      ),
      _TextItem(
        name: "Title Large",
        style: textTheme.titleLarge,
        sample: "Title Large",
      ),
      _TextItem(
        name: "Title Medium",
        style: textTheme.titleMedium,
        sample: "Title Medium",
      ),
      _TextItem(
        name: "Body Large",
        style: textTheme.bodyLarge,
        sample: "Body Large",
      ),
      _TextItem(
        name: "Body Medium",
        style: textTheme.bodyMedium,
        sample: "Body Medium",
      ),
      _TextItem(
        name: "Body Small",
        style: textTheme.bodySmall,
        sample: "Body Small",
      ),
    ];
    
    if (compact) {
      // En mode compacte, mostrem només alguns estils
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextItem(context, textItems[0]), // Headline Large
          _buildTextItem(context, textItems[2]), // Headline Small
          _buildTextItem(context, textItems[5]), // Body Large
          _buildTextItem(context, textItems[7]), // Body Small
        ],
      );
    } else {
      // En mode normal, mostrem tots els estils
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: textItems.map((item) => _buildTextItem(context, item)).toList(),
      );
    }
  }
  
  /// Construeix un item d'estil de text
  Widget _buildTextItem(BuildContext context, _TextItem item) {
    if (item.style == null) return const SizedBox.shrink();
    
    if (compact) {
      // Vista compacta: només el text amb l'estil
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Text(
          item.sample,
          style: item.style,
        ),
      );
    } else {
      // Vista normal: amb més detalls
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 120,
              child: Text(
                item.name,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodySmall?.color?.setOpacity(0.7),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.sample,
                    style: item.style,
                  ),
                  Text(
                    "Size: ${item.style!.fontSize?.toStringAsFixed(1)}",
                    style: TextStyle(
                      fontSize: 10,
                      color: Theme.of(context).textTheme.bodySmall?.color?.setOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
  
  /// Converteix un color a format hexadecimal
  String _colorToHex(Color color) {
    int value = color.toARGB32();
    final r = value >> 16 & 0xFF;
    final g = value >> 8 & 0xFF;
    final b = value & 0xFF;
    
    return '#${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}';
  }
}

/// Classe auxiliar per representar un color
class _ColorItem {
  final String name;
  final Color color;
  final Color textColor;
  
  _ColorItem({
    required this.name,
    required this.color,
    required this.textColor,
  });
}