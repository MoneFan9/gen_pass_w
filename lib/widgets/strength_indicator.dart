import 'package:flutter/material.dart';

/// Un widget qui affiche une représentation visuelle de la force d'un mot de passe.
/// Il se compose d'une barre de progression colorée et d'un libellé textuel.
class StrengthIndicator extends StatelessWidget {
  /// Le score de force, attendu entre 0 et 4.
  /// 0: Très faible, 1: Faible, 2: Moyen, 3: Fort, 4: Très Fort.
  final int strength;

  const StrengthIndicator({super.key, required this.strength});

  @override
  Widget build(BuildContext context) {
    // Liste des couleurs correspondant à chaque niveau de force.
    final colors = [
      Colors.grey.shade400, // 0: Très Faible (ou non applicable)
      Colors.red.shade400, // 1: Faible
      Colors.orange.shade400, // 2: Moyen
      Colors.blue.shade400, // 3: Fort
      Colors.green.shade400, // 4: Très Fort
    ];

    // Liste des libellés textuels correspondant à chaque niveau de force.
    final labels = [
      'Très Faible',
      'Faible',
      'Moyen',
      'Fort',
      'Très Fort',
    ];

    // On sélectionne la couleur et le libellé en fonction du score de force.
    // `.clamp()` est une sécurité pour éviter une erreur si `strength` est en dehors des bornes attendues.
    final Color barColor = colors[strength.clamp(0, colors.length - 1)];
    final String label = labels[strength.clamp(0, labels.length - 1)];

    // Le widget est une colonne contenant la barre de progression et le libellé.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // La barre de progression est une ligne de 4 segments.
        Row(
          children: List.generate(4, (index) {
            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2.0),
                height: 8,
                decoration: BoxDecoration(
                  // Le segment est coloré si son index est inférieur au score de force.
                  // Sinon, il reste gris pour montrer la progression possible.
                  color: index < strength ? barColor : Colors.grey.shade700,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        // On n'affiche le libellé que si le mot de passe a une force minimale (score > 0).
        if (strength > 0)
          Text(
            'Force: $label',
            style: TextStyle(
              color: barColor, // La couleur du texte correspond à celle de la barre.
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }
}
