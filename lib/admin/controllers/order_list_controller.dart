import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderListController extends GetxController {
  final TextEditingController searchCtrl = TextEditingController();
  final RxString searchQuery = ''.obs;

  void clearSearch() {
    searchCtrl.clear();
    searchQuery.value = '';
  }

  @override
  void onClose() {
    searchCtrl.dispose();
    super.onClose();
  }
}