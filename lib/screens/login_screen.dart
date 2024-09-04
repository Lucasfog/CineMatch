import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FocusNode _focusNode1 = FocusNode();
  Color _labelColor1 = Colors.grey;

  FocusNode _focusNode2 = FocusNode();
  Color _labelColor2 = Colors.grey;

  @override
  void initState() {
    super.initState();
    _focusNode1.addListener(() {
      setState(() {
        // Muda a cor do rótulo quando o campo está em foco
        _labelColor1 = _focusNode1.hasFocus ? Colors.blue : Colors.grey;
      });
    });

    _focusNode2.addListener(() {
      setState(() {
        // Muda a cor do rótulo quando o campo está em foco
        _labelColor2 = _focusNode2.hasFocus ? Colors.blue : Colors.grey;
      });
    });
  }

  void _logar() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/cinematch.png'),
              TextField(
                focusNode: _focusNode1,
                cursorColor: _labelColor1,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: _labelColor1),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: _labelColor1),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                focusNode: _focusNode2,
                cursorColor: _labelColor2,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  labelStyle: TextStyle(color: _labelColor2),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: _labelColor2),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  // ação ao pressionar o botão
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
