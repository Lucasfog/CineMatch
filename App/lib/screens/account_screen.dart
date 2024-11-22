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
  String userName = '';
  String userSurname = '';
  String userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

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
    String fullName = '$userName $userSurname';

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  fullName,
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
                await prefs.remove('usuarioLogado');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
