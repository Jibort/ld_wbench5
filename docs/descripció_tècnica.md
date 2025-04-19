# Descripció tècnica de classes

## Interfície 'LdDisposableIntf'
* <u>Localització</u>: lib/03_core/interfaces/ld_disposable_intf.dart
* <u>Descripció</u>: Interfície per a les classes que requereixen de la implementació del mètode 'dispose()'.

| Tipus | Element | Descripció |
| :---- | :------ | :--------- |
| Abstracta | void **dispose**() | Allibera els recursos fets servir per la classe. |

## Mixin 'LdTagMixin'
* <u>Localització</u>: lib/03_core/mixin/ld_tag_mixin.dart
* <u>Descripció</u>: Mixin per a la gestió dels tag únic de cada instància de classe.

| Tipus | Element | Descripció |
| :---- | :------ | :--------- |
| Getter | String get **tag**    | Retorna el _tag_ únic de l'objecte. |
| Setter | set **tag** (String _pTag_) | Estableix el tag únic de l'objecte. |
| Abstracta | String **baseTag**() | Retorna la base del tag a fer servir en cas que no es proporcioni cap. |

## Classe 'LdTagBuilder'
* <u>Localització</u>: lib/03_core/ld_tag_builder.dart
* <u>Descripció</u>: Responsable de formar tags únics correctes per a les instàncies de les classes.

| Tipus | Element | Descripció |
| :---- | :------ | :--------- |
| Estàtic | static String **newViewTag**(String pTag) | Retorna el següent tag únic per a vistes. |
| Estàtic | static String **newWidgetTag**(String pTag) | Retorna el següent tag únic per a widgets. |
| Estàtic | static String **newModelTag**(String pTag) | Retorna el següent tag únic per a models. |
| Estàtic | static String **newCtrlTag**(String pTag) | Retorna el següent tag únic per a controladors. |

## Classe 'LdMap<T>'
* <u>Localització</u>: lib/10_tools/ld_map.dart
* <u>Descripció</u>: Generalització d'un mapa amb clau String i valor del tipus especificat 'T'.

| Tipus | Element | Descripció |
| :---- | :------ | :--------- |
| @map | @ T? operator **[]**(Object? key) | Equivalent a l'operador '[]' de la classe _map_. |
| @map | @ operator **[]=**(String key, T value) | Equivalent a l'operador '[]=' de la classe _map_. |
| @map | @ **addAll**(Map<String, T> other) | Equivalent al mètode _addAll()_ de la classe _map_. |
| Funció | LdMap<T> **addAllAndBack**(Map<String, T> other) | Equivalent a addAll() però retornant la instància de _LdMap_. |
| @map | @ **addEntries**(Iterable<MapEntry<String, T>> newEntries) | Equivalent al mètode _addEntries()_ de la classe _map_. |
