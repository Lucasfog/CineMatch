import 'package:cine_match/models/input_controller_model.dart';
import 'package:cine_match/screens/register_screen.dart';
import 'package:cine_match/widgets/input_text_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  InputControllerModel emailController = InputControllerModel();
  InputControllerModel passwordController = InputControllerModel();

  String _validacaoLogin = '';

  @override
  void initState() {
    super.initState();

    emailController.focusNode.addListener(() {
      setState(() {
        // Muda a cor do rótulo quando o campo está em foco
        emailController.labelColor = emailController.focusNode.hasFocus
            ? emailController.labelColorFocus
            : emailController.labelColorNoFocus;
      });
    });

    passwordController.focusNode.addListener(() {
      setState(() {
        // Muda a cor do rótulo quando o campo está em foco
        passwordController.labelColor = passwordController.focusNode.hasFocus
            ? passwordController.labelColorFocus
            : passwordController.labelColorNoFocus;
      });
    });
  }

  void logar() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Espaça entre o topo e o rodapé
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/cinematch.png'),
                InputTextField(
                  text: 'Email',
                  textController: emailController.textController,
                  focusNode: emailController.focusNode,
                  labelColor: emailController.labelColor,
                ),
                const SizedBox(height: 30),
                InputTextField(
                  text: 'Senha',
                  textController: passwordController.textController,
                  focusNode: passwordController.focusNode,
                  labelColor: passwordController.labelColor,
                  isPassword: true,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (emailController.textController.text == 'kayky') {
                      setState(() {
                        _validacaoLogin =
                            'O usuario Pompers ja esta utilizando esta senha';
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Cor de fundo
                    foregroundColor: Colors.white, // Cor do texto e ícone
                    shadowColor: Colors.black, // Cor da sombra
                    elevation: 5, // Elevação do botão
                    shape: RoundedRectangleBorder(
                      // Forma do botão
                      borderRadius:
                          BorderRadius.circular(15), // Borda arredondada
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 150, vertical: 20), // Espaçamento interno
                  ),
                  child: const Text('Fazer login'),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _validacaoLogin = 'Problema é seu';
                    });
                  },
                  child: const Text(
                    'Esqueci minha senha',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.blue,
                    ),
                  ),
                ),
                Text(_validacaoLogin),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Ainda não tem uma conta?'),
                TextButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterScreen()),
                  ),
                  child: const Text(
                    'Criar conta',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            // Espaço vazio entre o conteúdo e o botão no rodapé
          ],
        ),
      ),
    );
  }
}
