import 'dart:math';
import 'package:gen_pass_w/services/wordlist.dart';

/// La classe PasswordGenerator fournit des méthodes statiques utilitaires
/// pour la génération et l'évaluation de mots de passe et de passphrases.
/// Toutes les méthodes sont pures et ne dépendent que de leurs arguments d'entrée.
class PasswordGenerator {
  /// Génère un mot de passe aléatoire basé sur un ensemble de critères.
  ///
  /// [length] : La longueur souhaitée pour le mot de passe.
  /// [includeLowercase] : Inclure des lettres minuscules.
  /// [includeUppercase] : Inclure des lettres majuscules.
  /// [includeNumbers] : Inclure des chiffres.
  /// [includeSpecialChars] : Inclure des caractères spéciaux.
  static String generatePassword(
      {bool includeLowercase = true,
      bool includeUppercase = true,
      bool includeNumbers = true,
      bool includeSpecialChars = true,
      int length = 12}) {
    if (length <= 0) {
      return '';
    }

    // On définit les jeux de caractères possibles.
    const String lowercaseChars = 'abcdefghijklmnopqrstuvwxyz';
    const String uppercaseChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String numberChars = '0123456789';
    const String specialChars = r'!@#$%^&*()-_=+';

    // On construit la chaîne de tous les caractères autorisés en fonction des options.
    String allChars = '';
    if (includeLowercase) allChars += lowercaseChars;
    if (includeUppercase) allChars += uppercaseChars;
    if (includeNumbers) allChars += numberChars;
    if (includeSpecialChars) allChars += specialChars;

    // Si aucun jeu de caractères n'est sélectionné, on ne peut pas générer de mot de passe.
    if (allChars.isEmpty) {
      return '';
    }

    // On utilise Random.secure() pour une génération de nombres aléatoires
    // de haute qualité, essentielle pour la sécurité.
    final random = Random.secure();
    // On génère une liste de 'length' caractères en choisissant à chaque fois
    // un caractère au hasard dans 'allChars', puis on les joint pour former la chaîne finale.
    return List.generate(length, (index) => allChars[random.nextInt(allChars.length)]).join();
  }

  /// Évalue la force d'un mot de passe et retourne un score entier.
  /// Le score varie de 0 (très faible) à 4 (très fort).
  static int checkPasswordStrength(String password) {
    if (password.isEmpty) return 0;

    int score = 0;

    // Le score augmente pour chaque type de caractère présent.
    // On utilise des expressions régulières pour vérifier la présence de chaque type.
    if (RegExp(r'[a-z]').hasMatch(password)) score++; // Contient des minuscules
    if (RegExp(r'[A-Z]').hasMatch(password)) score++; // Contient des majuscules
    if (RegExp(r'[0-9]').hasMatch(password)) score++; // Contient des chiffres
    if (RegExp(r'[!@#\$%^&*()-_=+]').hasMatch(password)) score++; // Contient des caractères spéciaux

    // Un bonus est accordé si la longueur dépasse un certain seuil.
    if (password.length > 12) {
      score++;
    }

    // On s'assure que le score ne dépasse pas 4, pour correspondre aux 5 niveaux
    // de force définis dans l'interface utilisateur (StrengthIndicator).
    return score.clamp(0, 4);
  }

  /// Génère une phrase de passe en assemblant des mots aléatoires.
  ///
  /// [wordCount] : Le nombre de mots à inclure dans la phrase.
  /// [separator] : Le caractère utilisé pour séparer les mots.
  static String generatePassphrase({
    int wordCount = 4,
    String separator = '-',
  }) {
    if (wordCount <= 0) {
      return '';
    }

    final random = Random.secure();
    // On génère une liste de 'wordCount' mots en choisissant à chaque fois
    // un mot au hasard dans la wordList.
    final words = List.generate(
      wordCount,
      (_) => wordList[random.nextInt(wordList.length)],
    );
    // On assemble les mots en une seule chaîne avec le séparateur.
    return words.join(separator);
  }
}
