import 'package:flutter/material.dart';
import 'package:cine_match/api/api.dart';
import 'package:cine_match/widgets/input_text_field.dart';
import 'package:cine_match/screens/login_screen.dart';
import 'package:cine_match/models/input_controller_model.dart';

class ValidationCodeScreen extends StatefulWidget {
  final String email;

  const ValidationCodeScreen({super.key, required this.email});

  @override
  _ValidationCodeScreenState createState() => _ValidationCodeScreenState();
}

class _ValidationCodeScreenState extends State<ValidationCodeScreen> {
  final InputControllerModel codeController = InputControllerModel();
  final InputControllerModel newPasswordController = InputControllerModel();
  final Api apiService = Api();

  @override
  void initState() {
    super.initState();
    // Atualiza as cores do label dependendo do foco
    codeController.focusNode.addListener(() {
      setState(() {
        codeController.labelColor = codeController.focusNode.hasFocus
            ? codeController.labelColorFocus
            : codeController.labelColorNoFocus;
      });
    });

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
    final codigo = codeController.textController.text.trim();
    final novaSenha = newPasswordController.textController.text.trim();

    if (codigo.isEmpty || novaSenha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, preencha todos os campos.")),
      );
      return;
    }

    try {
      // Redefinir a senha diretamente
      final response =
          await apiService.redefinirSenha(widget.email, codigo, novaSenha);
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
              'Digite o código enviado para o seu e-mail e a nova senha.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            InputTextField(
              text: 'Código de Recuperação',
              textController: codeController.textController,
              focusNode: codeController.focusNode,
              labelColor: codeController.labelColor,
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
              child: const Text('Validar e Redefinir'),
            ),
          ],
        ),
      ),
    );
  }
}
