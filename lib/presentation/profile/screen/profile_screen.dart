
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:heritage_map/core/const/app_color.dart';
import 'package:heritage_map/core/const/app_size.dart';
import 'package:heritage_map/core/utils/navigator_service.dart';
import 'package:heritage_map/data/%20local%20storage/local_save_data.dart';
import 'package:heritage_map/data/%20local%20storage/local_storge.dart';
import 'package:heritage_map/data/service/auth_service.dart';
import 'package:heritage_map/presentation/add/add_place_screen.dart';
import 'package:heritage_map/presentation/auth/login_screen.dart';
import 'package:heritage_map/presentation/home/widget/user_details.dart';
import 'package:heritage_map/presentation/profile/screen/char_screen.dart';
import 'package:heritage_map/presentation/profile/screen/edit_profile_screen.dart';
import 'package:heritage_map/presentation/profile/screen/fourm_screen.dart';

import 'package:heritage_map/presentation/profile/widgets/profile_btn.dart';
import 'package:heritage_map/provider/base_provider.dart';
import 'package:heritage_map/provider/user_provider.dart';
import 'package:heritage_map/widget/text_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProfileScreen extends ConsumerWidget {
  static const String routeName = 'Profile screen';
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final message = ref.watch(allmessageProvider);
    final isloading = ref.watch(isLoadingProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Ctext(
          text: "Your Profile",
          size: 32,
          weight: FontWeight.w700,
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: LocalStorage().gettoken(value: LocalSaveData.email),
            builder: (context, snap) {
              final userdata = ref.watch(userIndividualDataProvider(snap.data.toString()));

              // final msgdoc = ref.watch(messageDocumentsProvider(snap.data.toString()));

              return Column(
                children: [
                  const UserDetailsContainer(),
                  profileBtn(
                      tap: () async {
                        NavigatorService.pushNamed(EditProfileScreen.routeName);
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
                      },
                      image: 'assets/images/profile1.png',
                      text: "Persona"),
                  profileBtn(
                      tap: () async {
                        if (snap.data.toString() == LocalSaveData.adminEmail) {
                          NavigatorService.pushNamed(FourmScreen.routeName);
                        } else {
                          List<String> userlist = message.asData?.value.docs.map((e) {
                                return e.id;
                              }).toList() ??
                              [];
                          bool hasUser = userlist.toList().toString().toLowerCase().contains(snap.data.toString().toLowerCase());
                          if (hasUser) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AdminChat(
                                          sendId: snap.data.toString(),
                                          isAdmin: false,
                                        )));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NoChatFound(
                                          tap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => AdminChat(
                                                          sendId: snap.data.toString(),
                                                          isAdmin: false,
                                                        )));
                                          },
                                        )));
                          }

                          // if (msgdoc.asData?.value.map((e) => e['senderID']).toList().toString().contains(snap.data.toString()) ?? false) {
                          //   Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) => AdminChat(
                          //                 sendId: snap.data.toString(),
                          //               )));
                          // } else {
                          //   NavigatorService.pushNamed(FourmScreen.routeName);
                          // }
                        }
                      },
                      image: 'assets/images/message.png',
                      text: "Discussion Forum"),
                  if (snap.data.toString() == LocalSaveData.adminEmail)
                    profileBtn(
                        tap: () async {
                          NavigatorService.pushNamed(AddPlaceScreen.routeName);
                        },
                        image: 'assets/images/addlo.png',
                        text: "Add a Missing Place"),
                  profileBtn(
                      tap: () async {
                        // NavigatorService.pushNamed(AddPlaceScreen.routeName);
                        ref.read(isLoadingProvider.notifier).state = true;

                        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                        LatLng currentLocation = LatLng(position.latitude, position.longitude);
                        Share.share('https://www.google.com/maps/search/?api=1&query=${currentLocation.latitude},${currentLocation.longitude}');
                        ref.read(isLoadingProvider.notifier).state = false;
                      },
                      image: 'assets/images/addlo.png',
                      text: isloading ? "Loading ..." : "Share Your Location"),
                  profileBtn(
                      tap: () async {
                        showModalBottomSheet(
                            backgroundColor: AppColor.white,
                            context: context,
                            builder: (context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(28.0),
                                    child: Ctext(
                                      text: "Logout",
                                      size: 24,
                                      weight: FontWeight.w700,
                                    ),
                                  ),
                                  userdata.when(
                                      data: (data) {
                                        return RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            children: [
                                              const TextSpan(
                                                  text: " Are you sure you want to logout of ",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColor.grey,
                                                  )),
                                              TextSpan(
                                                  text: " ${data['fname']}  ${data['lname']}'s ",
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColor.black,
                                                  )),
                                              const TextSpan(
                                                  text: " account?",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColor.grey,
                                                  )),
                                            ],
                                          ),
                                        );
                                      },
                                      error: (e, r) => Ctext(text: e.toString()),
                                      loading: () => const SizedBox()),
                                  Padding(
                                    padding: const EdgeInsets.all(28.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: MaterialButton(
                                            height: 50,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                              side: const BorderSide(
                                                color: AppColor.black,
                                                width: 1,
                                              ),
                                            ),
                                            onPressed: () async {
                                              AuthService().logout().then((value) async {
                                                await LocalStorage().clear(key: LocalSaveData.email);
                                                await NavigatorService.pushNamedAndRemoveUntil(LoginScreen.routeName);
                                              });
                                            },
                                            child: const Ctext(text: "Logout"),
                                          ),
                                        ),
                                        AppSize.width28,
                                        Expanded(
                                          child: MaterialButton(
                                            height: 50,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            color: AppColor.primaryColor,
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Ctext(text: "Cancel"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              );
                            });
                      },
                      image: 'assets/images/logout.png',
                      text: "Logout")
                ],
              );
            }),
      ),
    );
  }
}
