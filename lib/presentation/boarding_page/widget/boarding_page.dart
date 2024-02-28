import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heritage_map/core/const/app_color.dart';
import 'package:heritage_map/core/const/app_image.dart';
import 'package:heritage_map/core/const/app_size.dart';
import 'package:heritage_map/core/utils/navigator_service.dart';
import 'package:heritage_map/presentation/auth/login_screen.dart';
import 'package:heritage_map/provider/boarding_provider.dart';
import 'package:heritage_map/widget/dot_indicator.dart';
import 'package:heritage_map/widget/text_widget.dart';

Container boardingContianer(BuildContext context, int index, String title, String subtitle, String image, WidgetRef ref) {
  return Container(
    height: MediaQuery.of(context).size.height,
    decoration: BoxDecoration(
      image: DecorationImage(
          image: AssetImage(
            image,
          ),
          fit: BoxFit.cover),
    ),
    width: MediaQuery.of(context).size.width,
    child: Column(
      children: [
        AppSize.height50,
        Align(
          alignment: Alignment.topRight,
          child: TextButton(
              onPressed: () {
                ref.read(boardingPageControllerProvider).jumpToPage(APPImage.boardingPageImage.length - 1);
              },
              child: const Ctext(
                text: "Skip",
              )),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(28.0),
          child: Ctext(
            text: title,
            size: 48,
            line: 2,
            align: TextAlign.start,
            weight: FontWeight.w700,
            color: AppColor.white,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(28.0),
          child: Ctext(
            text: subtitle,
            size: 18,
            line: 2,
            align: TextAlign.start,
            weight: FontWeight.w400,
            color: AppColor.white,
          ),
        ),
        Row(
          children: [
            AppSize.width28,
            ...List.generate(
                3,
                (dotIndex) => Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Dotindicator(
                        isActive: dotIndex == index,
                      ),
                    ))
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(28.0),
          child: MaterialButton(
            height: 56,
            minWidth: double.infinity,
            color: AppColor.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onPressed: () {
              if (index == APPImage.boardingPageImage.length - 1) {
                NavigatorService.pushNamedAndRemoveUntil(LoginScreen.routeName);
                log("Get Started pressed");
              } else {
                ref
                    .read(boardingPageControllerProvider)
                    .animateToPage(index + 1, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);

                log("Next pressed");
              }
            },
            child: Ctext(
              text: index == APPImage.boardingPageImage.length - 1 ? "Get Started" : "Next",
            ),
          ),
        )
      ],
    ),
  );
}
