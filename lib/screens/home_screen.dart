import 'package:flutter/material.dart';
import 'package:gen_pass_w/notifiers/theme_notifier.dart';
import 'package:gen_pass_w/screens/generator_screen.dart';
import 'package:gen_pass_w/screens/tester_screen.dart';
import 'package:provider/provider.dart';

// HomeScreen est le widget principal de l'application, agissant comme un "shell" ou un conteneur.
// Son rôle est de gérer la navigation entre les différents écrans principaux
// à l'aide d'une barre de navigation inférieure (BottomNavigationBar).
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // _selectedIndex conserve l'index de l'onglet actuellement sélectionné.
  int _selectedIndex = 0;

  // _widgetOptions est une liste statique des écrans principaux de l'application.
  // L'index de cette liste correspond à l'index de la BottomNavigationBar.
  static const List<Widget> _widgetOptions = <Widget>[
    GeneratorScreen(),
    TesterScreen(),
  ];

  // _onItemTapped est appelée lorsque l'utilisateur appuie sur un onglet de la barre de navigation.
  // Elle met à jour l'état avec le nouvel index, ce qui provoque la reconstruction de l'interface
  // pour afficher le nouvel écran.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Le titre de l'AppBar change dynamiquement en fonction de l'onglet sélectionné.
        title: Text(_selectedIndex == 0 ? 'Générateur' : 'Testeur de Force'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // Ce bouton permet de basculer entre le thème clair et le thème sombre.
          IconButton(
            icon: Icon(
              // L'icône change en fonction du thème actuel.
              Provider.of<ThemeNotifier>(context).themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              // On appelle la méthode toggleTheme du Notifier.
              // `listen: false` est important ici car nous sommes dans une méthode d'action
              // et nous ne voulons pas que ce widget se reconstruise à chaque changement de thème.
              Provider.of<ThemeNotifier>(context, listen: false).toggleTheme();
            },
            tooltip: 'Changer de thème',
          ),
        ],
      ),
      // Le corps du Scaffold affiche le widget de la page sélectionnée.
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      // La barre de navigation principale de l'application.
      bottomNavigationBar: BottomNavigationBar(
        // Définit les boutons (onglets) de la barre de navigation.
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.password),
            label: 'Générateur',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shield_outlined),
            label: 'Testeur',
          ),
        ],
        // Met en surbrillance l'onglet actif.
        currentIndex: _selectedIndex,
        // Appelle _onItemTapped lorsque l'utilisateur sélectionne un onglet.
        onTap: _onItemTapped,
      ),
    );
  }
}
