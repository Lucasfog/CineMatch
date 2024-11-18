import 'package:cine_match/api/api.dart';
import 'package:cine_match/models/input_controller_model.dart';
import 'package:cine_match/screens/login_screen.dart';
import 'package:cine_match/screens/validator.dart';
import 'package:cine_match/widgets/input_text_field.dart';
import 'package:flutter/material.dart';

class RecoveryScreen extends StatefulWidget {
  const RecoveryScreen({super.key});

  @override
  State<RecoveryScreen> createState() => _RecoveryScreenState();
}

class _RecoveryScreenState extends State<RecoveryScreen> {
  final InputControllerModel emailController = InputControllerModel();
  final Api apiService = Api();

  @override
  void initState() {
    super.initState();

    emailController.focusNode.addListener(() {
      setState(() {
        emailController.labelColor = emailController.focusNode.hasFocus
            ? emailController.labelColorFocus
            : emailController.labelColorNoFocus;
      });
    });
  }

  // Função para solicitar recuperação de senha
  void solicitarRecuperacaoSenha() async {
    final email = emailController.textController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, insira um email válido.")),
      );
      return;
    }

    try {
      final response = await apiService.recoverPassword(email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Código enviado: ${response.body}")),
      );

      // Redireciona para a tela de validação de código, passando o email como parâmetro
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ValidationCodeScreen(email: email),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/cinematch.png'),
                const Text(
                  'Para recuperar a senha de acesso, digite o endereço de e-mail associado à sua conta.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                InputTextField(
                  text: 'Email',
                  textController: emailController.textController,
                  focusNode: emailController.focusNode,
                  labelColor: emailController.labelColor,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: solicitarRecuperacaoSenha,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.black,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 150, vertical: 20),
                  ),
                  child: const Text('Recuperar'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Lembrou sua senha?'),
                TextButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  ),
                  child: const Text(
                    'Fazer login',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
