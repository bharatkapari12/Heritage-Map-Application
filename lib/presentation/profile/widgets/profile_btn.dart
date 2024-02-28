  import 'package:flutter/material.dart';
import 'package:heritage_map/core/const/app_color.dart';
import 'package:heritage_map/widget/text_widget.dart';

GestureDetector profileBtn({void Function()? tap, String? text, String? image}) {
    return GestureDetector(
      onTap: tap,
      child: Container(
        height: 60,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColor.black,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Ctext(text: text ?? 'NA'),
            Image(
              image: AssetImage(image ?? 'NA'),
            )
          ],
        ),
      ),
    );
  }
