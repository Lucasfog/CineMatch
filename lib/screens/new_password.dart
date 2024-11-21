import 'package:flutter/material.dart';
import 'package:cine_match/api/api.dart';
import 'package:cine_match/widgets/input_text_field.dart';
import 'package:cine_match/screens/login_screen.dart';
import 'package:cine_match/models/input_controller_model.dart';

class NewPasswordScreen extends StatefulWidget {
  final String email;

  const NewPasswordScreen({super.key, required this.email});

  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final InputControllerModel newPasswordController = InputControllerModel();
  final Api apiService = Api();

  @override
  void initState() {
    super.initState();

    newPasswordController.focusNode.addListener(() {
      setState(() {
        newPasswordController.labelColor =
            newPasswordController.focusNode.hasFocus
                ? newPasswordController.labelColorFocus
                : newPasswordController.labelColorNoFocus;
      });
    });
  }

  // Função para redefinir a senha
  void redefinirSenha() async {
    final novaSenha = newPasswordController.textController.text.trim();

    if (novaSenha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, preencha todos os campos.")),
      );
      return;
    }

    try {
      // Redefinir a senha diretamente
      final response = await apiService.redefinirSenha(widget.email, novaSenha);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Senha redefinida com sucesso!")),
        );
        // Navega de volta para a tela de login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao redefinir senha: ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao redefinir senha: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Digite sua nova senha.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            InputTextField(
              text: 'Nova Senha',
              textController: newPasswordController.textController,
              focusNode: newPasswordController.focusNode,
              labelColor: newPasswordController.labelColor,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: redefinirSenha,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shadowColor: Colors.black,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 150, vertical: 20),
              ),
              child: const Text('Redefinir'),
            ),
          ],
        ),
      ),
    );
  }
}
