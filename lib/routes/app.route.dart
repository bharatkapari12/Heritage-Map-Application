import 'package:flutter/material.dart';
import 'package:heritage_map/data/model/place_model.dart';
import 'package:heritage_map/presentation/add/add_place_screen.dart';
import 'package:heritage_map/presentation/add/edit_place_screen.dart';
import 'package:heritage_map/presentation/auth/auth_screen.dart';
import 'package:heritage_map/presentation/auth/forget_password_screen.dart';
import 'package:heritage_map/presentation/auth/login_screen.dart';
import 'package:heritage_map/presentation/auth/register_screen.dart';
import 'package:heritage_map/presentation/auth/successfully_created_screen.dart';
import 'package:heritage_map/presentation/boarding_page/screen/boarding_screen.dart';
import 'package:heritage_map/presentation/bottom_nav/bottom_nav_screen.dart';
import 'package:heritage_map/presentation/fav/screen/fav_screen.dart';
import 'package:heritage_map/presentation/home/screen/home_screen.dart';
import 'package:heritage_map/presentation/home/screen/search_screen.dart';

import 'package:heritage_map/presentation/individual/screen/individual_image_place_screen.dart';
import 'package:heritage_map/presentation/individual/screen/individual_place_screen.dart';
import 'package:heritage_map/presentation/map/screen/map_screen.dart';
import 'package:heritage_map/presentation/map/screen/map_search_screen.dart';
import 'package:heritage_map/presentation/profile/screen/edit_profile_screen.dart';
import 'package:heritage_map/presentation/profile/screen/fourm_screen.dart';
import 'package:heritage_map/presentation/profile/screen/profile_screen.dart';
import 'package:heritage_map/presentation/profile/screen/start_chat_screen.dart';
import 'package:heritage_map/widget/text_widget.dart';

class AppRoue {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case AuthScreen.routeName:
        return MaterialPageRoute(builder: (context) => AuthScreen());

      case HomeScreen.routeName:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      case IndividualImageScreen.routeName:
        return MaterialPageRoute(builder: (context) {
          final PlaceModel model = routeSettings.arguments as PlaceModel;
          return IndividualImageScreen(
            model: model,
          );
        });
      case IndividualScreen.routeName:
        return MaterialPageRoute(builder: (context) {
          final PlaceModel model = routeSettings.arguments as PlaceModel;
          return IndividualScreen(
            model: model,
          );
        });
      case EditPlaceScreen.routeName:
        return MaterialPageRoute(builder: (context) {
          final PlaceModel model = routeSettings.arguments as PlaceModel;
          return EditPlaceScreen(
            model: model,
          );
        });

      case MapScreen.routeName:
        return MaterialPageRoute(builder: (context) => const MapScreen());
      case AddPlaceScreen.routeName:
        return MaterialPageRoute(builder: (context) => const AddPlaceScreen());
      case NavigationScreen.routeName:
        return MaterialPageRoute(builder: (context) => NavigationScreen());
      case ProfileScreen.routeName:
        return MaterialPageRoute(builder: (context) => const ProfileScreen());
      case SearchScreen.routeName:
        return MaterialPageRoute(builder: (context) => const SearchScreen());
      case FavScreen.routeName:
        return MaterialPageRoute(builder: (context) => const FavScreen());
      case FourmScreen.routeName:
        return MaterialPageRoute(builder: (context) => const FourmScreen());
      case StartChatScreen.routeName:
        return MaterialPageRoute(builder: (context) => StartChatScreen());
      case MapSearchScreen.routeName:
        return MaterialPageRoute(builder: (context) => const MapSearchScreen());

      case BoardingScreen.routeName:
        return MaterialPageRoute(builder: (context) => BoardingScreen());

      case SuccessfullyCreatedScreen.routeName:
        return MaterialPageRoute(builder: (context) => const SuccessfullyCreatedScreen());

      case EditProfileScreen.routeName:
        return MaterialPageRoute(builder: (context) => const EditProfileScreen());

      case LoginScreen.routeName:
        return MaterialPageRoute(builder: (context) => const LoginScreen());

      case RegisterScreen.routeName:
        return MaterialPageRoute(builder: (context) => const RegisterScreen());
      case ForgetPasswordScreen.routeName:
        return MaterialPageRoute(builder: (context) => ForgetPasswordScreen());

      default:
        return MaterialPageRoute(
            builder: (context) => Scaffold(
                  appBar: AppBar(),
                  body: const Center(
                    child: Ctext(text: "No Route Found !!"),
                  ),
                ));
    }
  }
}
