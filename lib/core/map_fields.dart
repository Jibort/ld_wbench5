// lib/core/map_fields.dart
// Constants per als noms dels camps utilitzats en mapes.
// Created: 2025/04/29 dt. JIQ
// Updated: 2025/05/09 dv. CLA - Ampliaci  de camps i millora de nomenclatura.
// Updated: 2025/05/11 dg. CLA - Actualitzaci  de constants per diferenciar correctament mf/cf/ef
// Updated: 2025/05/12 dt. CLA - Afegir constants que falten per completar l'arquitectura
// Updated: 2025/05/18 ds. GEM - Afegides constants per LdFoldableContainer i LdCheckBox

// Constants per tipus de mapes
import 'package:ld_wbench5/core/extensions/string_extensions.dart';

const String kMapTypeWidget = 'widget';
const String kMapTypeEntity = 'entity';
const String kMapTypeConfig = 'config';

// Events (ef) - Dades d'esdeveniments
const String efLifecycleState = "ef_lifecycle_state";
const String efOldLocale = 'ef_old_locale';
const String efNewLocale = 'ef_new_locale';
const String efIsDarkMode = "ef_is_dark_mode";
const String efThemeMode = "ef_theme_mode";
const String efThemeName = "ef_theme_name";
const String efOnPressed = 'ef_on_pressed';
const String efOnTextChanged = 'ef_on_text_changed';
const String efOnModeChanged = 'ef_on_mode_changed';
const String efOnThemeChanged = 'ef_on_theme_changed';
const String efOnExpansionChanged = 'ef_on_expansion_changed'; // LdFoldableContainer
const String efOnHeaderTap = 'ef_on_header_tap'; // LdFoldableContainer
const String efOnToggled = 'ef_on_toggled'; // LdCheckBox
const String efOnInfoTapped = 'ef_on_info_tapped'; // LdCheckBox


// LdTaggableMixin constants (cf) - Configuraci  general
const String cfId = 'cf_id'; // Identificador  nic (no sempre  s el tag)
const String cfTag = 'cf_tag'; // Tag per a debugging i identificaci .

// Model fields (mf) - Dades espec fiques dels models (l'estat que canvia)
const String mfTag = 'mf_tag'; // 'tag' com a camp de dades en alguns models.
const String mfTitle = 'mf_title'; // T tol del model (p.ex. P gina, AppBar si el t tol  s din mic)
const String mfSubTitle = 'mf_sub_title'; // Subt tol del model
const String mfCounter = 'mf_counter'; // Comptador
const String mfInitialText = "mf_initial_text"; // Text inicial (es carrega al model, pero  s config) - Revisar si cal aqu  o nom s cfInitialText
const String mfText = 'mf_text'; // Text actual (estat) d'un camp de text.
const String mfIsExpanded = 'mf_is_expanded'; // Estat expandit/col·lapsat de LdFoldableContainer
const String mfTitleKey = 'mf_title_key'; // Clau de t tol del model si el t tol  s una dada variable (no nom s UI config) - Revisar
const String mfSubtitleKey = 'mf_subtitle_key'; // Clau de subt tol del model - Revisar
const String mfIsChecked = 'mf_is_checked'; // <-- NOVA: Estat marcat/desmarcat de LdCheckBox


// Widget configuration fields (cf) - Configuraci  de widgets (visual, comportament)
const String cfIsVisible = 'cf_is_visible'; // Si el widget  s visible.
const String cfCanFocus = 'cf_can_focus'; // Si el widget pot rebre focus.
const String cfIsEnabled = 'cf_is_enabled'; // Si el widget est  actiu (interactiu).
const String cfLabel = 'cf_label'; // Text o clau de traducci  per a un label o bot .
const String cfHelpText = 'cf_help_text'; // Text d'ajuda.
const String cfErrorMessage = 'cf_error_message'; // Text d'error.
const String cfHasError = "cf_has_error"; // Indica si hi ha un error associat.
const String cfAllowNull = 'cf_allow_null'; // Si un camp permet valor nul.
const String cfInitialText = 'cf_initial_text'; // Text inicial d'un camp de text (config).

