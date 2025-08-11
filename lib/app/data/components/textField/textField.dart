import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final BorderSide? borderSide;
  final TextStyle? hintStyle;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixPressed;

  const CustomTextField(
      {Key? key,
      required this.label,
      required this.hintText,
      required this.controller,
      this.obscureText = false,
      this.keyboardType = TextInputType.text,
      this.prefixIcon,
      this.suffixIcon,
      this.borderSide,
      this.onSuffixPressed,
      this.hintStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: hintStyle,
            enabledBorder: OutlineInputBorder(
              borderSide: borderSide ?? BorderSide(),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: borderSide ?? BorderSide(),
              borderRadius: BorderRadius.circular(8),
            ),
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            suffixIcon: suffixIcon != null
                ? IconButton(
                    icon: Icon(suffixIcon),
                    onPressed: onSuffixPressed,
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
