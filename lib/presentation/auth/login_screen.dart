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
import 'package:heritage_map/presentation/auth/forget_password_screen.dart';
import 'package:heritage_map/presentation/auth/register_screen.dart';

import 'package:heritage_map/presentation/bottom_nav/bottom_nav_screen.dart';

import 'package:heritage_map/provider/base_provider.dart';
import 'package:heritage_map/widget/my_btn.dart';
import 'package:heritage_map/widget/text_field.dart';
import 'package:heritage_map/widget/text_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const String routeName = "LoginScreen";

  const LoginScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    checkRememberedLogin();
  }

  // insert user saved data in  text field
  void checkRememberedLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('user_email');
    String? savedPassword = prefs.getString('user_password');

    if (savedEmail != null && savedPassword != null) {
      setState(() {
        email.text = savedEmail;
        password.text = savedPassword;

        ref.read(checkBoxProvider.notifier).state = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var checkboxvalue = ref.watch(checkBoxProvider);
    final isloading = ref.watch(isLoadingProvider);

    void saveRememberedLogin() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (checkboxvalue) {
        prefs.setString('user_email', email.text);
        prefs.setString('user_password', password.text);
      } else {
        prefs.remove('user_email');
        prefs.remove('user_password');
      }
    }

    Padding checkBoxBtnAndForgetPassword() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    activeColor: AppColor.primaryColor,
                    value: checkboxvalue,
                    onChanged: (value) async {
                      ref.read(checkBoxProvider.notifier).state = !checkboxvalue;
                    }),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: const Ctext(
                    text: 'Remember me',
                    size: 14,
                    color: AppColor.grey,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, ForgetPasswordScreen.routeName);
              },
              child: const Ctext(
                text: 'Forgot Password',
                size: 14,
                color: AppColor.grey,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColor.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 1.1,
          width: MediaQuery.of(context).size.width,
          child: Form(
            key: formKey1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AppSize.height15,
                const Image(image: AssetImage('assets/images/ll.png')),
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
                AppSize.height28,
                PasswordTextField(label: 'Password', controller: password),
                checkBoxBtnAndForgetPassword(),
                AppSize.height15,
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30),
                  child: MaterialButton(
                    height: 52,
                    minWidth: double.infinity,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          20,
                        ),
                        side: const BorderSide(
                          color: AppColor.grey,
                        )),
                    onPressed: () {
                      NavigatorService.pushNamed(RegisterScreen.routeName);
                    },
                    child: const Ctext(
                      text: "Create Account",
                      weight: FontWeight.w600,
                      size: 16,
                    ),
                  ),
                ),
                isloading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : myBtn(
                        "Sign up",
                        tap: () async {
                          if (formKey1.currentState!.validate()) {
                            try {
                              ref.read(isLoadingProvider.notifier).state = true;
                              await AuthService().login(email: email.text, password: password.text).then((value) async {
                                Fluttertoast.showToast(msg: "Login Successfully");
                                saveRememberedLogin();

                                await LocalStorage().savetoken(key: LocalSaveData.email, token: email.text);
                                ref.read(navIndexProvider.notifier).state = 0;

                                NavigatorService.pushNamedAndRemoveUntil(NavigationScreen.routeName);
                                ref.read(isLoadingProvider.notifier).state = false;
                              });
                            } on FirebaseAuthException catch (e) {
                              log(" register error => ${e.message}");

                              Fluttertoast.showToast(msg: e.message ?? "Invaid Credential");
                              ref.read(isLoadingProvider.notifier).state = false;
                            }
                          }
                        },
                      ),
                AppSize.height100,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