// LdButton constants (cf)
const String cfButtonType = 'cf_button_type'; // Tipus de bot  (elevated, filled, etc.).
const String cfPositionalArgs = 'cf_positional_args'; // Par metres posicionals per traducci .
const String cfNamedArgs = 'cf_named_args'; // Par metres nomenats per traducci .
const String cfIcon = 'cf_icon'; // Icona per a un bot  o un altre widget.
const String cfButtonStyle = 'cf_button_style'; // Estil visual del bot .

// LdLabel/LdText constants (cf) - Algunes ja definides a nivell general (cfLabel)
const String cfTextStyle = 'cf_text_style'; // Estil de text general.
const String cfOverflow = 'cf_overflow'; // Com gestionar el text si  s massa llarg.
const String cfTextAlign = 'cf_text_align'; // Alineaci  del text.
const String cfTextDirection = 'cf_text_direction'; // Direcci  del text.
const String cfLocale = 'cf_locale'; // Localitzaci  espec fica per al text.
const String cfSoftWrap = 'cf_soft_wrap'; // Si el text ha de fer salt de l nia.
const String cfTextWidthBasis = 'cf_text_width_basis';
const String cfTextHeightBehavior = 'cf_text_height_behavior';
const String cfSemanticLabel = 'cf_semantic_label';
const String cfSelectionColor = 'cf_selection_color';
const String cfStructStyle = 'cf_strut_style';
const String cfTextScaleFactor = 'cf_text_scale_factor'; // Deprecated
const String cfTextScaler = 'cf_text_scaler';
const String cfMaxLines = 'cf_max_lines'; // Nombre m xim de l nies.
// cfLabel ja definit.
const String cfLabelStyle = "cf_label_style"; // Estil espec fic per a LdLabel.
const String cfLabelTextAlign = "cf_label_text_align";
const String cfLabelOverflow = "cf_label_overflow";
const String cfLabelMaxLines = "cf_label_max_lines";
const String cfLabelSoftWrap = "cf_label_soft_wrap";
const String cfLabelPosArgs = "cf_label_pos_args"; // Arguments posicionals espec fics de LdLabel.
const String cfLabelNamedArgs = "cf_label_named_args"; // Arguments nomenats espec fics de LdLabel.

// LdScaffold constants (cf)
const String cfBackgroundColor = 'cf_background_color'; // Color de fons general.
const String cfAppBar = 'cf_app_bar'; // Widget AppBar.
const String cfBody = 'cf_body'; // Contingut principal del scaffold.
const String cfFloatingActionButton = 'cf_floating_action_button'; // FAB.
const String cfFloatingActionButtonLocation = 'cf_floating_action_button_location'; // Posici  del FAB.
const String cfFloatingActionButtonAnimator = 'cf_floating_action_button_animator'; // Animació del FAB.
const String cfPersistentFooterButtons = 'cf_persistent_footer_buttons'; // Botons al footer persistent.
const String cfDrawer = 'cf_drawer'; // Drawer (men lateral esquerre).
const String cfEndDrawer = 'cf_end_drawer'; // End Drawer (men lateral dret).
const String cfBottomNavigationBar = 'cf_bottom_navigation_bar'; // Barra de navegació inferior.
const String cfBottomSheet = 'cf_bottom_sheet'; // Bottom sheet persistent.
const String cfDrawerDragStartBehavior = 'cf_drawer_drag_start_behavior';
const String cfExtendBody = 'cf_extend_body';
const String cfExtendBodyBehindAppBar = 'cf_extend_body_behind_app_bar';
const String cfDrawerScrimColor = 'cf_drawer_scrim_color';
const String cfDrawerEdgeDragWidth = 'cf_drawer_edge_drag_width';
const String cfDrawerEnableOpenDragGesture = 'cf_drawer_enable_open_drag_gesture';
const String cfEndDrawerEnableOpenDragGesture = 'cf_end_drawer_enable_open_drag_gesture';
const String cfResizeToAvoidBottomInset = 'cf_resize_to_avoid_bottom_inset';

