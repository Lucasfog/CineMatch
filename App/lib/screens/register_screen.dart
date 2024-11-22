import 'package:cine_match/api/api.dart'; // Importa o serviço de API
import 'package:cine_match/constants.dart';
import 'package:cine_match/models/input_controller_model.dart';
import 'package:cine_match/screens/login_screen.dart';
import 'package:cine_match/widgets/input_text_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  Api apiService = Api();

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
        nameController.labelColor = nameController.focusNode.hasFocus
            ? nameController.labelColorFocus
            : nameController.labelColorNoFocus;
      });
    });
    lastNameController.focusNode.addListener(() {
      setState(() {
        lastNameController.labelColor = lastNameController.focusNode.hasFocus
            ? lastNameController.labelColorFocus
            : lastNameController.labelColorNoFocus;
      });
    });
    emailController.focusNode.addListener(() {
      setState(() {
        emailController.labelColor = emailController.focusNode.hasFocus
            ? emailController.labelColorFocus
            : emailController.labelColorNoFocus;
      });
    });
    calendarController.focusNode.addListener(() {
      setState(() {
        calendarController.labelColor = calendarController.focusNode.hasFocus
            ? calendarController.labelColorFocus
            : calendarController.labelColorNoFocus;
      });
    });
    passwordController.focusNode.addListener(() {
      setState(() {
        passwordController.labelColor = passwordController.focusNode.hasFocus
            ? passwordController.labelColorFocus
            : passwordController.labelColorNoFocus;
      });
    });
    confirmPasswordController.focusNode.addListener(() {
      setState(() {
        confirmPasswordController.labelColor =
            confirmPasswordController.focusNode.hasFocus
                ? confirmPasswordController.labelColorFocus
                : confirmPasswordController.labelColorNoFocus;
      });
    });
  }

  Future<void> register() async {
    if (passwordController.textController.text !=
        confirmPasswordController.textController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("As senhas não coincidem!")),
      );
      return;
    }

    final birthDateRaw = calendarController.textController.text;
    final birthDate = DateFormat('dd/MM/yyyy').parse(birthDateRaw);
    final birthDateFormatted = DateFormat('yyyy-MM-dd').format(birthDate);

    final name = nameController.textController.text;
    final lastName = lastNameController.textController.text;
    final email = emailController.textController.text;
    final password = passwordController.textController.text;

    try {
      final response = await apiService.registerUser({
        "nome": name,
        "sobrenome": lastName,
        "email": email,
        "data_nascimento": birthDateFormatted,
        "senha": password,
      });

      if (response.statusCode == 201) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erro ao cadastrar usuário")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $e")),
      );
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
                  text: 'Nome',
                  textController: nameController.textController,
                  focusNode: nameController.focusNode,
                  labelColor: nameController.labelColor,
                ),
                const SizedBox(height: 30),
                InputTextField(
                  text: 'Sobrenome',
                  textController: lastNameController.textController,
                  focusNode: lastNameController.focusNode,
                  labelColor: lastNameController.labelColor,
                ),
                const SizedBox(height: 30),
                InputTextField(
                  text: 'Email',
                  textController: emailController.textController,
                  focusNode: emailController.focusNode,
                  labelColor: emailController.labelColor,
                ),
                const SizedBox(height: 30),
                InputTextField(
                  text: 'Data de nascimento',
                  textController: calendarController.textController,
                  focusNode: calendarController.focusNode,
                  labelColor: calendarController.labelColor,
                  isCalendar: true,
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
                InputTextField(
                  text: 'Confirmar senha',
                  textController: confirmPasswordController.textController,
                  focusNode: confirmPasswordController.focusNode,
                  labelColor: confirmPasswordController.labelColor,
                  isPassword: true,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DefaultColor.primaryColor,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.black,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 100,
                      vertical: 20,
                    ),
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
