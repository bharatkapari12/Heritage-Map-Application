import 'dart:developer';
// import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:heritage_map/core/const/app_color.dart';
import 'package:heritage_map/core/const/app_size.dart';
import 'package:heritage_map/core/utils/navigator_service.dart';
import 'package:heritage_map/data/%20local%20storage/local_save_data.dart';
import 'package:heritage_map/data/%20local%20storage/local_storge.dart';
import 'package:heritage_map/data/model/user_model.dart';
import 'package:heritage_map/data/service/auth_service.dart';
import 'package:heritage_map/data/service/user_record_service.dart';
import 'package:heritage_map/presentation/auth/login_screen.dart';
import 'package:heritage_map/presentation/auth/successfully_created_screen.dart';
import 'package:heritage_map/provider/base_provider.dart';
import 'package:heritage_map/provider/boarding_provider.dart';
import 'package:heritage_map/widget/my_btn.dart';
import 'package:heritage_map/widget/text_field.dart';
import 'package:heritage_map/widget/text_widget.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  static const String routeName = "RegisterScreen";

  const RegisterScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController first = TextEditingController();
  final TextEditingController location = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController last = TextEditingController();
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(registerPageControllerProvider);
    final isloading = ref.watch(isLoadingProvider);

    return Scaffold(
      backgroundColor: AppColor.white,
      body: Form(
        key: formKey1,
        child: PageView(
          controller: controller,
          children: [
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSize.height28,
                    IconButton(
                        onPressed: () {
                          NavigatorService.pushReplacementNamed(LoginScreen.routeName);
                        },
                        icon: const Icon(Icons.arrow_back_ios_new)),
                    AppSize.height28,
                    const Ctext(
                      text: "Create Your Account",
                      size: 18,
                      weight: FontWeight.w400,
                      color: AppColor.grey,
                    ),
                    AppSize.height15,
                    const Ctext(
                      text: "What’s Your Name?",
                      size: 24,
                      weight: FontWeight.w700,
                    ),
                    AppSize.height15,
                    customTextField(label: 'First Name', controller: first),
                    AppSize.height15,
                    customTextField(label: 'Last Name', controller: last),
                    AppSize.height15,
                    customTextField(label: 'Address', controller: location),
                    AppSize.height15,
                    customTextField(label: 'City', controller: city),
                    AppSize.height50,
                    myBtn("Continue", tap: () {
                      if (formKey1.currentState!.validate()) {
                        ref
                            .read(registerPageControllerProvider)
                            .animateToPage(1, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                      }
                    })
                  ],
                ),
              ),
            ),
            // 2
            Consumer(builder: (context, ref, child) {
              // final value = ref.watch(switchBoxProvider);

              return SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSize.height50,
                      IconButton(
                          onPressed: () {
                            ref
                                .read(registerPageControllerProvider)
                                .animateToPage(0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                          },
                          icon: const Icon(Icons.arrow_back_ios_new)),
                      AppSize.height50,
                      const Ctext(
                        text: "Create Your Account",
                        size: 18,
                        weight: FontWeight.w400,
                        color: AppColor.grey,
                      ),
                      AppSize.height15,
                      const Ctext(
                        text: "And, Your  Email?",
                        size: 24,
                        weight: FontWeight.w700,
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
                      // AppSize.height50,
                      // Row(
                      //   children: [
                      //     SizedBox(
                      //       width: MediaQuery.of(context).size.width * 0.7,
                      //       child: const Ctext(
                      //         text: "I’d like to received marketing and policy",
                      //         size: 14,
                      //         color: AppColor.grey,
                      //       ),
                      //     ),
                      //     Switch(
                      //         value: value,
                      //         onChanged: (value1) {
                      //           ref.read(switchBoxProvider.notifier).state = !value;
                      //         })
                      //   ],
                      // ),
                      // const Ctext(
                      //   text: "communication from heritage map and it’s Partners",
                      //   size: 14,
                      //   color: AppColor.grey,
                      // ),
                      AppSize.height50,
                      myBtn("Continue", tap: () {
                        if (formKey1.currentState!.validate()) {
                          ref
                              .read(registerPageControllerProvider)
                              .animateToPage(2, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                        }
                      })
                    ],
                  ),
                ),
              );
            }),
            // 3

            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSize.height50,
                    IconButton(
                        onPressed: () {
                          ref
                              .read(registerPageControllerProvider)
                              .animateToPage(1, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                        },
                        icon: const Icon(Icons.arrow_back_ios_new)),
                    AppSize.height50,
                    const Ctext(
                      text: "Create Your Account",
                      size: 18,
                      weight: FontWeight.w400,
                      color: AppColor.grey,
                    ),
                    AppSize.height15,
                    const Ctext(
                      text: "Create a password",
                      size: 24,
                      weight: FontWeight.w700,
                    ),
                    AppSize.height50,
                    PasswordTextField(label: "Password", controller: password),
                    AppSize.height50,
                    const Ctext(
                      text: "Your Password must include at least one symbol and  must be 8 or more characters long",
                      size: 14,
                      line: 3,
                      color: AppColor.grey,
                    ),
                    AppSize.height50,
                    isloading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : myBtn("Continue", tap: () {
                            if (formKey1.currentState!.validate()) {
                              try {
                                ref.read(isLoadingProvider.notifier).state = true;

                                AuthService().register(email: email.text, password: password.text).then((value) async {
                                  Fluttertoast.showToast(msg: "Register Successfully");
                                  await LocalStorage().savetoken(key: LocalSaveData.email, token: email.text);
                                  var model = UserModel(
                                    fname: first.text,
                                    lname: last.text,
                                    email: email.text,
                                    city: city.text,
                                    address: location.text,
                                    explore: [],
                                    needInfo: ref.watch(switchBoxProvider),
                                  );
                                  await UserRecordService().userinfo(model: model);
                                  await NavigatorService.pushNamedAndRemoveUntil(SuccessfullyCreatedScreen.routeName);
                                  ref.read(isLoadingProvider.notifier).state = false;
                                });
                              } on FirebaseAuthException catch (e) {
                                log(" register error => ${e.message}");
                                ref.read(isLoadingProvider.notifier).state = false;
                                Fluttertoast.showToast(msg: e.message ?? "Invaid Credential");
                              }
                            }
                          })
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
