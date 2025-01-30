import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerForm extends StatefulWidget {
  const ColorPickerForm({required this.colorHex, super.key});

  final TextEditingController colorHex;

  @override
  State<ColorPickerForm> createState() => _ColorPickerFormState();
}

class _ColorPickerFormState extends State<ColorPickerForm> {
  Color _currentColor = Colors.black;

  void _changeColor(Color color) {
    setState(() => _currentColor = color);
  }

  void _openColorPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: _currentColor,
            onColorChanged: _changeColor,
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
        child: const Text('Done!'),
        onPressed: () {
          _currentColor = _currentColor;
          Navigator.of(context).pop();
        },
      ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => InkWell(
      onTap: _openColorPicker,
      child: CircleAvatar(
        backgroundColor: _currentColor,
      )
    );
}