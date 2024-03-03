import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heritage_map/core/const/app_color.dart';
import 'package:heritage_map/core/const/app_size.dart';
import 'package:heritage_map/core/utils/navigator_service.dart';
import 'package:heritage_map/data/%20local%20storage/local_save_data.dart';
import 'package:heritage_map/data/%20local%20storage/local_storge.dart';
import 'package:heritage_map/data/model/place_model.dart';
import 'package:heritage_map/data/service/site_repo.dart';
import 'package:heritage_map/presentation/add/edit_place_screen.dart';
import 'package:heritage_map/presentation/bottom_nav/bottom_nav_screen.dart';

import 'package:heritage_map/provider/base_provider.dart';
import 'package:heritage_map/provider/place_provider.dart';
import 'package:heritage_map/widget/fab_btn.dart';

import 'package:heritage_map/widget/text_widget.dart';
import 'package:latlong2/latlong.dart';

class IndividualScreen extends ConsumerWidget {
  static const String routeName = 'Individual Screen';

  IndividualScreen({super.key, required this.model});

  final PlaceModel model;
  final MapController mapController = MapController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readMore = ref.watch(readMoreProvider);
    final showAll = ref.watch(showAllProvider);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      NavigatorService.goBack();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: AppColor.black,
                    ),
                  ),
                  FutureBuilder(
                      future:
                          LocalStorage().gettoken(value: LocalSaveData.email),
                      builder: (context, snap) {
                        return Row(
                          children: [
                            FavBtn(value: model.name ?? "Na"),
                            if (snap.data.toString() ==
                                LocalSaveData.adminEmail)
                              Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: PopupMenuButton(
                                  onSelected: (String value) async {
                                    if (value == 'edit') {
                                      if (ref.watch(selectedlatProvider) ==
                                          0.0) {
                                        ref
                                            .read(selectedlatProvider.notifier)
                                            .state = model.lat ?? 0.0;
                                      }
                                      if (ref.watch(selectedlonProvider) ==
                                          0.0) {
                                        ref
                                            .read(selectedlonProvider.notifier)
                                            .state = model.lon ?? 0.0;
                                      }
                                      NavigatorService.pushNamed(
                                          EditPlaceScreen.routeName,
                                          arguments: model);
                                    }
                                    if (value == 'delete') {
                                      await SiteRepo()
                                          .deleteSite(model.id ?? 'Na')
                                          .then((value) {
                                        ref
                                            .read(navIndexProvider.notifier)
                                            .state = 0;
                                        Navigator.pushReplacementNamed(
                                            NavigatorService.navigatorKey
                                                    .currentContext ??
                                                context,
                                            NavigationScreen.routeName);
                                      });
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.more_vert,
                                    color: Colors.grey,
                                  ),
                                  itemBuilder: (context) {
                                    return [
                                      const PopupMenuItem(
                                          value: 'edit',
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.edit,
                                                size: 16,
                                              ),
                                              AppSize.width15,
                                              Text(
                                                "Edit",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                            ],
                                          )),
                                      const PopupMenuItem(
                                        value: 'delete',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.delete,
                                              color: AppColor.red,
                                              size: 17,
                                            ),
                                            AppSize.width15,
                                            Text(
                                              "Delete",
                                              style: TextStyle(
                                                color: AppColor.red,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ];
                                  },
                                ),
                              ),
                          ],
                        );
                      }),
                ],
              ),
              topImageContianer(),
              aboutPlaceDetails(readMore, ref),
              galleryConainer(ref, showAll),
              IndividualScreenMap(mapController: mapController, model: model),
              AppSize.height50,
            ],
          ),
        ),
      ),
    );
  }

  Container galleryConainer(WidgetRef ref, bool showAll) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Ctext(
                text: "Gallery Photo",
                size: 20,
                weight: FontWeight.w600,
              ),
              TextButton(
                  onPressed: () {
                    ref.read(showAllProvider.notifier).state = !showAll;
                  },
                  child: Text(showAll ? "Show less" : "Show all"))
            ],
          ),
          GridView.builder(
              primary: false,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemCount: showAll ? model.images?.length : 3,
              itemBuilder: (context, index) {
                return Container(
                  height: 88,
                  width: 88,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          model.images?[index],
                        ),
                      )),
                );
              })
        ],
      ),
    );
  }

  Container aboutPlaceDetails(bool readMore, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.all(12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Ctext(
          text: "About Place",
          weight: FontWeight.w600,
          size: 20,
        ),
        AppSize.height28,
        Ntext(
          text: model.info ?? 'Na',
          weight: FontWeight.w400,
          size: 14,
        ),
        AppSize.height15,
        readMore
            ? Ntext(
                text: model.about ?? 'Na',
                weight: FontWeight.w400,
                size: 14,
              )
            : const SizedBox.shrink(),
        TextButton(
            onPressed: () {
              ref.read(readMoreProvider.notifier).state = !readMore;
            },
            child: Ctext(
              text: readMore ? "Show less" : "Read More",
              color: AppColor.blue,
              weight: FontWeight.w400,
              size: 16,
            ))
      ]),
    );
  }

  Container topImageContianer() {
    return Container(
      height: 270,
      margin: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(model.photo ?? 'Na'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColor.black.withOpacity(
            0.4,
          ),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 290,
              child: Ctext(
                text: model.name ?? 'NA',
                size: 20,
                line: 2,
                weight: FontWeight.w600,
                color: AppColor.white,
              ),
            ),
            Row(
              children: [
                const Image(
                  image: AssetImage('assets/images/location.png'),
                  color: AppColor.white,
                ),
                AppSize.width15,
                SizedBox(
                  width: 290,
                  child: Ctext(
                    line: 2,
                    text: model.location ?? "Na",
                    size: 14,
                    weight: FontWeight.w500,
                    color: AppColor.white,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Ctext(
                line: 1,
                text: '${model.explorePeople?.length}+ people have explored',
                size: 18,
                weight: FontWeight.w600,
                color: AppColor.white,
              ),
            ),
            Row(
              children: [
                Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      Icons.star_rate_rounded,
                      color:
                          index == 4 ? AppColor.white : AppColor.primaryColor,
                    ),
                  ),
                ),
                AppSize.width15,
                Ctext(
                  text: model.rating ?? '4.6',
                  size: 16,
                  weight: FontWeight.w600,
                  color: AppColor.white,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class IndividualScreenMap extends StatelessWidget {
  const IndividualScreenMap({
    super.key,
    required this.mapController,
    required this.model,
  });

  final MapController mapController;
  final PlaceModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Ctext(
            text: "Location",
            size: 20,
            weight: FontWeight.w600,
          ),
          Container(
            height: 200,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    initialCenter: LatLng(model.lat ?? 0.0, model.lon ?? 0.0),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(model.lat ?? 0.0, model.lon ?? 0.0),
                          height: 90,
                          width: 200,
                          child: Column(
                            children: [
                              Ctext(
                                line: 2,
                                text: model.name ?? 'NA',
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
                      ],
                    ),
                    RichAttributionWidget(
                      attributions: [
                        TextSourceAttribution('OpenStreetMap contributors',
                            onTap: () {}),
                      ],
                    ),
                  ],
                ),
                Container(
                  height: 120,
                  width: 80,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColor.white.withOpacity(0.8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