// LdAppBar constants (cf) - Algunes ja definides a nivell general (cfBackgroundColor)
// cfTitle ja definit com a widget.
const String cfTitle = 'cf_title'; // <-- Aquesta sembla duplicada/confusa amb cfTitleKey
const String cfTitleKey = 'cf_title_key'; // Clau de t tol (configuraci , pot ser mf si el t tol  s din mic al model)
const String cfSubTitleKey = 'cf_sub_title_key'; // Clau de subt tol.
const String cfLeading = 'cf_leading'; // Widget Leading a l'AppBar.
const String cfActions = 'cf_actions'; // Llista d'Actions a l'AppBar.
const String cfFlexibleSpace = 'cf_flexible_space'; // Flexible space a l'AppBar.
const String cfBottom = 'cf_bottom'; // Widget a la part inferior de l'AppBar (p.ex. TabBar).
const String cfElevation = 'cf_elevation'; // Ombra/elevaci  de l'AppBar.
const String cfScrolledUnderElevation = 'cf_scrolled_under_elevation';
const String cfNotificationPredicate = 'cf_notification_predicate';
const String cfShadowColor = 'cf_shadow_color';
const String cfSurfaceTintColor = 'cf_surface_tint_color';
const String cfForceElevated = 'cf_force_elevated';
const String cfForegroundColor = 'cf_foreground_color'; // Color dels elements (icones, text) a l'AppBar.
const String cfIconTheme = 'cf_icon_theme'; // Tema d'icones a l'AppBar.
const String cfActionsIconTheme = 'cf_actions_icon_theme'; // Tema d'icones per a les actions.
const String cfPrimary = 'cf_primary'; // Si l'AppBar  s la primary a la pantalla.
const String cfCenterTitle = 'cf_center_title'; // Centrar el t tol.
const String cfExcludeHeaderSemantics = 'cf_exclude_header_semantics';
const String cfTitleSpacing = 'cf_title_spacing';
const String cfToolbarOpacity = 'cf_toolbar_opacity';
const String cfBottomOpacity = 'cf_bottom_opacity';
const String cfToolbarHeight = 'cf_toolbar_height';
const String cfLeadingWidth = 'cf_leading_width';
const String cfToolbarTextStyle = 'cf_toolbar_text_style';
const String cfTitleTextStyle = 'cf_title_text_style';
const String cfSystemOverlayStyle = 'cf_system_overlay_style';
const String cfForceMaterialTransparency = 'cf_force_material_transparency';
const String cfClipBehavior = 'cf_clip_behavior';

// LdThemeSelector constants (cf)
const String cfCurrentTheme = 'cf_current_theme'; // Clau per al nom del tema actual (config/mf?)
const String cfDisplayMode = 'cf_display_mode'; // Mostrar selector de mode.
const String cfDisplayThemes = 'cf_display_themes'; // Mostrar selector de temes.

// LdThemeViewer constants (cf)
const String cfShowJson = 'cf_show_json'; // Mostrar la representaci  JSON del tema (si escau)
const String cfShowTextTheme = 'cf_show_text_theme'; // Mostrar la secci  TextTheme.
const String cfShowColorScheme = 'cf_show_color_scheme'; // Mostrar la secci  ColorScheme.
const String cfCompact = 'cf_compact'; // Mostrar en mode compacte.

// Constants espec fiques per a camps personalitzats - Revisar si s n cf o mf segons  s config o dada
const String cfArgs = 'cf_args'; // Arguments generals per a un widget/model
const String mfArgs = 'mf_args'; // Arguments que s n part de les dades del model

