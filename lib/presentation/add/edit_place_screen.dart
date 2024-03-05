import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class EditPlaceScreen extends ConsumerStatefulWidget {
  static const String routeName = 'edit place screen';
  final PlaceModel model;
  const EditPlaceScreen({super.key, required this.model});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddFutsalPageState();
}

class _AddFutsalPageState extends ConsumerState<EditPlaceScreen> {
  XFile? image;
  XFile? logo;
  List<XFile>? images;

  Future<void> pickImage() async {
    var media = ImagePicker();
    final List<XFile> pickedMedia = await media.pickMultipleMedia();

    setState(() {
      images = pickedMedia;
    });
  }

  List<dynamic> imagg = [];

  late TextEditingController title;
  late TextEditingController location;
  late TextEditingController about;
  late TextEditingController info;
  late TextEditingController rating;

  @override
  void initState() {
    // TODO: implement initState
    title = TextEditingController(text: widget.model.name);
    location = TextEditingController(text: widget.model.location);
    info = TextEditingController(text: widget.model.info);
    rating = TextEditingController(text: widget.model.rating);
    about = TextEditingController(text: widget.model.about);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sites = ref.watch(siteIndividualDataProvider(widget.model.id ?? 'NA'));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColor.white,
        title: const Ctext(
          text: "Edit a place",
          size: 32,
          weight: FontWeight.w700,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Ctext(
                text: "${widget.model.name} details",
                size: 24,
                line: 2,
                align: TextAlign.start,
                weight: FontWeight.w700,
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
                          image: DecorationImage(
                            image: NetworkImage(widget.model.photo ?? 'NA'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.4,
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.grey,
                          image: DecorationImage(
                            image: FileImage(
                              File(image?.path ?? 'NA'),
                            ),
                            fit: BoxFit.cover,
                          ),
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
              onlyread: true,
              label: 'Title',
            ),
            customTextField(
              controller: location,
              label: 'location',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  const SizedBox(
                    width: 100,
                    child: Ctext(text: "Category : "),
                  ),
                  Expanded(
                    child: DropdownButton<String>(
                      value: widget.model.category,
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
                          widget.model.category = value!;
                          widget.model.category = value;
                          log(widget.model.category.toString());
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
              child: Consumer(builder: (context, ref, child) {
                return Column(
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
                );
              }),
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
                    log(logo?.path.toString() ?? 'NA');
                  });
                },
                child: const Ctext(
                  text: "Add accessibility icon",
                )),
            logo == null
                ? Container(
                    margin: const EdgeInsets.all(20),
                    width: 200,
                    height: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        widget.model.logo ?? 'NA',
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
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
                ? SizedBox(
                    height: 210,
                    width: double.infinity,
                    child: sites.when(
                        data: (data) {
                          imagg = data['images'];
                          return ListView(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            children: [
                              for (int i = 0; i < imagg.length; i++)
                                Container(
                                    width: 120,
                                    margin: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 140,
                                          width: 120,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(20),
                                            child: Image.network(
                                              imagg[i],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () async {
                                              await SiteRepo().deleteImage(widget.model.id ?? 'NA', imagg[i]);
                                              ref.invalidate(siteIndividualDataProvider);
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: AppColor.red,
                                            ))
                                      ],
                                    )),
                            ],
                          );
                        },
                        error: (e, r) => Ctext(text: e.toString()),
                        loading: () => const Center(
                              child: CircularProgressIndicator(),
                            )),
                  )
                : SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children: [
                        for (int i = 0; i < (images?.length ?? 0); i++)
                          Container(
                              width: 120,
                              margin: const EdgeInsets.all(10),
                              height: 80,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.file(
                                  File(images?[i].path ?? ''),
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
                        List<File> photoList = images?.map((xFile) => File(xFile.path)).toList() ?? [];
                        await SiteRepo().updateSite(
                          model: PlaceModel(
                            name: title.text,
                            location: location.text,
                            lon: ref.watch(selectedlonProvider),
                            lat: ref.watch(selectedlatProvider),
                            info: info.text,
                            about: about.text,
                            category: widget.model.category,
                            rating: rating.text,
                            explorePeople: widget.model.explorePeople,
                            images: imagg,
                            photo: widget.model.photo,
                            logo: widget.model.logo,
                          ),
                        );

                        var photo = File(image?.path ?? 'Na');
                        var loo = File(logo?.path ?? 'Na');
                        if (image?.path.isNotEmpty == true) {
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
                        }
                        if (logo?.path.isNotEmpty == true) {
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
                          await IamgeStorage().storeIcon(photo: loo, name: title.text);
                        }
                        if (photoList.isNotEmpty == true) {
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
                          await IamgeStorage().addPhotos(photos: photoList, name: title.text);
                        }

                        ref.read(navIndexProvider.notifier).state = 0;
                        Navigator.pushReplacementNamed(NavigatorService.navigatorKey.currentContext ?? context, NavigationScreen.routeName);
                      },
                      child: const Ctext(
                        text: "Update",
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
