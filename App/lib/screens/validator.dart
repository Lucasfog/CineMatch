import 'package:cine_match/constants.dart';
import 'package:cine_match/screens/new_password.dart';
import 'package:flutter/material.dart';
import 'package:cine_match/api/api.dart';
import 'package:cine_match/widgets/input_text_field.dart';
import 'package:cine_match/models/input_controller_model.dart';

class ValidationCodeScreen extends StatefulWidget {
  final String email;

  const ValidationCodeScreen({super.key, required this.email});

  @override
  _ValidationCodeScreenState createState() => _ValidationCodeScreenState();
}

class _ValidationCodeScreenState extends State<ValidationCodeScreen> {
  final InputControllerModel codeController = InputControllerModel();
  final Api apiService = Api();

  @override
  void initState() {
    super.initState();
    codeController.focusNode.addListener(() {
      setState(() {
        codeController.labelColor = codeController.focusNode.hasFocus
            ? codeController.labelColorFocus
            : codeController.labelColorNoFocus;
      });
    });
  }

  // Função para redefinir a senha
  void redefinirSenha() async {
    final codigo = codeController.textController.text.trim();

    if (codigo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, preencha todos os campos.")),
      );
      return;
    }

    try {
      final response = await apiService.validateCode(widget.email, codigo);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Código validado com sucesso!")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => NewPasswordScreen(email: widget.email)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao validar código: ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao validar código: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/cinematch.png'),
            const Text(
              'Digite o código enviado para o seu e-mail.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            InputTextField(
              text: 'Código de Recuperação',
              textController: codeController.textController,
              focusNode: codeController.focusNode,
              labelColor: codeController.labelColor,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: redefinirSenha,
              style: ElevatedButton.styleFrom(
                backgroundColor: DefaultColor.primaryColor,
                foregroundColor: Colors.white,
                shadowColor: Colors.black,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
              ),
              child: const Text('Validar'),
            ),
          ],
        ),
      ),
    );
  }
}
