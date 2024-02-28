import 'package:flutter_riverpod/flutter_riverpod.dart';

final obscureTextProvider = StateProvider.autoDispose<bool>((ref) {
  return true;
});

final checkBoxProvider = StateProvider<bool>((ref) {
  return false;
});
final switchBoxProvider = StateProvider<bool>((ref) {
  return false;
});
final showAllProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});

final isLoadingProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});
final readMoreProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});
final selectedCatIndexProvider = StateProvider<int>((ref) {
  return 0;
});
final choosedCategoryValueProvider = StateProvider<String>((ref) {
  return 'Ancient Sites';
});
final searchControllerProvider = StateProvider.autoDispose<String>((ref) {
  return '';
});