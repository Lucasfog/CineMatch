import 'package:cine_match/constants.dart';
import 'package:flutter/material.dart';

class InputControllerModel {
  final TextEditingController textController = TextEditingController();

  FocusNode focusNode = FocusNode();
  Color labelColor = Colors.grey;
  Color labelColorNoFocus = Colors.grey;
  Color labelColorFocus = DefaultColor.primaryColor;
}
