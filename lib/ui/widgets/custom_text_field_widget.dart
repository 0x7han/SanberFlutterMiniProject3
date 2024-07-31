import 'package:flutter/material.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final bool isSearch;
  final bool isPassword;
  final Widget? prefixIcon;
  final TextEditingController textEditingController;
  final void Function(String)? onChanged;

  final String hintText;
  const CustomTextFieldWidget(
      {super.key,
      this.isSearch = false,
      this.isPassword = false,
      this.prefixIcon,
      required this.textEditingController,
      this.onChanged,

      required this.hintText});


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: isSearch ? null : const EdgeInsets.symmetric(vertical: 8),
      margin: isSearch ? null : const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isSearch ? colorScheme.inverseSurface.withOpacity(0.08) : colorScheme.surface.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isSearch ? Colors.transparent : colorScheme.surfaceTint.withOpacity(0.2), width: 2)
      ),
      child: TextField(
        obscureText: isPassword,
        textAlignVertical: TextAlignVertical.center,
        controller: textEditingController,
        onChanged: onChanged,
        decoration: InputDecoration(
          
          prefixIcon: prefixIcon,
          
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
