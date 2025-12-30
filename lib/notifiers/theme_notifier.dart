import 'package:flutter/material.dart';

/// Un `ChangeNotifier` pour gérer l'état du thème de l'application (clair ou sombre).
///
/// En héritant de `ChangeNotifier`, cette classe peut notifier ses auditeurs
/// (les widgets qui l'écoutent) lorsqu'une de ses propriétés change,
/// leur permettant de se reconstruire avec le nouvel état.
class ThemeNotifier extends ChangeNotifier {
  // _themeMode stocke l'état actuel du thème. Il est privé pour
  // s'assurer qu'il n'est modifié que via les méthodes de cette classe.
  ThemeMode _themeMode = ThemeMode.dark;

  // Un getter public pour permettre aux autres parties de l'application de lire
  // l'état actuel du thème sans pouvoir le modifier directement.
  ThemeMode get themeMode => _themeMode;

  /// Bascule le thème entre le mode sombre et le mode clair.
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    // notifyListeners() est la méthode clé de ChangeNotifier.
    // Elle avertit tous les widgets qui écoutent ce notifier qu'un changement
    // a eu lieu, afin qu'ils puissent se reconstruire pour refléter le nouveau thème.
    notifyListeners();
  }
}
