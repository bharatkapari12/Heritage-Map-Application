import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heritage_map/core/const/app_color.dart';
import 'package:heritage_map/provider/base_provider.dart';

Padding customTextField(
    {required String label,
    // required icon,
    required controller,
    bool? onlyread,
    int? maxline,
    String? Function(String?)? validation,
    TextInputType? keyboardtype}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18),
    child: TextFormField(
      minLines: 1,
      maxLines: maxline ?? 2,
      controller: controller,
      validator: validation ??
          (value) {
            if (value!.isEmpty) {
              return 'Please enter your $label';
            }

            return null;
          },
      keyboardType: keyboardtype ?? TextInputType.text,
      readOnly: onlyread ?? false,
      decoration: InputDecoration(
        suffixIconConstraints: const BoxConstraints(minWidth: 90),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        // fillColor: Colors.grey.shade200,
        // filled: true,
        // suffixIcon: Icon(
        //   icon,
        //   color: Colors.grey,
        // ),
        border: AppColor.outlineBorderStyle,
        enabledBorder: AppColor.enableBorderStyle,
        focusedBorder: AppColor.focusedBorderStyle,
        errorBorder: AppColor.errorBorderStyle,
      ),
    ),
  );
}

class PasswordTextField extends ConsumerWidget {
  const PasswordTextField({super.key, required this.label, required this.controller});
  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool obsText = ref.watch(obscureTextProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your $label';
          } else if (value.length < 8) {
            return 'Password must be 8 or more characters long';
          } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
            return 'Password must include at least one symbol';
          }
          return null;
        },
        controller: controller,
        obscureText: obsText,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          suffixIconConstraints: const BoxConstraints(minWidth: 90),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          // fillColor: Colors.grey.shade200,
          // filled: true,
          suffixIcon: IconButton(
            onPressed: () {
              log(obsText.toString());
              ref.read(obscureTextProvider.notifier).state = !obsText;
            },
            icon: obsText
                ? const Icon(
                    Icons.visibility,
                    color: Colors.grey,
                  )
                : const Icon(
                    Icons.visibility_off,
                    color: Colors.grey,
                  ),
          ),
          border: AppColor.outlineBorderStyle,
          enabledBorder: AppColor.enableBorderStyle,
          focusedBorder: AppColor.focusedBorderStyle,
          errorBorder: AppColor.errorBorderStyle,
        ),
      ),
    );
  }
}
