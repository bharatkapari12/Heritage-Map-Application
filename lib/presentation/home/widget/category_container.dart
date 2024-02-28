import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heritage_map/core/const/app_color.dart';
import 'package:heritage_map/core/const/app_size.dart';
import 'package:heritage_map/provider/base_provider.dart';
import 'package:heritage_map/widget/text_widget.dart';

List<String> categoryList = [
  'Ancient Sites',
  'Medieval Temples',
  'Modern Cultural Sites',
  'Museums',
  'Newar Architecuture',
  'Pilgrimage Sites',
];

class CategotyContainer extends ConsumerWidget {
  const CategotyContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedCatIndexProvider);

    return Container(
      margin: const EdgeInsets.all(12),
      height: 110,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Ctext(text: 'Choose Category'),
          AppSize.height28,
          SizedBox(
            height: 50,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoryList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      ref.read(selectedCatIndexProvider.notifier).state = index;
                      ref.read(choosedCategoryValueProvider.notifier).state = categoryList[index];
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      margin: const EdgeInsets.only(left: 12),
                      height: 35,
                      decoration: BoxDecoration(
                        color: selected == index ? AppColor.primaryColor : AppColor.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: AppColor.black,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Ctext(
                        text: categoryList[index],
                        size: 14,
                        weight: FontWeight.w400,
                        color: selected == index ? AppColor.black : AppColor.grey,
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
