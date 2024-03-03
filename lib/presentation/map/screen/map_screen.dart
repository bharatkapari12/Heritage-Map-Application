import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heritage_map/core/const/app_color.dart';
import 'package:heritage_map/provider/place_provider.dart';
import 'package:heritage_map/widget/text_widget.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends ConsumerWidget {
  static const String routeName = "MapScreen";
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Create a MapController to control the map
    MapController mapController = MapController();

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
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.app',
                        ),
                        MarkerLayer(
                            markers: data.docs.asMap().entries.map((e) {
                          return Marker(
                            point: LatLng(e.value['lat'], e.value['lon']),
                            height: 90,
                            width: 200,
                            child: GestureDetector(
                              onTap: () {
                                // onMarkerTap(LatLng(e.value['lat'], e.value['lon']));
                              },
                              child: Column(
                                children: [
                                  Ctext(
                                    line: 2,
                                    text: e.value['name'],
                                    size: 14,
                                    weight: FontWeight.w400,
                                  ),
                                  const Icon(
                                    Icons.location_on,
                                    color: AppColor.red,
                                    size: 30,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList()

                            // [
                            //   Marker(
                            //     point: LatLng(27.7172, 85.3240),
                            //     height: 30,
                            //     width: 30,
                            //     child: GestureDetector(
                            //         onTap: () {
                            //           onMarkerTap(LatLng(27.7172, 85.3240));
                            //         },
                            //         child: ColoredBox(color: Colors.red[900]!)),
                            //   ),
                            //   Marker(
                            //     point: LatLng(27.7262, 85.3240),
                            //     height: 30,
                            //     width: 30,
                            //     child: GestureDetector(
                            //         onTap: () {
                            //           onMarkerTap(LatLng(27.7262, 85.3240));
                            //         },
                            //         child: ColoredBox(color: Colors.blue[900]!)),
                            //   ),
                            // ],
                            ),
                        // PolylineLayer(
                        //   polylines: [
                        //     if (ref.watch(polylineValueProvider) != null)
                        //       Polyline(
                        //         points: [
                        //           ref.watch(currentLatLonValueProvider),
                        //           tapValue,
                        //         ],
                        //         color: Colors.blue,
                        //         strokeWidth: 2,
                        //       ),
                        //   ],
                        // ),
                        RichAttributionWidget(
                          attributions: [
                            TextSourceAttribution('OpenStreetMap contributors',
                                onTap: () {}),
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
                mapController.move(mapController.camera.center,
                    mapController.camera.zoom + 1.0);
              },
              child: const Icon(Icons.zoom_in),
            ),
            const Divider(),
            MaterialButton(
              onPressed: () {
                // Zoom Out
                mapController.move(mapController.camera.center,
                    mapController.camera.zoom - 1.0);
              },
              child: const Icon(Icons.zoom_out),
            ),
          ],
        ),
      ),
    );
  }
}
