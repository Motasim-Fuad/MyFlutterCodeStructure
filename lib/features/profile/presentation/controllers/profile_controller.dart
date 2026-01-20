import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

// =========================================
// PROFILE LOADING STATE
// =========================================
enum ProfileLoadingState { initial, loading, success, error }

// =========================================
// PROFILE CONTROLLER
// =========================================
class ProfileController extends GetxController {
  final ProfileRepository repository;

  ProfileController({required this.repository});

  // ====== OBSERVABLES ======
  final loadingState = ProfileLoadingState.initial.obs;
  final Rxn<UserModel> profile = Rxn<UserModel>(); // Current profile
  final RxString errorMessage = ''.obs;
  final isUpdating = false.obs; // Update loading

  // ====== EDIT MODE ======
  final isEditMode = false.obs; // Edit mode on/off
  final Rxn<File> selectedImage = Rxn<File>(); // Selected image

  // ====== FORM CONTROLLERS ======
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  // Image picker instance
  final ImagePicker _picker = ImagePicker();

  // ====== ON INIT ======
  @override
  void onInit() {
    super.onInit();
    loadProfile(); // Profile load
  }

  // ====== LOAD PROFILE ======
  // 🔴 APNI EITA CONTROL KORBEN
  Future<void> loadProfile() async {
    loadingState.value = ProfileLoadingState.loading;

    final result = await repository.getProfile();

    result.fold(
      // Error
          (failure) {
        loadingState.value = ProfileLoadingState.error;
        errorMessage.value = failure.message;
      },
      // Success
          (user) {
        loadingState.value = ProfileLoadingState.success;
        profile.value = user;

        // Auth controller update (global user state)
        final authController = Get.find<AuthController>();
        authController.currentUser.value = user;

        // Form values set
        nameController.text = user.name;
        phoneController.text = user.phone;
      },
    );
  }

  // ====== TOGGLE EDIT MODE ======
  // Edit button e click korle on/off
  void toggleEditMode() {
    isEditMode.value = !isEditMode.value;

    // Cancel korle form reset
    if (!isEditMode.value) {
      nameController.text = profile.value?.name ?? '';
      phoneController.text = profile.value?.phone ?? '';
      selectedImage.value = null;
    }
  }

  // ====== PICK IMAGE ======
  // Gallery theke image select
  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80, // Image quality 80%
    );

    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  // ====== UPDATE PROFILE ======
  // 🔴 APNI EITA CONTROL KORBEN
  Future<void> updateProfile() async {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();

    // Validation
    if (name.isEmpty) {
      Get.snackbar('Error', 'Name cannot be empty');
      return;
    }

    if (phone.isEmpty) {
      Get.snackbar('Error', 'Phone cannot be empty');
      return;
    }

    // Update shuru
    isUpdating.value = true;

    // Repository call
    final result = await repository.updateProfile(
      name: name,
      phone: phone,
      profilePicture: selectedImage.value,
    );

    result.fold(
      // Error
          (failure) {
        isUpdating.value = false;
        Get.snackbar(
          'Error',
          failure.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      // Success
          (user) {
        isUpdating.value = false;
        profile.value = user;
        isEditMode.value = false; // Edit mode off
        selectedImage.value = null;

        // Auth controller update
        final authController = Get.find<AuthController>();
        authController.currentUser.value = user;

        Get.snackbar(
          'Success',
          'Profile updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  // ====== RETRY ======
  void retry() {
    loadProfile();
  }

  // ====== ON CLOSE ======
  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}