// map_fields.dart
// Constants per als noms dels camps utilitzats en mapes.
// Created: 2025/04/29 dt. JIQ
// Updated: 2025/05/09 dv. CLA - Ampliació de camps i millora de nomenclatura.

//============================================================
// CAMPS PER A EVENTS (ef = Event Field)
// Per a les dades que es transmeten amb events
//============================================================

/// Codi de l'idioma antic
const String efOldLocale = 'efOldLocale';

/// Codi de l'idioma nou
const String efNewLocale = 'efNewLocale';

/// Flag que indica si el tema és fosc
const String efIsDarkMode = 'efIsDarkMode';

/// Mode del tema (system, light, dark)
const String efThemeMode = 'efThemeMode';

/// Estat del cicle de vida de l'aplicació
const String efLifecycleState = 'efLifecycleState';

/// Nom del tema (per a events de canvi de tema)
const String efThemeName = 'efThemeName';

//============================================================
// CAMPS DE CONTROLADOR (cf = Controller Field)
// Per a propietats que controlen el comportament del widget
//============================================================

/// Camp per a l'estat de visibilitat d'un widget
const String cfIsVisible = "cfIsVisible";

/// Camp per a l'estat de focus d'un widget
const String cfCanFocus = "cfCanFocus";

/// Camp per a l'estat d'activació d'un widget
const String cfIsEnabled = "cfIsEnabled";

/// Camp per al callback quan canvia el text en un camp d'edició
const String cfOnTextChanged = "cfOnTextChanged";

/// Camp per al tag d'identificació d'un component
const String cfTag = "cfTag";

//============================================================
// CAMPS DE MODEL (mf = Model Field)
// Per a dades que representen l'estat d'un model
//============================================================

/// Camp per al tag d'un model
const String mfTag = 'mfTag';

/// Camp per al títol d'un model
const String mfTitle = 'mfTitle';

/// Camp per al subtítol d'un model
const String mfSubTitle = 'mfSubTitle';

/// Camp per al text d'un model
const String mfText = 'mfText';

/// Camp per a les dades d'una icona d'un model
const String mfIconData = "mfIconData";

/// Camp per a un comptador
const String mfCounter = "mfCounter";

/// Camp per al text inicial d'un camp d'edició
const String mfInitialText = 'mfInitialText';

/// Camp per a l'etiqueta d'un camp d'edició
const String mfLabel = 'mfLabel';

/// Camp per al text d'ajuda d'un camp d'edició
const String mfHelpText = 'mfHelpText';

/// Camp per al missatge d'error d'un camp d'edició
const String mfErrorMessage = 'mfErrorMessage';

/// Camp per a l'estat d'error d'un camp d'edició
const String mfHasError = 'mfHasError';

/// Camp per indicar si un camp pot ser nul
const String mfAllowNull = 'mfAllowNull';