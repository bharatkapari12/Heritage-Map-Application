import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:heritage_map/core/utils/navigator_service.dart';
import 'package:heritage_map/firebase_options.dart';
import 'package:heritage_map/presentation/auth/auth_screen.dart';
import 'package:heritage_map/presentation/boarding_page/screen/boarding_screen.dart';
import 'package:heritage_map/routes/app.route.dart';
import 'package:shared_preferences/shared_preferences.dart';

int? initialScreen;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  initialScreen = sharedPreferences.getInt('initialScreen');
  await sharedPreferences.setInt('initialScreen', 1);
  runApp(ProviderScope(
      child: MyApp(
    route: AppRoue(),
  )));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.route});

  final AppRoue route;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      builder: FToastBuilder(),
      onGenerateRoute: route.onGenerateRoute,
      navigatorKey: NavigatorService.navigatorKey,
      initialRoute: initialScreen == 0 || initialScreen == null
          ? BoardingScreen.routeName
          : AuthScreen.routeName,
    );
  }
}
