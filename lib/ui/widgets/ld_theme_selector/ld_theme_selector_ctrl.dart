// lib/ui/widgets/ld_theme_selector/ld_theme_selector_ctrl.dart
// Controlador per al selector de temes
// Created: 2025/05/09 dv. 
// Updated: 2025/05/12 dt. CLA - Correcció del bucle infinit al getter model

import 'package:flutter/material.dart';
import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_ctrl_abs.dart';
import 'package:ld_wbench5/services/ld_theme.dart';
import 'package:ld_wbench5/ui/widgets/ld_theme_selector/ld_theme_selector.dart';
import 'package:ld_wbench5/ui/widgets/ld_theme_selector/ld_theme_selector_model.dart';
import 'package:ld_wbench5/utils/debug.dart';
import 'package:ld_wbench5/ui/extensions/color_extensions.dart';

/// Controlador per al selector de temes
class LdThemeSelectorCtrl extends LdWidgetCtrlAbs<LdThemeSelector> {
  /// Mostrar selector de mode (clar/fosc/sistema)
  final bool displayMode;
  
  /// Mostrar selector de temes (Sabina, Natura, etc.)
  final bool displayThemes;
  
  /// Callback quan canvia el mode
  final Function(ThemeMode)? onModeChanged;
  
  /// Callback quan canvia el tema
  final Function(ThemeName)? onThemeChanged;
  
  /// Constructor
  LdThemeSelectorCtrl(
    super.pWidget, {
    this.displayMode = true,
    this.displayThemes = true,
    this.onModeChanged,
    this.onThemeChanged,
  });
  
  @override
  void initialize() {
    Debug.info("$tag: Inicialitzant controlador");
    
    // Crear el model amb la configuració del widget
    final config = widget.config;
    final initialMode = config['mfInitialMode'] as ThemeMode? ?? LdTheme.s.themeMode;
    final initialTheme = config['mfInitialTheme'] as ThemeName? ?? LdTheme.s.currentThemeName;
    
    model = LdThemeSelectorModel(
      widget,
      initialMode: initialMode,
      initialTheme: initialTheme,
    );
  }
  
  @override
  void update() {
    // No cal fer res específic per ara
  }
  
  @override
  void onEvent(LdEvent event) {
    Debug.info("$tag: Rebut event ${event.eType.name}");
    
    // Respondre a canvis de tema globals
    if (event.eType == EventType.themeChanged) {
      // Actualitzar el model si el tema o mode ha canviat des d'una altra part
      bool needsUpdate = false;
      
      // Comprovar si ha canviat el mode
      final currentMode = LdTheme.s.themeMode;
      if ((model as LdThemeSelectorModel).themeMode != currentMode) {
        (model as LdThemeSelectorModel).themeMode = currentMode;
        needsUpdate = true;
      }
      
      // Comprovar si ha canviat el tema
      final currentTheme = LdTheme.s.currentThemeName;
      if ((model as LdThemeSelectorModel).themeName != currentTheme) {
        (model as LdThemeSelectorModel).themeName = currentTheme;
        needsUpdate = true;
      }
      
      // Reconstruir si cal
      if (needsUpdate && mounted) {
        setState(() {
          Debug.info("$tag: Actualitzant UI després del canvi global de tema");
        });
      }
    }
  }
  
  /// Canvia el mode del tema
  void _changeThemeMode(ThemeMode mode) {
    Debug.info("$tag: Canviant mode de tema a ${mode.toString()}");
    
    // Actualitzar primer el model
    (model as LdThemeSelectorModel).themeMode = mode;
    
    // Després actualitzar el tema global
    LdTheme.s.changeThemeMode(mode);
    
    // Notificar al callback si existeix
    if (onModeChanged != null) {
      onModeChanged!(mode);
    }
  }
  
  /// Canvia el tema
  void _changeTheme(ThemeName name) {
    Debug.info("$tag: Canviant tema a ${LdTheme.s.getThemeNameString(name)}");
    
    // Actualitzar primer el model
    (model as LdThemeSelectorModel).themeName = name;
    
    // Després actualitzar el tema global
    LdTheme.s.currentThemeName = name;
    
    // Notificar al callback si existeix
    if (onThemeChanged != null) {
      onThemeChanged!(name);
    }
  }
  
