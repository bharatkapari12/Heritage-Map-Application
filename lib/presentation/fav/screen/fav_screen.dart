import 'package:cloud_firestore/cloud_firestore.dart';
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

class FavScreen extends ConsumerWidget {
  static const String routeName = 'Fav screen';
  const FavScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Ctext(
          text: "Your Wishlist",
          size: 32,
          weight: FontWeight.w700,
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: LocalStorage().gettoken(value: LocalSaveData.email),
            builder: (context, snap) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: TextField(
                      onChanged: (value) {
                        ref.read(searchControllerProvider.notifier).state = value;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        suffixIcon: const Image(image: AssetImage('assets/images/search.png')),
                        fillColor: AppColor.grey.withOpacity(0.1),
                        hintText: "Search Heritage Site",
                        border: AppColor.enableBorderStyle,
                      ),
                    ),
                  ),
                  SizedBox(
                    // height: MediaQuery.of(context).size.height * 0.7,
                    child: Consumer(builder: (context, ref, child) {
                      final user = ref.watch(userIndividualDataProvider(snap.data.toString()));
                      final place = ref.watch(placeDataProvider);
                      var search = ref.watch(searchControllerProvider);

                      return user.when(
                          data: (userData) {
                            List<dynamic> userExplore = userData['explore'] ?? [];
                            return place.when(
                                data: (data) {
                                  List<QueryDocumentSnapshot> filteredData = filterDatabyName(data, userExplore, search);

                                  return ListView.builder(
                                      itemCount: filteredData.length,
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      primary: false,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            final PlaceModel model = PlaceModel(
                                              id: filteredData[index].id,
                                              name: filteredData[index]['name'],
                                              lat: filteredData[index]['lat'],
                                              lon: filteredData[index]['lon'],
                                              location: filteredData[index]['location'],
                                              images: filteredData[index]['images'],
                                              photo: filteredData[index]['photo'],
                                              about: filteredData[index]['about'],
                                              info: filteredData[index]['info'],
                                              explorePeople: filteredData[index]['explorePeople'],
                                              rating: filteredData[index]['rating'],
                                              category: filteredData[index]['category'],
                                              logo: filteredData[index]['logo'],
                                              email: snap.data,
                                            );
                                            NavigatorService.pushNamed(IndividualImageScreen.routeName, arguments: model);
                                          },
                                          child: Container(
                                            height: 200,
                                            margin: const EdgeInsets.all(15),
                                            width: double.infinity,
                                            decoration:
                                                BoxDecoration(borderRadius: BorderRadius.circular(20), color: AppColor.white, boxShadow: const [
                                              BoxShadow(color: AppColor.black, blurRadius: 2),
                                            ]),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 140,
                                                  margin: const EdgeInsets.all(13),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(18),
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                        filteredData[index]['photo'],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 110,
                                                          child: Ctext(
                                                            text: filteredData[index]['name'],
                                                            size: 18,
                                                            line: 3,
                                                            weight: FontWeight.w600,
                                                            color: AppColor.black,
                                                          ),
                                                        ),
                                                        FavBtn(value: filteredData[index]['name']),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 170,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Row(
                                                            children: List.generate(
                                                              5,
                                                              (index) => Icon(
                                                                Icons.star_rate_rounded,
                                                                color: index == 4 ? AppColor.grey : AppColor.primaryColor,
                                                              ),
                                                            ),
                                                          ),
                                                          AppSize.width15,
                                                          SizedBox(
                                                            width: 30,
                                                            child: Ctext(
                                                              text: filteredData[index]['rating'],
                                                              size: 16,
                                                              weight: FontWeight.w600,
                                                              color: AppColor.black,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    AppSize.height15,
                                                    SizedBox(
                                                      width: 210,
                                                      child: Ctext(
                                                        text: filteredData[index]['info'],
                                                        size: 13,
                                                        line: 3,
                                                        weight: FontWeight.w400,
                                                        color: AppColor.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                },
                                error: (e, r) => Ctext(text: e.toString()),
                                loading: () => const SizedBox.shrink());
                          },
                          error: (e, r) => Ctext(text: e.toString()),
                          loading: () => const SizedBox.shrink());
                    }),
                  )
                ],
              );
            }),
      ),
    );
  }
}

List<QueryDocumentSnapshot> filterDatabyName(QuerySnapshot snapshot, List<dynamic> searchStrings, String searchText) {
  return snapshot.docs.where((doc) {
    final name = doc['name']?.toString().toLowerCase() ?? '';

    return searchStrings.any((searchString) => name.contains(searchString.toString().toLowerCase())) && name.contains(searchText.toLowerCase());
  }).toList();
}
