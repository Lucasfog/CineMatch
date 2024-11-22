import 'package:cine_match/constants.dart';
import 'package:cine_match/models/input_controller_model.dart';
import 'package:cine_match/screens/recovery_screen.dart';
import 'package:cine_match/screens/register_screen.dart';
import 'package:cine_match/tab_bar.dart';
import 'package:cine_match/widgets/input_text_field.dart';
import 'package:flutter/material.dart';
import 'package:cine_match/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UsuarioLogado {
  static Map<String, dynamic>? dadosUsuario;

  static void setDados(Map<String, dynamic> dados) {
    dadosUsuario = dados;
  }

  static Map<String, dynamic>? getDados() {
    return dadosUsuario;
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Api apiService = Api();

  InputControllerModel emailController = InputControllerModel();
  InputControllerModel passwordController = InputControllerModel();

  String _validacaoLogin = '';

  @override
  void initState() {
    super.initState();
    verificarLoginSalvo();

    emailController.focusNode.addListener(() {
      setState(() {
        emailController.labelColor = emailController.focusNode.hasFocus
            ? emailController.labelColorFocus
            : emailController.labelColorNoFocus;
      });
    });

    passwordController.focusNode.addListener(() {
      setState(() {
        passwordController.labelColor = passwordController.focusNode.hasFocus
            ? passwordController.labelColorFocus
            : passwordController.labelColorNoFocus;
      });
    });
  }

  void verificarLoginSalvo() async {
    final prefs = await SharedPreferences.getInstance();
    final usuarioLogado = prefs.getString('usuarioLogado');

    if (usuarioLogado != null) {
      UsuarioLogado.setDados(json.decode(usuarioLogado));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyTabBar()),
      );
    }
  }

  void logar() async {
    final email = emailController.textController.text;
    final senha = passwordController.textController.text;

    if (email.isEmpty || senha.isEmpty) {
      setState(() {
        _validacaoLogin = 'Por favor, preencha todos os campos.';
      });
      return;
    }

    try {
      final response = await apiService.login(email, senha);

      if (response.statusCode == 200) {
        final usuario = json.decode(response.body);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('usuarioLogado', json.encode(usuario));

        UsuarioLogado.setDados(usuario);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyTabBar()),
        );
      } else if (response.statusCode == 401) {
        setState(() {
          _validacaoLogin = 'Email ou senha inválidos.';
        });
      } else {
        setState(() {
          _validacaoLogin = 'Erro ao fazer login. Tente novamente.';
        });
      }
    } catch (e) {
      setState(() {
        _validacaoLogin = 'Erro de conexão: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  onPressed: logar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DefaultColor.primaryColor,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.black,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 20),
                  ),
                  child: const Text('Fazer login'),
                ),
                const SizedBox(height: 30),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RecoveryScreen()),
                    );
                  },
                  child: const Text(
                    'Esqueci minha senha',
                    style: TextStyle(
                      color: DefaultColor.primaryColor,
                      decoration: TextDecoration.underline,
                      decorationColor: DefaultColor.primaryColor,
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
                      color: DefaultColor.primaryColor,
                      decoration: TextDecoration.underline,
                      decorationColor: DefaultColor.primaryColor,
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