  @override
  Widget buildContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Selector de mode (clar/fosc/sistema)
        if (displayMode) _buildModeSelector(context),
        
        // Espaiador si es mostren les dues parts
        if (displayMode && displayThemes) const SizedBox(height: 16),
        
        // Selector de temes
        if (displayThemes) _buildThemeSelector(context),
      ],
    );
  }
  
  /// Construeix el selector de mode (clar/fosc/sistema)
  Widget _buildModeSelector(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Títol
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 4.0, bottom: 8.0),
              child: Text(
                "Mode de tema",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            
            // Selectors
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Botó Sistema
                _buildModeButton(
                  context,
                  mode: ThemeMode.system,
                  icon: Icons.brightness_auto,
                  label: "Sistema",
                  tooltip: "Seguir la configuració del sistema",
                ),
                
                // Botó Clar
                _buildModeButton(
                  context,
                  mode: ThemeMode.light,
                  icon: Icons.brightness_high,
                  label: "Clar",
                  tooltip: "Utilitzar tema clar",
                ),
                
                // Botó Fosc
                _buildModeButton(
                  context,
                  mode: ThemeMode.dark,
                  icon: Icons.brightness_4,
                  label: "Fosc",
                  tooltip: "Utilitzar tema fosc",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildModeButton(
    BuildContext context, {
    required ThemeMode mode,
    required IconData icon,
    required String label,
    required String tooltip,
  }) {
    final selectorModel = model as LdThemeSelectorModel?;
    final isSelected = selectorModel?.themeMode == mode;
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Colors millorats per assegurar visibilitat en ambdós modes
    final Color backgroundColor = isSelected 
        ? theme.colorScheme.primary.setOpacity(0.2)
        : isDark ? Colors.grey[800]! : Colors.grey[200]!;
        
    final Color borderColor = isSelected
        ? theme.colorScheme.primary
        : isDark ? Colors.grey[600]! : Colors.grey[400]!;
        
    final Color iconColor = isSelected 
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface.setOpacity(0.8);
        
    final Color textColor = isSelected
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface.setOpacity(0.8);

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: () => _changeThemeMode(mode),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: iconColor,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  /// Construeix el selector de temes
  Widget _buildThemeSelector(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Títol
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 4.0, bottom: 8.0),
              child: Text(
                "Estil de tema",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            
            // Grid de temes
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.0,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              padding: const EdgeInsets.all(8.0),
              children: [
                // Per a cada tema, crear un item
                ...ThemeName.values.map((themeName) =>
                  _buildThemeItem(context, themeName)
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  /// Construeix un item del selector de temes
  Widget _buildThemeItem(BuildContext context, ThemeName themeName) {
    final selectorModel = model as LdThemeSelectorModel?;
    final isSelected = selectorModel?.themeName == themeName;
    final theme = Theme.of(context);
    
    // Obtenim colors representatius del tema
    Color primaryColor;
    Color secondaryColor;
    
    // Assignem colors segons el tema
    switch (themeName) {
      case ThemeName.sabina:
        primaryColor = const Color(0xFF4B70A5);
        secondaryColor = const Color(0xFFE8C074);
        break;
      case ThemeName.natura:
        primaryColor = const Color(0xFF2E7D32);
        secondaryColor = const Color(0xFFFDD835);
        break;
      case ThemeName.foc:
        primaryColor = const Color(0xFFE64A19);
        secondaryColor = const Color(0xFFFFD54F);
        break;
      case ThemeName.nit:
        primaryColor = const Color(0xFF512DA8);
        secondaryColor = const Color(0xFF7C4DFF);
        break;
      case ThemeName.custom1:
        primaryColor = const Color(0xFF00796B);
        secondaryColor = const Color(0xFFFFAB40);
        break;
      case ThemeName.custom2:
        primaryColor = const Color(0xFF5D4037);
        secondaryColor = const Color(0xFF8D6E63);
        break;
    }
    
    return InkWell(
      onTap: () => _changeTheme(themeName),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: theme.colorScheme.primary, width: 2)
              : Border.all(color: theme.dividerColor, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Previsualització de colors
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [primaryColor, secondaryColor],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.setOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Nom del tema
            Text(
              LdTheme.s.getThemeNameString(themeName),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? theme.colorScheme.primary : null,
              ),
            ),
            
            // Indicador de seleccionat
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: theme.colorScheme.primary,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }
}