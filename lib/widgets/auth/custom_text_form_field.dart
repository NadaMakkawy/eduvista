import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  String hintText;
  String labelText;
  TextInputType? keyboardType;
  TextEditingController? controller;
  void Function(String)? onChanged;
  String? Function(String?)? validator;
  bool? obscureText;

  CustomTextFormField(
      {required this.hintText,
      this.keyboardType,
      required this.labelText,
      this.controller,
      this.onChanged,
      this.validator,
      this.obscureText,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              labelText,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          TextFormField(
            onChanged: onChanged,
            controller: controller,
            obscureText: obscureText ?? false,
            keyboardType: keyboardType,
            validator: validator,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
              ),
              hintText: hintText,
            ),
          ),
        ],
      ),
    );
  }
}
