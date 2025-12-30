import 'package:flutter/material.dart';
import 'package:gen_pass_w/services/password_generator.dart';
import 'package:flutter/services.dart';
import 'package:gen_pass_w/widgets/strength_indicator.dart';

// Énumération pour définir les deux modes de génération disponibles.
enum GeneratorMode { password, passphrase }

// GeneratorScreen est l'écran dédié à la génération de mots de passe et de passphrases.
class GeneratorScreen extends StatefulWidget {
  const GeneratorScreen({super.key});

  @override
  State<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> {
  // --- VARIABLES D'ÉTAT ---

  GeneratorMode _mode = GeneratorMode.password;
  String _generatedValue = '';
  int _passwordStrength = 0;

  // Options pour le générateur de mot de passe.
  double _passwordLength = 16;
  bool _includeUppercase = true;
  bool _includeLowercase = true;
  bool _includeNumbers = true;
  bool _includeSpecialChars = true;

  // Options pour le générateur de passphrase.
  double _wordCount = 4;
  String _separator = '-';

  @override
  void initState() {
    super.initState();
    _generate();
  }

  // --- LOGIQUE MÉTIER ---

  void _generate() {
    setState(() {
      if (_mode == GeneratorMode.password) {
        _generatedValue = PasswordGenerator.generatePassword(
          length: _passwordLength.toInt(),
          includeUppercase: _includeUppercase,
          includeLowercase: _includeLowercase,
          includeNumbers: _includeNumbers,
          includeSpecialChars: _includeSpecialChars,
        );
        _passwordStrength = PasswordGenerator.checkPasswordStrength(_generatedValue);
      } else {
        _generatedValue = PasswordGenerator.generatePassphrase(
          wordCount: _wordCount.toInt(),
          separator: _separator,
        );
        _passwordStrength = 0;
      }
    });
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _generatedValue));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${_mode == GeneratorMode.password ? 'Mot de passe' : 'Passphrase'}" copié !'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // --- CONSTRUCTION DE L'INTERFACE ---

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: [
        const SizedBox(height: 10),
        SegmentedButton<GeneratorMode>(
          segments: const [
            ButtonSegment(
              value: GeneratorMode.password,
              label: Text('Mot de passe'),
              icon: Icon(Icons.password),
            ),
            ButtonSegment(
              value: GeneratorMode.passphrase,
              label: Text('Passphrase'),
              icon: Icon(Icons.short_text),
            ),
          ],
          selected: {_mode},
          onSelectionChanged: (Set<GeneratorMode> newSelection) {
            setState(() {
              _mode = newSelection.first;
              _generate();
            });
          },
        ),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: SelectableText(
                      _generatedValue,
                      key: ValueKey<String>(_generatedValue),
                      style: TextStyle(
                        fontSize: _mode == GeneratorMode.password ? 32 : 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, size: 28),
                  onPressed: _copyToClipboard,
                  tooltip: 'Copier',
                ),
              ],
            ),
          ),
        ),
        if (_mode == GeneratorMode.password) ...[
          const SizedBox(height: 10),
          StrengthIndicator(strength: _passwordStrength),
        ],
        const SizedBox(height: 30),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: _mode == GeneratorMode.password
              ? _buildPasswordOptions()
              : _buildPassphraseOptions(),
        ),
        const SizedBox(height: 30),
        ElevatedButton.icon(
          onPressed: _generate,
          icon: const Icon(Icons.refresh),
          label: const Text('Générer'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: Theme.of(context).colorScheme.secondary,
            foregroundColor: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // --- WIDGETS HELPER ---

  Widget _buildPasswordOptions() {
    return Column(
      key: const ValueKey('password_options'),
      children: [
        _buildSectionCard(
          child: _buildOptionRow(
            icon: Icons.linear_scale,
            title: 'Longueur: ${_passwordLength.toInt()}',
            control: Slider(
              value: _passwordLength,
              min: 4,
              max: 32,
              divisions: 28,
              label: _passwordLength.toInt().toString(),
              onChanged: (double value) {
                setState(() {
                  _passwordLength = value;
                });
              },
              onChangeEnd: (double value) => _generate(),
            ),
          ),
        ),
        const SizedBox(height: 10),
        _buildSectionCard(
          child: Column(
            children: [
              _buildOptionRow(
                icon: Icons.text_fields,
                title: 'Lettres majuscules',
                control: Switch(
                  value: _includeUppercase,
                  onChanged: (bool value) {
                    setState(() {
                      _includeUppercase = value;
                      _generate();
                    });
                  },
                ),
              ),
              _buildOptionRow(
                icon: Icons.text_fields_outlined,
                title: 'Lettres minuscules',
                control: Switch(
                  value: _includeLowercase,
                  onChanged: (bool value) {
                    setState(() {
                      _includeLowercase = value;
                      _generate();
                    });
                  },
                ),
              ),
              _buildOptionRow(
                icon: Icons.looks_one,
                title: 'Chiffres',
                control: Switch(
                  value: _includeNumbers,
                  onChanged: (bool value) {
                    setState(() {
                      _includeNumbers = value;
                      _generate();
                    });
                  },
                ),
              ),
              _buildOptionRow(
                icon: Icons.star,
                title: 'Caractères spéciaux',
                control: Switch(
                  value: _includeSpecialChars,
                  onChanged: (bool value) {
                    setState(() {
                      _includeSpecialChars = value;
                      _generate();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPassphraseOptions() {
    return Column(
      key: const ValueKey('passphrase_options'),
      children: [
        _buildSectionCard(
          child: Column(
            children: [
              _buildOptionRow(
                icon: Icons.linear_scale,
                title: 'Nombre de mots: ${_wordCount.toInt()}',
                control: Slider(
                  value: _wordCount,
                  min: 3,
                  max: 8,
                  divisions: 5,
                  label: _wordCount.toInt().toString(),
                  onChanged: (double value) {
                    setState(() {
                      _wordCount = value;
                    });
                  },
                  onChangeEnd: (double value) => _generate(),
                ),
              ),
              _buildOptionRow(
                icon: Icons.space_bar,
                title: 'Séparateur',
                control: SizedBox(
                  width: 50,
                  child: TextFormField(
                    initialValue: _separator,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    onChanged: (value) {
                      setState(() {
                        _separator = value;
                      });
                      _generate();
                    },
                    decoration: const InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({required Widget child}) {
    return Card(child: child);
  }

  Widget _buildOptionRow({
    required IconData icon,
    required String title,
    required Widget control,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          control,
        ],
      ),
    );
  }
}
