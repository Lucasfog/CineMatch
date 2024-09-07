import 'package:flutter/material.dart';

class InputTextField extends StatelessWidget {
  const InputTextField({
    super.key,
    required String text,
    required TextEditingController textController,
    required FocusNode focusNode,
    required Color labelColor,
    bool isPassword = false,
    bool isCalendar = false,
  })  : _text = text,
        _textController = textController,
        _focusNode = focusNode,
        _labelColor = labelColor,
        _isPassword = isPassword,
        _isCalendar = isCalendar;

  final String _text;
  final TextEditingController _textController;
  final FocusNode _focusNode;
  final Color _labelColor;
  final bool _isPassword;
  final bool _isCalendar;

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.white, // Cor principal (barra superior e botões)
              onPrimary: Colors.blue, // Cor do texto no botão 'OK'
              onSurface: Colors.blue, // Cor da data selecionada
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                backgroundColor:
                    Colors.blue, // Cor do texto dos botões (CANCELAR, OK)
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      _textController.text = "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: _isPassword,
      controller: _textController,
      focusNode: _focusNode,
      cursorColor: _labelColor,
      onTap: _isCalendar ? () => _selectDate(context) : null,
      decoration: InputDecoration(
        labelText: _text,
        suffixIcon: Icon(_isCalendar ? Icons.calendar_today : null),
        labelStyle: TextStyle(color: _labelColor),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: _labelColor),
        ),
      ),
    );
  }
}
