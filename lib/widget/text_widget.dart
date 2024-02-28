import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heritage_map/core/const/app_color.dart';

class Ctext extends ConsumerWidget {
  const Ctext({super.key, required this.text, this.color, this.weight, this.size, this.line, this.align});
  final String text;
  final Color? color;
  final FontWeight? weight;
  final double? size;
  final int? line;
  final TextAlign? align;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(
      text,
      maxLines: line,
      overflow: TextOverflow.ellipsis,
      textAlign:align?? TextAlign.center,
      style: TextStyle(color: color ?? AppColor.black, fontWeight: weight ?? FontWeight.w500, fontSize: size ?? 18),
    );
  }
}

class Ntext extends ConsumerWidget {
  const Ntext({
    super.key,
    required this.text,
    this.color,
    this.weight,
    this.size,
  });
  final String text;
  final Color? color;
  final FontWeight? weight;
  final double? size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(
      text,
      textAlign: TextAlign.justify,
      style: TextStyle(color: color ?? AppColor.black, fontWeight: weight ?? FontWeight.w500, fontSize: size ?? 18),
    );
  }
}
