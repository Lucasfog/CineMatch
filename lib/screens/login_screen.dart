import 'package:cine_match/models/input_controller_model.dart';
import 'package:cine_match/screens/recovery_screen.dart';
import 'package:cine_match/screens/register_screen.dart';
import 'package:cine_match/tab_bar.dart';
import 'package:cine_match/widgets/input_text_field.dart';
import 'package:flutter/material.dart';
import 'package:cine_match/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Classe global para armazenar os dados do usuário logado
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

  // Verifica se há um login salvo no SharedPreferences
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

  // Função para realizar login
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

        // Salva os dados do usuário no SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('usuarioLogado', json.encode(usuario));

        // Define os dados do usuário globalmente
        UsuarioLogado.setDados(usuario);

        // Redireciona para a HomeScreen
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          ],
        ),
      ),
    );
  }
}
