import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shop_passport/config/routes/app_routes.dart';
import '../controllers/profile_controller.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/custom_button.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => Get.toNamed(AppRoutes.settings),
        ),
        actions: [
          // Edit/Cancel button (state onujayi)
          Obx(() => controller.loadingState.value == ProfileLoadingState.success
              ? IconButton(
            icon: Icon(controller.isEditMode.value ? Icons.close : Icons.edit),
            onPressed: controller.toggleEditMode,
          )
              : const SizedBox()),
        ],
      ),

      // Body - State onujayi different UI
      body: Obx(() {
        switch (controller.loadingState.value) {
          case ProfileLoadingState.loading:
            return const LoadingWidget(message: 'Loading profile...');

          case ProfileLoadingState.error:
            return CustomErrorWidget(
              message: controller.errorMessage.value,
              onRetry: controller.retry,
            );

          case ProfileLoadingState.success:
            return _buildProfileContent(context);

          default:
            return const SizedBox.shrink();
        }
      }),
    );
  }

  //BUILD PROFILE CONTENT
  Widget _buildProfileContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Profile picture
          Obx(() => _buildProfilePicture()),
          const SizedBox(height: 24),

          // Edit mode e form, na hole info
          Obx(() => controller.isEditMode.value
              ? _buildEditForm(context)
              : _buildProfileInfo(context)),

          const SizedBox(height: 24),

          // Logout button (edit mode e na)
          Obx(() => !controller.isEditMode.value
              ? _buildLogoutButton(context)
              : const SizedBox()),
        ],
      ),
    );
  }

  // BUILD PROFILE PICTURE
  Widget _buildProfilePicture() {
    return Stack(
      children: [
        // Profile image container
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.blue, width: 3),
          ),
          child: ClipOval(
            child: controller.selectedImage.value != null
            // Selected image
                ? Image.file(
              controller.selectedImage.value!,
              fit: BoxFit.cover,
            )
            // Profile picture (Throw API)
                : controller.profile.value?.profilePicture != null
                ? CachedNetworkImage(
              imageUrl: controller.profile.value!.profilePicture!,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) =>
              const Icon(Icons.person, size: 60),
            )
            // Default icon
                : const Icon(Icons.person, size: 60),
          ),
        ),

        // Camera button (edit mode e)
        if (controller.isEditMode.value)
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: controller.pickImage,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
      ],
    );
  }

  // BUILD PROFILE INFO
  Widget _buildProfileInfo(BuildContext context) {
    final profile = controller.profile.value!;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow(Icons.person, 'Name', profile.name),
            const Divider(height: 24),
            _buildInfoRow(Icons.email, 'Email', profile.email),
            const Divider(height: 24),
            _buildInfoRow(Icons.phone, 'Phone', profile.phone),
            if (profile.bio != null) ...[
              const Divider(height: 24),
              _buildInfoRow(Icons.info, 'Bio', profile.bio!),
            ],
          ],
        ),
      ),
    );
  }

  // BUILD INFO ROW
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // BUILD EDIT FORM
  Widget _buildEditForm(BuildContext context) {
    return Column(
      children: [
        // Name field
        TextField(
          controller: controller.nameController,
          decoration: InputDecoration(
            labelText: 'Name',
            prefixIcon: const Icon(Icons.person),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Phone field
        TextField(
          controller: controller.phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Phone',
            prefixIcon: const Icon(Icons.phone),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Update button
        Obx(() => CustomButton(
          title: 'Update Profile',
          onPress: controller.updateProfile,
          loading: controller.isUpdating.value,
          loadingText: 'Updating...',
          showLoader: true,
          showLoadingText: true,
          height: 50,
          width: double.infinity,
          buttonColor: Colors.blue,
        )),
      ],
    );
  }

  // BUILD LOGOUT BUTTON
  Widget _buildLogoutButton(BuildContext context) {
    final authController = Get.find<AuthController>();
    return CustomButton(
      title: 'Logout',
      onPress: authController.logout,
      height: 50,
      width: double.infinity,
      buttonColor: Colors.red,
      icon: Icons.logout,
      iconPosition: IconPosition.left,
    );
  }
}