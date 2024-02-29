import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:heritage_map/core/const/app_color.dart';
import 'package:heritage_map/core/const/app_size.dart';
import 'package:heritage_map/core/utils/navigator_service.dart';
import 'package:heritage_map/data/%20local%20storage/local_save_data.dart';
import 'package:heritage_map/data/%20local%20storage/local_storge.dart';
import 'package:heritage_map/data/service/auth_service.dart';
import 'package:heritage_map/presentation/auth/login_screen.dart';
import 'package:heritage_map/presentation/home/screen/home_screen.dart';
import 'package:heritage_map/widget/my_btn.dart';
import 'package:heritage_map/widget/text_field.dart';
import 'package:heritage_map/widget/text_widget.dart';

class ForgetPasswordScreen extends ConsumerWidget {
  static const String routeName = "ForgetPasswordScreen";

  ForgetPasswordScreen({super.key});

  final TextEditingController email = TextEditingController();

  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Form(
            key: formKey1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Ctext(
                        text: "Input Your  Email",
                        size: 18,
                        weight: FontWeight.w400,
                        color: AppColor.grey,
                      ),
                      AppSize.height15,
                      Ctext(
                        text: "Forgot Your Password?",
                        size: 24,
                        weight: FontWeight.w700,
                      ),
                    ],
                  ),
                ),
                AppSize.height50,
                customTextField(
                  label: 'Email',
                  controller: email,
                  validation: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email address.';
                    }

                    bool isValid = RegExp(
                      r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$',
                    ).hasMatch(value);
                    if (!isValid) {
                      return 'Please enter a valid email address.';
                    }
                    return null;
                  },
                ),
                AppSize.height100,
                myBtn("Submit", tap: () {
                  if (formKey1.currentState!.validate()) {
                    try {
                      AuthService().forgetpassword(email: email.text).then((value) async {
                        Fluttertoast.showToast(msg: "Check your Mail ");

                        await LocalStorage().savetoken(key: LocalSaveData.email, token: email.text);
                        NavigatorService.pushNamedAndRemoveUntil(LoginScreen.routeName);
                      });
                    } on FirebaseAuthException catch (e) {
                      log(" register error => ${e.message}");
                      Fluttertoast.showToast(msg: e.message ?? "Invaid Credential");
                    }
                  }
                }),
                const Spacer(),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
