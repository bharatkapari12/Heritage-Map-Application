import 'package:flutter/material.dart';
import 'package:heritage_map/core/const/app_color.dart';
import 'package:heritage_map/widget/text_widget.dart';


searchBtn({void Function()? tap}) {
  return GestureDetector(
    onTap: tap,
    child: Container(
      height: 50,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: AppColor.white, boxShadow: const [
        BoxShadow(
          color: AppColor.grey,
          blurRadius: 4,
        ),
      ]),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Ctext(
            text: "Search Heritage Site",
            size: 14,
            weight: FontWeight.w400,
            color: AppColor.grey,
          ),
          Image(
            image: AssetImage(
              "assets/images/search.png",
            ),
          )
        ],
      ),
    ),
  );
}
