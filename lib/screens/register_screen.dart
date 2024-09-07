import 'package:cine_match/models/input_controller_model.dart';
import 'package:cine_match/screens/login_screen.dart';
import 'package:cine_match/widgets/input_text_field.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  InputControllerModel nameController = InputControllerModel();
  InputControllerModel lastNameController = InputControllerModel();
  InputControllerModel emailController = InputControllerModel();
  InputControllerModel calendarController = InputControllerModel();
  InputControllerModel passwordController = InputControllerModel();
  InputControllerModel confirmPasswordController = InputControllerModel();

  @override
  void initState() {
    super.initState();
    nameController.focusNode.addListener(() {
      setState(() {
        // Muda a cor do rótulo quando o campo está em foco
        nameController.labelColor = nameController.focusNode.hasFocus
            ? nameController.labelColorFocus
            : nameController.labelColorNoFocus;
      });
    });

    lastNameController.focusNode.addListener(() {
      setState(() {
        // Muda a cor do rótulo quando o campo está em foco
        lastNameController.labelColor = lastNameController.focusNode.hasFocus
            ? lastNameController.labelColorFocus
            : lastNameController.labelColorNoFocus;
      });
    });

    emailController.focusNode.addListener(() {
      setState(() {
        // Muda a cor do rótulo quando o campo está em foco
        emailController.labelColor = emailController.focusNode.hasFocus
            ? emailController.labelColorFocus
            : emailController.labelColorNoFocus;
      });
    });

    calendarController.focusNode.addListener(() {
      setState(() {
        // Muda a cor do rótulo quando o campo está em foco
        calendarController.labelColor = calendarController.focusNode.hasFocus
            ? calendarController.labelColorFocus
            : calendarController.labelColorNoFocus;
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

    confirmPasswordController.focusNode.addListener(() {
      setState(() {
        // Muda a cor do rótulo quando o campo está em foco
        confirmPasswordController.labelColor =
            confirmPasswordController.focusNode.hasFocus
                ? confirmPasswordController.labelColorFocus
                : confirmPasswordController.labelColorNoFocus;
      });
    });
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
                  text: 'Nome',
                  textController: nameController.textController,
                  focusNode: nameController.focusNode,
                  labelColor: nameController.labelColor,
                ),
                const SizedBox(
                  height: 30,
                ),
                InputTextField(
                  text: 'Sobrenome',
                  textController: lastNameController.textController,
                  focusNode: lastNameController.focusNode,
                  labelColor: lastNameController.labelColor,
                ),
                const SizedBox(
                  height: 30,
                ),
                InputTextField(
                  text: 'Email',
                  textController: emailController.textController,
                  focusNode: emailController.focusNode,
                  labelColor: emailController.labelColor,
                ),
                const SizedBox(
                  height: 30,
                ),
                InputTextField(
                  text: 'Data de nascimento',
                  textController: calendarController.textController,
                  focusNode: calendarController.focusNode,
                  labelColor: calendarController.labelColor,
                  isCalendar: true,
                ),
                const SizedBox(
                  height: 30,
                ),
                InputTextField(
                  text: 'Senha',
                  textController: passwordController.textController,
                  focusNode: passwordController.focusNode,
                  labelColor: passwordController.labelColor,
                  isPassword: true,
                ),
                const SizedBox(
                  height: 30,
                ),
                InputTextField(
                  text: 'Confirmar senha',
                  textController: confirmPasswordController.textController,
                  focusNode: confirmPasswordController.focusNode,
                  labelColor: confirmPasswordController.labelColor,
                  isPassword: true,
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () {},
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
                  child: const Text('Cadastrar'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Já tem uma conta?'),
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
