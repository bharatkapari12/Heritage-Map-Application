import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heritage_map/core/const/app_color.dart';
import 'package:heritage_map/core/const/app_size.dart';
import 'package:heritage_map/data/%20local%20storage/local_save_data.dart';
import 'package:heritage_map/data/%20local%20storage/local_storge.dart';

import 'package:heritage_map/provider/user_provider.dart';
import 'package:heritage_map/widget/text_widget.dart';

class UserDetailsContainer extends ConsumerWidget {
  const UserDetailsContainer({super.key,  this.text});
 
  final String? text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return FutureBuilder(
              future: LocalStorage().gettoken(value: LocalSaveData.email),

      builder: (context, snap) {
    final user = ref.watch(userIndividualDataProvider(snap.data.toString()));

        return user.when(
            data: (data) {
              return Container(
                padding: const EdgeInsets.all(12),
                height: 120,
                child: Row(children: [
                  data['image'].toString().contains("null")
                      ? const CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage('assets/images/user1.png'),
                        )
                      : CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(data['image']),
                        ),
                  AppSize.width15,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Ctext(
                        text: "Hey ${data['fname']}! 👋🏻",
                        size: 24,
                        weight: FontWeight.w600,
                      ),
                      Ctext(
                        text: text ?? "${data['address']},${data['city']}",
                        size: 16,
                        weight: FontWeight.w400,
                        color: AppColor.grey,
                      ),
                    ],
                  ),
                ]),
              );
            },
            error: (e, r) => Ctext(text: e.toString()),
            loading: () => const SizedBox.shrink());
      }
    );
  }
}
