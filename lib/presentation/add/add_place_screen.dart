import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:heritage_map/core/const/app_color.dart';
import 'package:heritage_map/core/const/app_size.dart';
import 'package:heritage_map/core/utils/navigator_service.dart';
import 'package:heritage_map/data/model/place_model.dart';
import 'package:heritage_map/data/service/image_storage_service.dart';
import 'package:heritage_map/data/service/site_repo.dart';
import 'package:heritage_map/presentation/bottom_nav/bottom_nav_screen.dart';
import 'package:heritage_map/presentation/home/widget/category_container.dart';
import 'package:heritage_map/presentation/map/screen/map_search_screen.dart';
import 'package:heritage_map/provider/place_provider.dart';
import 'package:heritage_map/widget/text_field.dart';
import 'package:heritage_map/widget/text_widget.dart';

import 'package:image_picker/image_picker.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  static const String routeName = 'add place screen';
  const AddPlaceScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddFutsalPageState();
}

class _AddFutsalPageState extends ConsumerState<AddPlaceScreen> {
  XFile? image;
  XFile? logo;
  List<XFile>? images;
  final TextEditingController title = TextEditingController();
  final TextEditingController location = TextEditingController();
  final TextEditingController about = TextEditingController();
  final TextEditingController info = TextEditingController();
  final TextEditingController rating = TextEditingController();
  Future<void> pickImage() async {
    var media = ImagePicker();
    final List<XFile> pickedMedia = await media.pickMultipleMedia();

    setState(() {
      images = pickedMedia;
    });
  }

  String dropdownValue = categoryList.last;
  String cata = categoryList.last;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColor.white,
        title: const Ctext(
          text: "Add a place",
          size: 32,
          weight: FontWeight.w700,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: Ctext(
                text: "Place details",
                size: 24,
                weight: FontWeight.w700,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(18.0),
              child: Ctext(
                text: "Provide some information about the place or site you want to add. It will be verified & this place will be added to maps.",
                size: 14,
                line: 5,
                weight: FontWeight.w400,
                color: AppColor.grey,
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                image == null
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.4,
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.grey,
                          image: const DecorationImage(
                            image: AssetImage('assets/images/image1.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.grey,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: Image.file(
                          File(image?.path ?? 'NA'),
                          fit: BoxFit.cover,
                        ),
                      ),
                Positioned(
                  bottom: 10,
                  child: TextButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final img = await picker.pickImage(source: ImageSource.gallery);
                        setState(() {
                          image = img;
                        });
                      },
                      child: const Row(
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Upload a photo',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                          )
                        ],
                      )),
                ),
              ],
            ),
            customTextField(
              controller: title,
              label: 'Title',
            ),
            customTextField(
              controller: location,
              label: 'location',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const SizedBox(
                    width: 100,
                    child: Ctext(text: "Category : "),
                  ),
                  Expanded(
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      icon: const Icon(
                        Icons.arrow_downward,
                        color: Colors.white,
                      ),
                      elevation: 16,
                      style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 20),
                      underline: Container(
                        height: 4,
                        color: Colors.blue,
                      ),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          dropdownValue = value!;
                          cata = value;
                          log(cata);
                        });
                      },
                      items: categoryList.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      NavigatorService.pushNamed(MapSearchScreen.routeName);
                    },
                    child: const Image(
                      image: AssetImage('assets/images/latlon.png'),
                    ),
                  ),
                  AppSize.height15,
                  Ctext(text: "lat : ${ref.watch(selectedlatProvider)}"),
                  AppSize.height15,
                  Ctext(text: "lon :  ${ref.watch(selectedlonProvider)}"),
                ],
              ),
            ),
            customTextField(controller: info, label: 'info', maxline: 5),
            customTextField(controller: about, label: 'about', maxline: 8),
            customTextField(
              controller: rating,
              label: 'rating',
            ),
            TextButton(
                onPressed: () async {
                  final ImagePicker picker = ImagePicker();
                  final img = await picker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    logo = img;
                  });
                },
                child: const Ctext(
                  text: "Add Logo",
                )),
            logo == null
                ? const SizedBox.shrink()
                : Container(
                    margin: const EdgeInsets.all(20),
                    width: 200,
                    height: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(
                        File(logo?.path ?? 'NA'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: Ctext(
                text: "Place photos",
                size: 24,
                weight: FontWeight.w700,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(18.0),
              child: Ctext(
                text: "Add helpful photos, like heritage surrounding, areas, notices or sign.",
                size: 14,
                line: 2,
                weight: FontWeight.w400,
                color: AppColor.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: AppColor.black, width: 1)),
                onPressed: () {
                  pickImage();
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.image_search),
                    Ctext(
                      text: "Add Photos",
                    ),
                  ],
                ),
              ),
            ),
            images == null
                ? const SizedBox.shrink()
                : SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children: [
                        for (int i = 0; i < (images ?? []).length; i++)
                          Container(
                              width: 120,
                              margin: const EdgeInsets.all(10),
                              height: 80,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.file(
                                  File(images?[i].path ?? 'NA'),
                                  fit: BoxFit.cover,
                                ),
                              )),
                      ],
                    ),
                  ),
            AppSize.height50,
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      height: 50,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: AppColor.black, width: 1)),
                      onPressed: () {
                        NavigatorService.goBack();
                      },
                      child: const Ctext(
                        text: "Cancel",
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      height: 50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: AppColor.primaryColor,
                      onPressed: () async {
                        var photo = File(image?.path ?? 'NA');
                        var loo = File(logo?.path ?? 'NA');
                        List<File> photoList = images?.map((xFile) => File(xFile.path)).toList() ?? [];

                        if (image?.path.isNotEmpty == true && logo?.path.isNotEmpty == true && images?.isNotEmpty == true) {
                          await SiteRepo().addSite(
                            model: PlaceModel(
                                name: title.text,
                                location: location.text,
                                lon: ref.watch(selectedlonProvider),
                                lat: ref.watch(selectedlatProvider),
                                info: info.text,
                                about: about.text,
                                category: cata,
                                rating: rating.text),
                          );
                          showDialog(
                              context: NavigatorService.navigatorKey.currentContext ?? context,
                              builder: (context) {
                                return const AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Center(child: CircularProgressIndicator()),
                                    ],
                                  ),
                                );
                              });

                          await IamgeStorage().storeImage(photo: photo, name: title.text);
                          await IamgeStorage().storeIcon(photo: loo, name: title.text);
                          await IamgeStorage().addPhotos(photos: photoList, name: title.text);
                          ref.read(navIndexProvider.notifier).state = 0;
                          Navigator.pushReplacementNamed(NavigatorService.navigatorKey.currentContext ?? context, NavigationScreen.routeName);
                        } else {
                          Fluttertoast.showToast(msg: 'Please choose imaage and logo ');
                        }
                      },
                      child: const Ctext(
                        text: "Submit",
                      ),
                    ),
                  ),
                ),
              ],
            ),
            AppSize.height100,
          ],
        ),
      ),
    );
  }
}
