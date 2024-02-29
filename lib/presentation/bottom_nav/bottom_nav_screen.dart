import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:heritage_map/core/const/app_color.dart';
import 'package:heritage_map/core/const/app_size.dart';
import 'package:heritage_map/presentation/fav/screen/fav_screen.dart';
import 'package:heritage_map/presentation/home/screen/home_screen.dart';
import 'package:heritage_map/presentation/map/screen/map_screen.dart';
import 'package:heritage_map/presentation/profile/screen/profile_screen.dart';
import 'package:heritage_map/widget/text_widget.dart';

final navIndexProvider = StateProvider<int>((ref) {
  return 0;
});

class NavigationScreen extends ConsumerWidget {
  static const routeName = 'NavigationScreen';
  NavigationScreen({super.key});
  final List<Widget> pages =  [
   const  HomeScreen(),
    const MapScreen(),
    const FavScreen(),
    const ProfileScreen(),
  ];
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {

        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(navIndexProvider);
    return Scaffold(
      backgroundColor: AppColor.white,
      body: pages[index],
      bottomNavigationBar: BottomAppBar(
        surfaceTintColor: AppColor.white,
        color: AppColor.white,
        height: 105,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BottomNavigationBar(
            currentIndex: index,
            backgroundColor: AppColor.white,
            selectedLabelStyle: const TextStyle(color: Colors.black),
            selectedItemColor: Colors.black,
            unselectedLabelStyle: const TextStyle(color: Colors.black),
            unselectedItemColor: Colors.black,
            showUnselectedLabels: false,
            showSelectedLabels: false,
            elevation: 10,
            onTap: (value) {
              if (value == 3) {
                _determinePosition();
              }
              ref.read(navIndexProvider.notifier).state = value;
            },
            items: [
              bottomItems(index, 'assets/images/home.png', 'Home', 0, AppColor.white),
              bottomItems(index, 'assets/images/map.png', 'Map', 1, AppColor.white),
              bottomItems(index, 'assets/images/fav.png', 'Wishlist', 2, AppColor.white),
              bottomItems(index, 'assets/images/user.png', 'Profile', 3, AppColor.white),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem bottomItems(int index, String image, String label, int currentindex, Color color) {
    return BottomNavigationBarItem(
        icon: index == currentindex
            ? Container(
                height: 40,
                width: 102,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                  color: AppColor.blackIconColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage(
                        image,
                      ),
                      color: color,
                    ),
                    AppSize.width8,
                    Ctext(
                      text: label,
                      size: 14,
                      weight: FontWeight.w600,
                      color: AppColor.white,
                    )
                  ],
                ))
            : Image(
                image: AssetImage(
                  image,
                ),
                color: AppColor.blackIconColor,
              ),
        label: label);
  }
}
