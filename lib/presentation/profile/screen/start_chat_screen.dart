import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heritage_map/core/const/app_color.dart';
import 'package:heritage_map/data/%20local%20storage/local_save_data.dart';
import 'package:heritage_map/data/%20local%20storage/local_storge.dart';
import 'package:heritage_map/provider/user_provider.dart';
import 'package:heritage_map/widget/text_field.dart';
import 'package:heritage_map/widget/text_widget.dart';

class StartChatScreen extends ConsumerWidget {
  static const String routeName = 'StartChatScreen';
  StartChatScreen({super.key});

  final TextEditingController message = TextEditingController();

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
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: LocalStorage().gettoken(value: LocalSaveData.email),
            builder: (context, snap) {
              final msgdoc = ref.watch(messageDocumentsProvider(snap.data.toString()));
              return Column(
                children: [
                  msgdoc.when(
                      data: (data1) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: ListView.builder(
                              itemCount: data1.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                var align = data1[index]['senderID'] == snap.data.toString() ? Alignment.centerRight : Alignment.centerLeft;
                                return Container(
                                  alignment: align,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Ctext(
                                        text: data1[index]['senderID'],
                                        color: AppColor.black,
                                      ),
                                      Ctext(
                                        text: data1[index]['message'],
                                        color: AppColor.black,
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        );
                      },
                      error: (e, r) => Ctext(text: e.toString()),
                      loading: () => const SizedBox.shrink()),

                  //input
                  Row(
                    children: [
                      Expanded(child: customTextField(label: "message", controller: message)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 30,
                          child: IconButton(
                            onPressed: () {
                              if (message.text.isNotEmpty) {
                                // UserRecordService().sendMessage(reciverId: snap.data.toString(), message: message.text, snap: snap.data.toString());
                                message.clear();
                                ref.invalidate(messageDocumentsProvider);
                              }
                            },
                            icon: const Icon(
                              Icons.arrow_forward_sharp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
      ),
    );
  }
}


