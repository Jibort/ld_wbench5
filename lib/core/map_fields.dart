// lib/core/map_fields.dart
// Constants per als noms dels camps utilitzats en mapes.
// Created: 2025/04/29 dt. JIQ
// Updated: 2025/05/09 dv. CLA - Ampliació de camps i millora de nomenclatura.
// Updated: 2025/05/11 dg. CLA - Actualització de constants per diferenciar correctament mf/cf/ef
// Updated: 2025/05/12 dt. CLA - Afegir constants que falten per completar l'arquitectura

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

// LdTaggableMixin constants (cf) - Configuració general
const String cfId = 'cf_id';
const String cfTag = 'cf_tag';

// Model fields (mf) - Dades específiques dels models
const String mfTag = 'mf_tag';  // 'tag' com a camp de dades.
const String mfTitle = 'mf_title';
const String mfSubTitle = 'mf_sub_title';
const String mfCounter = 'mf_counter';
const String mfInitialText = "mf_initial_text";
const String mfText = 'mf_text';

// Widget configuration fields (cf) - Configuració de widgets
const String cfIsVisible = 'cf_is_visible';
const String cfCanFocus = 'cf_can_focus';
const String cfIsEnabled = 'cf_is_enabled';
const String cfLabel = 'cf_label';
const String cfHelpText = 'cf_help_text';
const String cfErrorMessage = 'cf_error_message';
const String cfHasError = "cf_has_error";
const String cfAllowNull = 'cf_allow_null';

// LdButton constants (cf)
const String cfButtonType = 'cf_button_type';  // Tipus de botó (elevated, filled, etc.)
const String cfPositionalArgs = 'cf_positional_args';  // Paràmetres posicionals per traducció
const String cfNamedArgs = 'cf_named_args';  // Paràmetres nomenats per traducció
const String cfIcon = 'cf_icon';
const String cfButtonStyle = 'cf_button_style';

// LdTextField constants (cf)
// cfLabel ja definit
// cfHelpText ja definit
// cfErrorMessage ja definit
// cfHasError ja definit
// cfAllowNull ja definit

// LdLabel/LdText constants (cf)
const String cfTextStyle = 'cf_text_style';
const String cfOverflow = 'cf_overflow';
const String cfTextAlign = 'cf_text_align';
const String cfTextDirection = 'cf_text_direction';
const String cfLocale = 'cf_locale';
const String cfSoftWrap = 'cf_soft_wrap';
const String cfTextWidthBasis = 'cf_text_width_basis';
const String cfTextHeightBehavior = 'cf_text_height_behavior';
const String cfSemanticLabel = 'cf_semantic_label';
const String cfSelectionColor = 'cf_selection_color';
const String cfStructStyle = 'cf_strut_style';
const String cfTextScaleFactor = 'cf_text_scale_factor';
const String cfTextScaler = 'cf_text_scaler';
const String cfMaxLines = 'cf_max_lines';
const String cfLabelStyle = "cf_label_style";
const String cfLabelTextAlign = "cf_label_text_align";
const String cfLabelOverflow = "cf_label_overflow";
const String cfLabelMaxLines = "cf_label_max_lines";
const String cfLabelSoftWrap = "cf_label_soft_wrap";
const String cfLabelPosArgs = "cf_label_pos_args";
const String cfLabelNamedArgs = "cf_label_named_args";

// LdScaffold constants (cf)
const String cfBackgroundColor = 'cf_background_color';
const String cfAppBar = 'cf_app_bar';
const String cfBody = 'cf_body';
const String cfFloatingActionButton = 'cf_floating_action_button';
const String cfFloatingActionButtonLocation = 'cf_floating_action_button_location';
const String cfFloatingActionButtonAnimator = 'cf_floating_action_button_animator';
const String cfPersistentFooterButtons = 'cf_persistent_footer_buttons';
const String cfDrawer = 'cf_drawer';
const String cfEndDrawer = 'cf_end_drawer';
const String cfBottomNavigationBar = 'cf_bottom_navigation_bar';
const String cfBottomSheet = 'cf_bottom_sheet';
const String cfDrawerDragStartBehavior = 'cf_drawer_drag_start_behavior';
const String cfExtendBody = 'cf_extend_body';
const String cfExtendBodyBehindAppBar = 'cf_extend_body_behind_app_bar';
const String cfDrawerScrimColor = 'cf_drawer_scrim_color';
const String cfDrawerEdgeDragWidth = 'cf_drawer_edge_drag_width';
const String cfDrawerEnableOpenDragGesture = 'cf_drawer_enable_open_drag_gesture';
const String cfEndDrawerEnableOpenDragGesture = 'cf_end_drawer_enable_open_drag_gesture';
const String cfResizeToAvoidBottomInset = 'cf_resize_to_avoid_bottom_inset';

// LdAppBar constants (cf)
const String cfTitle = 'cf_title';           // Widget Title (para AppBar)
const String cfTitleKey = 'cf_title_key';    // Clau de títol (para Model)
const String cfSubTitleKey = 'cf_sub_title_key';  // Clau de subtítol (para Model)
const String cfLeading = 'cf_leading';
const String cfActions = 'cf_actions';
const String cfFlexibleSpace = 'cf_flexible_space';
const String cfBottom = 'cf_bottom';
const String cfElevation = 'cf_elevation';
const String cfScrolledUnderElevation = 'cf_scrolled_under_elevation';
const String cfNotificationPredicate = 'cf_notification_predicate';
const String cfShadowColor = 'cf_shadow_color';
const String cfSurfaceTintColor = 'cf_surface_tint_color';
const String cfForceElevated = 'cf_force_elevated';
const String cfForegroundColor = 'cf_foreground_color';
const String cfIconTheme = 'cf_icon_theme';
const String cfActionsIconTheme = 'cf_actions_icon_theme';
const String cfPrimary = 'cf_primary';
const String cfCenterTitle = 'cf_center_title';
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
const String cfCurrentTheme = 'cf_current_theme';
const String cfDisplayMode = 'cf_display_mode';
const String cfDisplayThemes = 'cf_display_themes';

// LdThemeViewer constants (cf)
const String cfShowJson = 'cf_show_json';
const String cfShowTextTheme = 'cf_show_text_theme';
const String cfShowColorScheme = 'cf_show_color_scheme';
const String cfCompact = 'cf_compact';

// Constants específiques per a camps personalitzats
const String cfArgs = 'cf_args';
const String mfArgs = 'mf_args';

// Constants específiques pels temes.
const String themeSabina  = "ThemeSabina";
const String themeNatura  = "ThemeNatura";
const String themeFire    = "ThemeFire";
const String themeNight   = "ThemeNight";
const String themeCustom1 = "ThemeCustom1";
const String themeCustom2 = "ThemeCustom2";

const Strings lstThemes = [
  themeSabina,
  themeNatura,
  themeFire,
  themeNight,
  themeCustom1,
  themeCustom2,
];
