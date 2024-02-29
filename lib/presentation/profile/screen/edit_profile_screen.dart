import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heritage_map/core/const/app_color.dart';
import 'package:heritage_map/core/const/app_size.dart';
import 'package:heritage_map/core/utils/navigator_service.dart';
import 'package:heritage_map/data/%20local%20storage/local_save_data.dart';
import 'package:heritage_map/data/%20local%20storage/local_storge.dart';
import 'package:heritage_map/data/model/user_model.dart';
import 'package:heritage_map/data/service/user_image_service.dart';
import 'package:heritage_map/data/service/user_record_service.dart';
import 'package:heritage_map/presentation/bottom_nav/bottom_nav_screen.dart';
import 'package:heritage_map/provider/base_provider.dart';
import 'package:heritage_map/provider/user_provider.dart';
import 'package:heritage_map/widget/my_btn.dart';
import 'package:heritage_map/widget/text_field.dart';
import 'package:heritage_map/widget/text_widget.dart';
import 'package:image_picker/image_picker.dart';

final filePathProvider = StateProvider.autoDispose<XFile?>((ref) {
  return null;
});

class EditProfileScreen extends ConsumerWidget {
  static const String routeName = ' edit Profile screen';
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final image = ref.watch(filePathProvider);
    final loading = ref.watch(isLoadingProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Ctext(
          text: "Persona",
          size: 32,
          weight: FontWeight.w700,
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: LocalStorage().gettoken(value: LocalSaveData.email),
            builder: (context, snap) {
              final user = ref.watch(userIndividualDataProvider(snap.data.toString()));
              return user.when(
                  data: (data) {
                    final TextEditingController fname = TextEditingController(text: data['fname']);
                    final TextEditingController lname = TextEditingController(text: data['lname']);
                    final TextEditingController address = TextEditingController(text: data['address']);
                    final TextEditingController city = TextEditingController(text: data['city']);
                    return Column(
                      children: [
                        Stack(
                          children: [
                            image == null
                                ? data['image'].toString().contains('null')
                                    ? const CircleAvatar(
                                        radius: 70,
                                        backgroundColor: Colors.grey,
                                        backgroundImage: AssetImage('assets/images/user1.png'),
                                      )
                                    : CircleAvatar(
                                        radius: 70,
                                        backgroundColor: Colors.grey,
                                        backgroundImage: NetworkImage(data['image']),
                                      )
                                : SizedBox(
                                    height: 120,
                                    width: 120,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(200),
                                      child: Image.file(
                                        File(image.path),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              child: GestureDetector(
                                onTap: () async {
                                  final ImagePicker picker = ImagePicker();
                                  final img = await picker.pickImage(source: ImageSource.gallery);
                                  ref.read(filePathProvider.notifier).state = img;
                                },
                                child: const CircleAvatar(
                                  backgroundColor: AppColor.white,
                                  child: Center(
                                    child: Icon(Icons.edit_note_sharp),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        AppSize.height50,
                        customTextField(label: "First Name", controller: fname),
                        AppSize.height28,
                        customTextField(label: "Last Name", controller: lname),
                        AppSize.height28,
                        customTextField(label: "Address", controller: address),
                        AppSize.height28,
                        customTextField(label: "city", controller: city),
                        AppSize.height50,
                        loading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : myBtn(
                                "Update Persona",
                                tap: () async {
                                  ref.read(isLoadingProvider.notifier).state = true;
                                  var path = File(image?.path ?? 'null');
                                  var model = UserModel(
                                    fname: fname.text,
                                    lname: lname.text,
                                    city: city.text,
                                    address: address.text,
                                    email: data['email'],
                                    needInfo: data['needInfo'],
                                    explore: data['explore'],
                                    image: data['image'],
                                  );
                                  await UserRecordService().updateuserinfo(
                                    model: model,
                                    email: snap.data.toString(),
                                  );
                                  if ((image?.path ?? '').isNotEmpty) {
                                    await ImageStorageService().profilesetup(photo: path, name: fname.text, email: snap.data.toString());
                                  }
                                  ref.invalidate(userIndividualDataProvider(snap.data.toString()));
                                  ref.read(navIndexProvider.notifier).state = 0;
                                  NavigatorService.pushNamedAndRemoveUntil(NavigationScreen.routeName);
                                  ref.read(isLoadingProvider.notifier).state = false;
                                },
                              )
                      ],
                    );
                  },
                  error: (e, r) => Ctext(text: e.toString()),
                  loading: () => const SizedBox.shrink());
            }),
      ),
    );
  }
}
