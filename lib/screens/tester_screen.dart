import 'package:flutter/material.dart';
import 'package:gen_pass_w/services/password_generator.dart';
import 'package:gen_pass_w/widgets/strength_indicator.dart';

// TesterScreen est l'écran qui permet aux utilisateurs de tester la force
// d'un mot de passe qu'ils saisissent manuellement.
class TesterScreen extends StatefulWidget {
  const TesterScreen({super.key});

  @override
  State<TesterScreen> createState() => _TesterScreenState();
}

class _TesterScreenState extends State<TesterScreen> {
  final _textController = TextEditingController();
  int _strength = 0;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_checkPassword);
  }

  void _checkPassword() {
    final password = _textController.text;
    setState(() {
      _strength = PasswordGenerator.checkPasswordStrength(password);
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const SizedBox(height: 20),
        TextField(
          controller: _textController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Entrez un mot de passe à tester...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
              ),
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _textController.clear();
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        StrengthIndicator(strength: _strength),
        const SizedBox(height: 30),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: _buildStrengthTips(),
        ),
      ],
    );
  }

  Widget _buildStrengthTips() {
    if (_textController.text.isEmpty) {
      return const SizedBox(key: ValueKey('empty'));
    }

    final tips = <String>[];
    if (!RegExp(r'[a-z]').hasMatch(_textController.text)) {
      tips.add('Ajoutez des lettres minuscules.');
    }
    if (!RegExp(r'[A-Z]').hasMatch(_textController.text)) {
      tips.add('Ajoutez des lettres majuscules.');
    }
    if (!RegExp(r'[0-9]').hasMatch(_textController.text)) {
      tips.add('Ajoutez des chiffres.');
    }
    if (!RegExp(r'[!@#\$%^&*()-_=+]').hasMatch(_textController.text)) {
      tips.add('Ajoutez des caractères spéciaux.');
    }
    if (_textController.text.length < 12) {
      tips.add('Utilisez au moins 12 caractères.');
    }

    if (tips.isEmpty) {
      return Card(
        key: const ValueKey('success'),
        color: Colors.green.withOpacity(0.8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
               Icon(Icons.check_circle, color: Colors.white),
               SizedBox(width: 10),
               Text(
                'Excellent ! Votre mot de passe est robuste.',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      key: const ValueKey('tips'),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Conseils pour améliorer :',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...tips.map((tip) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_outline, color: Theme.of(context).colorScheme.secondary, size: 18),
                      const SizedBox(width: 10),
                      Expanded(child: Text(tip)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
