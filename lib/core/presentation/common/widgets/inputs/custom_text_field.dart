import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.onChanged,
    required this.icon,
    required this.label,
    this.inputType,
    this.isPassword = false,
    this.isPasswordVisible = false,
    this.toggleIconPassword,
    this.validator,
  });
  final void Function(String)? onChanged;
  final IconData icon;
  final String label;
  final TextInputType? inputType;
  final bool isPassword;
  final bool isPasswordVisible;
  final void Function()? toggleIconPassword;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      keyboardType: inputType,
      obscureText: isPasswordVisible,
      validator: validator,
      decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  onPressed: toggleIconPassword,
                  icon: Icon(
                    !isPasswordVisible
                        ? Icons.remove_red_eye
                        : Icons.visibility_off,
                  ),
                )
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          label: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          )),
    );
  }
}
