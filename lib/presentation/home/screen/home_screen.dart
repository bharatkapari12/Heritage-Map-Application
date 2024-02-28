
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_map/core/const/app_size.dart';
import 'package:heritage_map/core/utils/navigator_service.dart';

import 'package:heritage_map/presentation/home/screen/search_screen.dart';
import 'package:heritage_map/presentation/home/widget/category_container.dart';
import 'package:heritage_map/presentation/home/widget/home_sites_container.dart';
import 'package:heritage_map/presentation/home/widget/search_btn.dart';
import 'package:heritage_map/presentation/home/widget/user_details.dart';

class HomeScreen extends ConsumerWidget {
  static const String routeName = "HomeScreen";
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Ctext(
      //     text: "HomeScreen",
      //   ),
      //   actions: [
      //     IconButton(
      //         onPressed: () async {
      //           AuthService().logout().then((value) async {
      //             await LocalStorage().clear(key: LocalSaveData.email);
      //             await NavigatorService.pushNamedAndRemoveUntil(LoginScreen.routeName);
      //           });
      //         },
      //         icon: Icon(Icons.logout))
      //   ],
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSize.height50,
              //user datails
              const UserDetailsContainer(
                text: "Explore your Favorite Heritage site",
              ),
              // search btn
              searchBtn(
                tap: () {
                  NavigatorService.pushNamed(SearchScreen.routeName);
                },
              ),
              // categotry
              const CategotyContainer(),
              // sites
              const HomeSitesContainer()
            ],
          ),
        ),
      ),
    );
  }
}
