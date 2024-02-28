
  import 'package:flutter/material.dart';
import 'package:heritage_map/core/const/app_color.dart';
import 'package:heritage_map/widget/text_widget.dart';

Padding myBtn(String text, {void Function()? tap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
      child: MaterialButton(
        color: AppColor.primaryColor,
        height: 52,
        minWidth: double.infinity,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            20,
          ),
        ),
        onPressed: tap,
        child:  Ctext(
          text: text,
          weight: FontWeight.w600,
          size: 16,
        ),
      ),
    );
  }
