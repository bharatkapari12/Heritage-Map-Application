import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heritage_map/core/const/app_color.dart';
import 'package:heritage_map/core/utils/navigator_service.dart';
import 'package:heritage_map/presentation/auth/login_screen.dart';
import 'package:heritage_map/presentation/bottom_nav/bottom_nav_screen.dart';

import 'package:heritage_map/widget/my_btn.dart';
import 'package:heritage_map/widget/text_widget.dart';

class SuccessfullyCreatedScreen extends ConsumerWidget {
  static const String routeName = "SuccessfullyCreatedScreen";

  const SuccessfullyCreatedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: IconButton(
                      onPressed: () {
                        NavigatorService.pushReplacementNamed(LoginScreen.routeName);
                      },
                      icon: const Icon(Icons.arrow_back_ios_new)),
                ),
              ),
              const Spacer(),
              const Spacer(),
              const Spacer(),
              const Image(
                image: AssetImage("assets/images/check.png"),
              ),
              const Spacer(),
              const Ctext(
                text: "Successfully created  an  account",
                size: 24,
                weight: FontWeight.w700,
              ),
              const Ctext(
                text: "After this you can explore any place you wan to visit it!",
                size: 14,
                color: AppColor.grey,
              ),
              const Spacer(),
              myBtn("Let’ Explore!", tap: () {
                NavigatorService.pushNamedAndRemoveUntil(NavigationScreen.routeName);
              }),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
