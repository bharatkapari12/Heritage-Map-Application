import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heritage_map/core/const/app_color.dart';
import 'package:heritage_map/core/const/app_size.dart';
import 'package:heritage_map/core/utils/navigator_service.dart';
import 'package:heritage_map/data/%20local%20storage/local_save_data.dart';
import 'package:heritage_map/data/%20local%20storage/local_storge.dart';
import 'package:heritage_map/data/model/place_model.dart';

import 'package:heritage_map/presentation/individual/screen/individual_image_place_screen.dart';

import 'package:heritage_map/provider/base_provider.dart';
import 'package:heritage_map/provider/place_provider.dart';
import 'package:heritage_map/provider/user_provider.dart';
import 'package:heritage_map/widget/fab_btn.dart';
import 'package:heritage_map/widget/text_widget.dart';

class HomeSitesContainer extends ConsumerWidget {
  const HomeSitesContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final choosed = ref.watch(choosedCategoryValueProvider);
    final place = ref.watch(placeDataProvider);

    return FutureBuilder(
        future: LocalStorage().gettoken(value: LocalSaveData.email),
        builder: (context, snap) {
          final user = ref.watch(userIndividualDataProvider(snap.data.toString()));

          return place.when(
              data: (data) {
                List filteredDocs = data.docs.where((doc) => doc['category'].toString().toLowerCase().contains(choosed.toLowerCase())).toList();

                return Container(
                  margin: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Ctext(text: choosed),
                      AppSize.height15,
                      SizedBox(
                        height: 255,
                        child: ListView.builder(
                          itemCount: filteredDocs.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            List<dynamic> explorelist = user.asData?.value['explore'] ?? [];
                            bool myFav = explorelist.contains(filteredDocs[index]['name']);
                            return GestureDetector(
                              onTap: () {
                                final PlaceModel model = PlaceModel(
                                    id: filteredDocs[index].id,
                                    name: filteredDocs[index]['name'],
                                    lat: filteredDocs[index]['lat'],
                                    lon: filteredDocs[index]['lon'],
                                    logo: filteredDocs[index]['logo'],
                                    location: filteredDocs[index]['location'],
                                    images: filteredDocs[index]['images'],
                                    photo: filteredDocs[index]['photo'],
                                    about: filteredDocs[index]['about'],
                                    info: filteredDocs[index]['info'],
                                    explorePeople: filteredDocs[index]['explorePeople'],
                                    rating: filteredDocs[index]['rating'],
                                    category: filteredDocs[index]['category'],
                                    email: snap.data.toString(),
                                    isfav: myFav);
                                NavigatorService.pushNamed(IndividualImageScreen.routeName, arguments: model);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(left: 10),
                                width: 190,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(17),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      filteredDocs[index]['photo'],
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(17),
                                    color: AppColor.black.withOpacity(0.5),
                                  ),
                                  padding: const EdgeInsets.all(6),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: FavBtn(value: filteredDocs[index]['name']),
                                      ),
                                      const Spacer(),
                                      Row(
                                        children: [
                                          Image(
                                            height: 40,
                                            width: 40,
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                              filteredDocs[index]['logo'],
                                            ),
                                          ),
                                          AppSize.width8,
                                          SizedBox(
                                            width: 130,
                                            child: Ctext(
                                              text: filteredDocs[index]['name'],
                                              size: 14,
                                              line: 2,
                                              align: TextAlign.start,
                                              weight: FontWeight.w600,
                                              color: AppColor.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            const Image(
                                              image: AssetImage('assets/images/location.png'),
                                              color: AppColor.white,
                                            ),
                                            AppSize.width8,
                                            SizedBox(
                                              width: 130,
                                              child: Ctext(
                                                line: 1,
                                                text: filteredDocs[index]['location'],
                                                size: 12,
                                                align: TextAlign.start,
                                                weight: FontWeight.w500,
                                                color: AppColor.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Row(
                                            children: List.generate(
                                              5,
                                              (index) => Icon(
                                                Icons.star_rate_rounded,
                                                color: index == 4 ? AppColor.white : AppColor.primaryColor,
                                              ),
                                            ),
                                          ),
                                          AppSize.width15,
                                          Ctext(
                                            text: filteredDocs[index]['rating'],
                                            size: 16,
                                            weight: FontWeight.w600,
                                            color: AppColor.white,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
              error: (e, r) => Ctext(text: e.toString()),
              loading: () => const CircularProgressIndicator());
        });
  }
}