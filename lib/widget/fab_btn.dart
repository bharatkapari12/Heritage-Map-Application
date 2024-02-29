import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heritage_map/core/const/app_color.dart';
import 'package:heritage_map/data/%20local%20storage/local_save_data.dart';
import 'package:heritage_map/data/%20local%20storage/local_storge.dart';
import 'package:heritage_map/provider/user_provider.dart';

class FavBtn extends ConsumerWidget {
  const FavBtn({
    super.key,
    required this.value,
  });
  final String value;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
        future: LocalStorage().gettoken(value: LocalSaveData.email),
        builder: (context, snap) {
          return Consumer(builder: (context, ref, child) {
            final user = ref.watch(userIndividualDataProvider(snap.data.toString()));

            List<dynamic> explorelist = user.asData?.value['explore'] ?? [];
            bool myFav = explorelist.contains(value);
            return Padding(
                padding: const EdgeInsets.all(18.0),
                child: CircleAvatar(
                  backgroundColor: myFav ? AppColor.white : AppColor.grey,
                  child: IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: myFav ? AppColor.red : AppColor.white,
                    ),
                    onPressed: () {
                      log(myFav.toString());
                      var docRef = FirebaseFirestore.instance.collection('user').doc(snap.data.toString());
                      if (explorelist.contains(value)) {
                        docRef.update({
                          'email': snap.data.toString(),
                          'explore': FieldValue.arrayRemove([value]),
                        }).then((_) {
                          log('Removed successfully.');
                        }).catchError((error) {
                          log('Error removing review: $error');
                        });
                      } else {
                        docRef.update({
                          'email': snap.data.toString(),
                          'explore': FieldValue.arrayUnion([value]),
                        }).then((_) {
                          log('Added successfully.');
                        }).catchError((error) {
                          log('Error adding review: $error');
                        });
                      }
                      ref.invalidate(userIndividualDataProvider(snap.data.toString()));
                    },
                  ),
                ));
          });
        });
  }
}
