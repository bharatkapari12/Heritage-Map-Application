import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heritage_map/core/utils/navigator_service.dart';
import 'package:heritage_map/provider/place_provider.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

class MapSearchScreen extends ConsumerWidget {
  static const String routeName = 'map search screen';
  const MapSearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: OpenStreetMapSearchAndPick(
          // center: LatLong(23, 89),
          buttonColor: Colors.blue,
          buttonText: 'Set Current Location',
          onPicked: (pickedData) {
            ref.read(selectedlatProvider.notifier).state = pickedData.latLong.latitude;
            ref.read(selectedlonProvider.notifier).state = pickedData.latLong.longitude;
            NavigatorService.goBack();
            log(pickedData.latLong.latitude);
            log(pickedData.latLong.longitude);
            if (kDebugMode) {
              print(pickedData.address);
            }
          }),
    );
  }
}
