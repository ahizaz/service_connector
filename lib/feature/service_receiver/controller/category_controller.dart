import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:service_connect/feature/service_receiver/models/category_model.dart';
import 'package:service_connect/feature/service_receiver/repository/category_repository.dart';

class CategoryController extends GetxController {
  final CategoryRepository _repository = CategoryRepository();

  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Don't auto-fetch here; let HomeController coordinate the loading
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      EasyLoading.show(status: 'Loading categories...');

      debugPrint('=================================');
      debugPrint('Starting to fetch categories...');
      debugPrint('=================================');

      final result = await _repository.getAllCategories();
      categories.value = result;

      debugPrint('=================================');
      debugPrint('Categories loaded in controller: ${categories.length}');
      debugPrint('=================================');

      EasyLoading.dismiss();
      isLoading.value = false;
    } catch (e) {
      debugPrint('=================================');
      debugPrint('Error in category controller: $e');
      debugPrint('=================================');

      EasyLoading.dismiss();
      EasyLoading.showError('Failed to load categories');
      isLoading.value = false;
    }
  }

  Future<void> refreshCategories() async {
    await fetchCategories();
  }
}
