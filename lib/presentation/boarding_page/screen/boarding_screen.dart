import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heritage_map/core/const/app_image.dart';
import 'package:heritage_map/presentation/boarding_page/widget/boarding_page.dart';
import 'package:heritage_map/provider/boarding_provider.dart';

class BoardingScreen extends ConsumerWidget {
  static const String routeName = "BoardingScreen";
  BoardingScreen({super.key});
  final List<String> titles = ["Lets explore the City", "Visit tourist attractions", "Get ready for next trip"];
  final List<String> subtitles = [
    "let’s explore the city of Temple with us with just a few clicks",
    "Find thousands of tourist destinations ready for you to visit ",
    "Find thousands of tourist destinations ready for you to visit "
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(boardingPageControllerProvider);
    return Scaffold(
        body: PageView.builder(
            itemCount: APPImage.boardingPageImage.length,
            controller: controller,
            itemBuilder: (context, index) {
              return boardingContianer(context, index, titles[index], subtitles[index], APPImage.boardingPageImage[index], ref);
            }));
  }
}
