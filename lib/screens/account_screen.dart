import 'package:cine_match/screens/login_screen.dart';
import 'package:cine_match/screens/new_password.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String userName = ''; // Apenas o nome
  String userSurname = ''; // Sobrenome
  String userEmail = ''; // Email do usuário

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Carrega os dados do usuário do SharedPreferences
  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('usuarioLogado');

    if (userData != null) {
      final userMap = json.decode(userData);
      setState(() {
        userName = userMap['nome'] ?? 'Nome não disponível';
        userSurname = userMap['sobrenome'] ?? 'Sobrenome não disponível';
        userEmail = userMap['email'] ?? 'Email não disponível';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Concatena o nome e sobrenome
    String fullName = '$userName $userSurname';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conta do Usuário'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exibição das informações do usuário
            const Text(
              'Informações do Usuário',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.person),
                const SizedBox(width: 10),
                Text(
                  fullName, // Exibe o nome completo (nome + sobrenome)
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.email),
                const SizedBox(width: 10),
                Text(
                  userEmail,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Opções de configuração de conta
            const Text(
              'Configurações',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Alterar Senha'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewPasswordScreen(
                            email: userEmail,
                          )),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('usuarioLogado'); // Remove os dados do login
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const LoginScreen()), // Redireciona para login
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