// Constants espec fiques pels temes.
const String themeSabina  = "ThemeSabina";
const String themeNatura  = "ThemeNatura";
const String themeFire    = "ThemeFire";
const String themeNight   = "ThemeNight";
const String themeCustom1 = "ThemeCustom1";
const String themeCustom2 = "ThemeCustom2";
const String themeDexeusClear  = "ThemeDexeusClear";
const String themeDexeusDark   = "ThemeDexeusDark";

const Strings lstThemes = [   themeSabina,   themeNatura,   themeFire,   themeNight,   themeCustom1,   themeCustom2, ]; // Llista m s antiga dels noms de tema

// Constants espec fiques de configuraci  inicial - Revisar si s n cf o mf
const String mfInitialMode  = 'mfInitialMode'; // Mode de tema inicial (config/mf?)
const String mfInitialTheme = 'mfInitialTheme'; // Nom de tema inicial (config/mf?)


// Constants per LdFoldableContainer (cf)
const String cfHeader = 'cf_header'; // Widget per a la cap alera personalitzada.
const String cfContent = 'cf_content'; // Widget per al contingut plegable.
// cfIsExpanded -> Ja existeix mfIsExpanded per l'estat al model. Aquesta podria ser una configuració inicial.
const String cfInitialExpanded = 'cf_initial_expanded'; // Configuraci  de l'estat inicial expandit/col·lapsat.

const String cfHeaderHeight = 'cf_header_height'; // Al ada de la cap alera.
const String cfHeaderBackgroundColor = 'cf_header_background_color'; // Color de fons de la cap alera.
const String cfContentBackgroundColor = 'cf_content_background_color'; // Color de fons del contingut.
const String cfHeaderActions = 'cf_header_actions'; // Widgets per a les accions de la cap alera.
const String cfTitleStyle = 'cf_title_style'; // Estil del t tol a la cap alera.
const String cfSubtitleStyle = 'cf_subtitle_style'; // Estil del subt tol a la cap alera.
const String cfBorderRadius = 'cf_border_radius'; // Radi de les vores.
const String cfBorderColor = 'cf_border_color'; // Color de la vora.
const String cfBorderWidth = 'cf_border_width'; // Gruix de la vora.
const String cfShowBorder = 'cf_show_border'; // Mostrar o no la vora.
const String cfExpansionIcon = 'cf_expansion_icon'; // Icona per a l'estat expandit.
const String cfCollapsedIcon = 'cf_collapsed_icon'; // Icona per a l'estat col·lapsat.
const String cfHeaderPadding = 'cf_header_padding'; // Padding de la cap alera.
const String cfContentPadding = 'cf_content_padding'; // Padding del contingut.
const String cfEnableInteraction = 'cf_enable_interaction'; // Habilitar interacci  (clic) a la cap alera.
const String cfAnimationDuration = 'cf_animation_duration'; // Duraci  de l'animaci .

// Constants per LdFoldableContainer (mf) - Ja definides
// mfIsExpanded ja definit com a estat.
// mfTitleKey -> Clau de t tol del model (si el t tol  s dada variable) - Revisar
// mfSubtitleKey -> Clau de subt tol del model - Revisar

// Constants per LdFoldableContainer (ef) - Ja definides
// efOnExpansionChanged ja definit.
// efOnHeaderTap ja definit.


// Constants per LdCheckBox (cf) - NOU
// cfLabel ja definit.
const String cfLeadingIcon = 'cf_leading_icon'; // <-- NOVA: Icona al principi del label.
const String cfCheckPosition = 'cf_check_position'; // <-- NOVA: Posici  del check (esquerra/dreta).
const String cfInfoTextKey = 'cf_info_text_key'; // <-- NOVA: Clau per al text d'informaci .
const String cfShowInfoIcon = 'cf_show_info_icon'; // <-- NOVA: Mostrar icona d'informaci .
// cfIsChecked -> Ja existeix mfIsChecked per l'estat al model. Aquesta podria ser una configuració inicial.
const String cfInitialChecked = 'cf_initial_checked'; // <-- NOVA: Configuració de l'estat inicial marcat/desmarcat.

