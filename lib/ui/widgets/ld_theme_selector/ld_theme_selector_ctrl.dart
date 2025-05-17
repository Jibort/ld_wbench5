// lib/ui/widgets/ld_theme_selector/ld_theme_selector_ctrl.dart
// Controlador per al selector de temes
// Created: 2025/05/09 dv. 
// Updated: 2025/05/12 dt. CLA - Correcció del bucle infinit al getter model

import 'package:flutter/material.dart';

import 'package:ld_wbench5/core/event_bus/ld_event.dart';
import 'package:ld_wbench5/core/ld_widget/ld_widget_ctrl_abs.dart';
import 'package:ld_wbench5/core/map_fields.dart';
import 'package:ld_wbench5/services/theme_service.dart';
import 'package:ld_wbench5/ui/widgets/ld_theme_selector/ld_theme_selector.dart';
import 'package:ld_wbench5/core/extensions/color_extensions.dart';

/// Controlador per al selector de temes
class LdThemeSelectorCtrl extends LdWidgetCtrlAbs<LdThemeSelector> {
  /// Mostrar selector de mode (clar/fosc/sistema)
  final bool displayMode;
  
  /// Mostrar selector de temes (Sabina, Natura, etc.)
  final bool displayThemes;
  
  /// Callback quan canvia el mode
  final Function(ThemeMode)? onModeChanged;
  
  /// Callback quan canvia el tema
  final Function(String)? onThemeChanged;
  
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
    //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: Inicialitzant controlador");
    
    // Crear el model amb la configuració del widget
    final config = widget.config;
    final initialMode = config['mfInitialMode'] as ThemeMode? ?? ThemeService.s.themeMode;
    final initialTheme = config['mfInitialTheme'] as String? ?? ThemeService.s.currentThemeName;
    
    //JIQ>CLA: Eliminar quan toquin modificacions
    //JIQ>CLA: model = LdThemeSelectorModel(
    //JIQ>CLA:   widget,
    //JIQ>CLA:   pInitialMode: initialMode,
    //JIQ>CLA:   pInitialTheme: initialTheme,
    //JIQ>CLA: );
    model = LdThemeSelectorModel.fromMap({
      cfTag: tag,
      mfInitialMode: initialMode.toString(),
      mfInitialTheme: initialTheme,
    });
  }
  
  @override
  void update() {
    // No cal fer res específic per ara
  }
  
  @override
  void onEvent(LdEvent event) {
    //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: Rebut event ${event.eType.name}");
    
    // Respondre a canvis de tema globals
    if (event.eType == EventType.themeChanged) {
      // Actualitzar el model si el tema o mode ha canviat des d'una altra part
      bool needsUpdate = false;
      
      // Comprovar si ha canviat el mode
      final currentMode = ThemeService.s.themeMode;
      if ((model as LdThemeSelectorModel).themeMode != currentMode) {
        (model as LdThemeSelectorModel).themeMode = currentMode;
        needsUpdate = true;
      }
      
      // Comprovar si ha canviat el tema
      final currentTheme = ThemeService.s.currentThemeName;
      if ((model as LdThemeSelectorModel).themeName != currentTheme) {
        (model as LdThemeSelectorModel).themeName = currentTheme;
        needsUpdate = true;
      }
      
      // Reconstruir si cal
      if (needsUpdate && mounted) {
        setState(() {
          //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: Actualitzant UI després del canvi global de tema");
        });
      }
    }
  }
  
  /// Canvia el mode del tema
  void _changeThemeMode(ThemeMode mode) {
    //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: Canviant mode de tema a ${mode.toString()}");
    
    // Actualitzar primer el model
    (model as LdThemeSelectorModel).themeMode = mode;
    
    // Després actualitzar el tema global
    ThemeService.s.changeThemeMode(mode);
    
    // Notificar al callback si existeix
    if (onModeChanged != null) {
      onModeChanged!(mode);
    }
  }
  
  /// Canvia el tema
  void _changeTheme(String pName) {
    //JIQ>CLA: Eliminar quan toquin modificacions -> Debug.info("$tag: Canviant tema a '$pName'");
    
    // Actualitzar primer el model
    (model as LdThemeSelectorModel).themeName = pName;
    
    // Després actualitzar el tema global
    ThemeService.s.setCurrentTheme(pName);
    
    // Notificar al callback si existeix
    if (onThemeChanged != null) {
      onThemeChanged!(pName);
    }
  }
  
  @override
  Widget buildContent(BuildContext context) {
    return SingleChildScrollView(  // Afegir ScrollView
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Selector de mode (clar/fosc/sistema)
        if (displayMode) _buildModeSelector(context),
        
        // Espaiador si es mostren les dues parts
        if (displayMode && displayThemes) const SizedBox(height: 16),
        
        // Selector de temes
        if (displayThemes) _buildThemeSelector(context),
      ],
    ));
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
                ...themes.map((pName) =>
                  _buildThemeItem(context, pName)
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  /// Construeix un item del selector de temes
  Widget _buildThemeItem(BuildContext pCtx, String pThemeName) {
    final selectorModel = model as LdThemeSelectorModel?;
    final isSelected = selectorModel?.themeName == pThemeName;
    final theme = Theme.of(pCtx);
    
    // Obtenim colors representatius del tema
    Color primaryColor;
    Color secondaryColor;
    
    // Assignem colors segons el tema
    switch (pThemeName) {
      case themeSabina:
        primaryColor = const Color(0xFF4B70A5);
        secondaryColor = const Color(0xFFE8C074);
        break;
      case themeNatura:
        primaryColor = const Color(0xFF2E7D32);
        secondaryColor = const Color(0xFFFDD835);
        break;
      case themeFire:
        primaryColor = const Color(0xFFE64A19);
        secondaryColor = const Color(0xFFFFD54F);
        break;
      case themeNight:
        primaryColor = const Color(0xFF512DA8);
        secondaryColor = const Color(0xFF7C4DFF);
        break;
      case themeCustom1:
        primaryColor = const Color(0xFF00796B);
        secondaryColor = const Color(0xFFFFAB40);
        break;
      case themeCustom2:
        primaryColor = const Color(0xFF5D4037);
        secondaryColor = const Color(0xFF8D6E63);
        break;
      default:
        primaryColor = Colors.white;
        secondaryColor = Colors.black;
    }
    
    return InkWell(
      onTap: () => _changeTheme(pThemeName),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: theme.colorScheme.primary, width: 2)
              : Border.all(color: theme.dividerColor, width: 1),
        ),
        child: SingleChildScrollView(  // Afegir ScrollView
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
                pThemeName,
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
      ),
    );
  }
}