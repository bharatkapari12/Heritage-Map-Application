import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heritage_map/core/const/app_color.dart';
import 'package:heritage_map/core/const/app_size.dart';
import 'package:heritage_map/core/utils/navigator_service.dart';
import 'package:heritage_map/data/model/place_model.dart';
import 'package:heritage_map/data/service/site_repo.dart';

import 'package:heritage_map/presentation/individual/screen/individual_place_screen.dart';
import 'package:heritage_map/widget/fab_btn.dart';

import 'package:heritage_map/widget/my_btn.dart';
import 'package:heritage_map/widget/text_widget.dart';

class IndividualImageScreen extends ConsumerWidget {
  static const String routeName = 'IndividualImageScreen';
  const IndividualImageScreen({super.key, required this.model});
  final PlaceModel model;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: PageView(
        children: [
          indiPage(context, 0),
          indiPage(context, 1),
          indiPage(context, 2),
        ],
      ),
    );
  }

  Container indiPage(BuildContext context, int index) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            model.images?[index] ?? 'Na',
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(color: AppColor.black.withOpacity(0.4)),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      color: AppColor.white,
                    ),
                  ),
                  FavBtn(value: model.name ?? "Na"),
                ],
              ),
              const Spacer(),
              const Spacer(),
              model.isfav == true
                  ? const Row(
                      children: [
                        Ctext(
                          text: "FAVORITE PLACE",
                          size: 16,
                          weight: FontWeight.w400,
                          color: AppColor.white,
                        ),
                        AppSize.width15,
                        Image(
                          image: AssetImage(
                            "assets/images/check1.png",
                          ),
                          color: AppColor.white,
                        )
                      ],
                    )
                  : const SizedBox.shrink(),
              AppSize.height50,
              Ctext(
                text: model.name ?? 'Na',
                size: 32,
                line: 2,
                weight: FontWeight.w600,
                color: AppColor.white,
              ),
              AppSize.height15,
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
                      line: 1,
                      text: model.location ?? "NA",
                      size: 14,
                      weight: FontWeight.w500,
                      color: AppColor.white,
                    ),
                  ),
                ],
              ),
              AppSize.height15,
              if (model.explorePeople?.isNotEmpty == true)
                Ctext(
                  line: 1,
                  text: '${model.explorePeople?.length}+ people have explored',
                  size: 18,
                  weight: FontWeight.w600,
                  color: AppColor.white,
                ),
              AppSize.height15,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppSize.width100,
                  if (model.images!.isNotEmpty) overLapImage(image: model.images?[0] ?? 'Na', xdir: 0),
                  if (model.images!.length > 1) overLapImage(image: model.images?[1] ?? 'Na', xdir: -20),
                  if (model.images!.length > 2) overLapImage(image: model.images?[2] ?? 'Na', xdir: -40),
                  if (model.images!.length > 3) overLapImage(image: model.images?[3] ?? 'Na', xdir: -60),
                  if (model.images!.length > 4) overLapImage(image: model.images?[4] ?? 'Na', xdir: -80),
                ],
              ),
              AppSize.height15,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppSize.width28,
                  ...List.generate(
                      3,
                      (dotIndex) => Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            height: 5,
                            width: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: dotIndex == index ? AppColor.white : AppColor.grey,
                            ),
                          )))
                ],
              ),
              AppSize.height15,
              Ctext(
                text: model.info ?? 'Na',
                size: 14,
                line: 6,
                weight: FontWeight.w400,
                color: AppColor.white,
              ),
              AppSize.height50,
              Row(
                children: [
                  Image(height: 40, width: 40, image: NetworkImage(model.logo ?? 'NA')),
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
                    text: model.rating ?? '5.0',
                    size: 16,
                    weight: FontWeight.w600,
                    color: AppColor.white,
                  ),
                ],
              ),
              AppSize.height50,
              myBtn("Visit Now", tap: () async {
                await SiteRepo().addExplore(model.name ?? 'Na', model.email ?? "Na");
                NavigatorService.pushNamed(IndividualScreen.routeName, arguments: model);
              }),
              AppSize.height50,
            ],
          ),
        ),
      ),
    );
  }

  Transform overLapImage({required String image, required double xdir}) {
    return Transform.translate(
      offset: Offset(xdir, 0),
      child: CircleAvatar(
        radius: 25,
        backgroundColor: AppColor.white,
        child: CircleAvatar(
          backgroundImage: NetworkImage(image),
          radius: 23,
        ),
      ),
    );
  }
}
