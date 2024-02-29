import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heritage_map/core/const/app_color.dart';
import 'package:heritage_map/core/const/app_size.dart';
import 'package:heritage_map/data/%20local%20storage/local_save_data.dart';
import 'package:heritage_map/data/%20local%20storage/local_storge.dart';
import 'package:heritage_map/presentation/profile/screen/char_screen.dart';
import 'package:heritage_map/provider/user_provider.dart';
import 'package:heritage_map/widget/text_widget.dart';

class FourmScreen extends ConsumerWidget {
  static const String routeName = 'forurm screen';
  const FourmScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        centerTitle: true,
        title: const Ctext(
          text: "Forum",
          size: 32,
          weight: FontWeight.w700,
        ),
      ),
      body: FutureBuilder(
          future: LocalStorage().gettoken(value: LocalSaveData.email),
          builder: (context, snap) {
            // final msgdoc = ref.watch(messageDocumentsProvider(snap.data.toString()));
            final allmessage = ref.watch(allmessageProvider);

            return allmessage.when(
                data: (data) {
                  log("message =>${data.docs.length}");
                  if (data.docs.isEmpty) {
                    return SizedBox(child: firstChat(tap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminChat(
                                    sendId: snap.data.toString(),
                                    isAdmin: false,
                                  )));
                    }));
                  }
                  return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: data.docs.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          // if (data[index]['senderID'] == snap.data.toString())
                          {
                            return GestureDetector(
                              onTap: () {
                                // NavigatorService.pushNamed(StartChatScreen.routeName);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AdminChat(
                                              sendId: data.docs[index].id,
                                              isAdmin: true,
                                            )));
                              },
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Ctext(
                                    text: 'User ${index + 1} : ${data.docs[index].id}',
                                    color: AppColor.black,
                                  ),
                                ),
                              ),
                            );
                          }
                          //  else {
                          //   return firstChat();
                          // }
                        }),
                  );
                },
                error: (e, r) => Ctext(text: e.toString()),
                loading: () => const SizedBox.shrink());
          }),
    );
  }
}

Column firstChat({void Function()? tap}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Ctext(
        text: "No Forums yet.",
        size: 20,
      ),
      AppSize.height28,
      const SizedBox(
        width: 200,
        child: Ctext(
          line: 2,
          text: "Chat with Heritage Site for supports. ",
          size: 16,
          weight: FontWeight.w400,
          color: AppColor.grey,
        ),
      ),
      AppSize.height28,
      MaterialButton(
        minWidth: 100,
        height: 50,
        color: AppColor.white.withOpacity(0.8),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(
              color: AppColor.grey,
            )),
        onPressed: tap,
        child: const Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(
            Icons.chat_outlined,
            size: 15,
          ),
          AppSize.width8,
          Ctext(
            text: "New Forum",
            size: 12,
          )
        ]),
      )
    ],
  );
}

class NoChatFound extends ConsumerWidget {
  const NoChatFound({super.key, required this.tap});
  final void Function()? tap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        centerTitle: true,
        title: const Ctext(
          text: "Forum",
          size: 32,
          weight: FontWeight.w700,
        ),
      ),
      body: SizedBox(height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width, child: firstChat(tap: tap)),
    );
  }
}
