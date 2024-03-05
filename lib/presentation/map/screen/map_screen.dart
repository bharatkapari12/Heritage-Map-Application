import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_map/core/const/app_color.dart';
import 'package:heritage_map/core/utils/navigator_service.dart';
import 'package:heritage_map/data/%20local%20storage/local_save_data.dart';
import 'package:heritage_map/data/%20local%20storage/local_storge.dart';
import 'package:heritage_map/data/model/place_model.dart';
import 'package:heritage_map/presentation/individual/screen/individual_image_place_screen.dart';

import 'package:heritage_map/provider/place_provider.dart';
import 'package:heritage_map/provider/user_provider.dart';
import 'package:heritage_map/widget/text_widget.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends ConsumerWidget {
  static const String routeName = "MapScreen";
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Create a MapController to control the map
    MapController mapController = MapController();
    // final currentLocationController = ref.read(currentLocationProvider);

    // Function to handle marker tap
    // void onMarkerTap(LatLng markerLocation) async {
    //   Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    //   LatLng currentLocation = LatLng(position.latitude, position.longitude);

    //   ref.read(polylineValueProvider.notifier).state = Polyline(
    //     points: [currentLocation, markerLocation],
    //     color: Colors.blue,
    //     strokeWidth: 3.0,
    //   );
    //   ref.read(tapLatLonValueProvider.notifier).state = markerLocation;
    //   ref.read(currentLatLonValueProvider.notifier).state = currentLocation;
    //     }

    final tapValue = ref.watch(tapLatLonValueProvider);
    final place = ref.watch(placeDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Ctext(
          text: "Your Map",
          size: 32,
          weight: FontWeight.w700,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: place.when(
                data: (data) {
                  return SizedBox(
                    child: FlutterMap(
                      mapController: mapController,
                      options: MapOptions(
                        initialCenter: const LatLng(27.7172, 85.3240),
                        onTap: (tapPosition, point) {
                          // ref.read(polylineValueProvider.notifier).state = null;
                        },
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.app',
                        ),
                        MarkerLayer(
                            markers: data.docs.asMap().entries.map((e) {
                          return Marker(
                            point: LatLng(e.value['lat'], e.value['lon']),
                            height: 90,
                            width: 200,
                            child: FutureBuilder(
                                future: LocalStorage().gettoken(value: LocalSaveData.email),
                                builder: (context, snap) {
                                  final user = ref.watch(userIndividualDataProvider(snap.data.toString()));

                                  List<dynamic> explorelist = user.asData?.value['explore'] ?? [];
                                  bool myFav = explorelist.contains(e.value['name']);
                                  return GestureDetector(
                                    onTap: () {
                                      // onMarkerTap(LatLng(e.value['lat'], e.value['lon']));
                                      final PlaceModel model = PlaceModel(
                                          id: e.value.id,
                                          name: e.value['name'],
                                          lat: e.value['lat'],
                                          lon: e.value['lon'],
                                          logo: e.value['logo'],
                                          location: e.value['location'],
                                          images: e.value['images'],
                                          photo: e.value['photo'],
                                          about: e.value['about'],
                                          info: e.value['info'],
                                          explorePeople: e.value['explorePeople'],
                                          rating: e.value['rating'],
                                          category: e.value['category'],
                                          email: snap.data.toString(),
                                          isfav: myFav);
                                      NavigatorService.pushNamed(IndividualImageScreen.routeName, arguments: model);
                                    },
                                    child: Column(
                                      children: [
                                        Ctext(
                                          line: 2,
                                          text: e.value['name'],
                                          size: 14,
                                          weight: FontWeight.w700,
                                        ),
                                        // Image(
                                        //   height: 40,
                                        //   width: 40,
                                        //   fit: BoxFit.cover,
                                        //   image: NetworkImage(
                                        //     e.value['logo'],
                                        //   ),
                                        // ),
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            const Icon(
                                              Icons.location_on,
                                              // color: Colors.red,
                                              size: 70,
                                            ),
                                            Positioned(
                                              top: 12,
                                              child: Image(
                                                height: 25,
                                                width: 25,
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                  e.value['logo'],
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                }),
                          );
                        }).toList()),
                        RichAttributionWidget(
                          attributions: [
                            TextSourceAttribution('OpenStreetMap contributors', onTap: () {}),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                error: (e, r) => Ctext(text: e.toString()),
                loading: () => const Center(
                      child: CircularProgressIndicator(),
                    )),
          ),
        ],
      ),
      floatingActionButton: Container(
        height: 120,
        width: 80,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColor.white.withOpacity(0.8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            MaterialButton(
              onPressed: () {
                // Zoom In
                mapController.move(mapController.camera.center, mapController.camera.zoom + 1.0);
              },
              child: const Icon(Icons.zoom_in),
            ),
            const Divider(),
            MaterialButton(
              onPressed: () {
                // Zoom Out
                mapController.move(mapController.camera.center, mapController.camera.zoom - 1.0);
              },
              child: const Icon(Icons.zoom_out),
            ),
          ],
        ),
      ),
    );
  }
}