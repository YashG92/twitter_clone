import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/feature/personalization/controller/user_controller.dart';
import 'package:twitter_clone/feature/personalization/view/user_profile/widget/user_profile_avatar.dart';
import 'package:twitter_clone/utils/constants/constants.dart';
import 'package:twitter_clone/utils/helpers/validators.dart';

import '../../controller/edit_user_controller.dart';

class EditUserProfileView extends StatelessWidget {
  const EditUserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditUserController());
    final userController = UserController.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          Obx(
            () =>
                controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : TextButton(
                      onPressed: () => controller.updateProfile(),
                      child: Text(
                        'Save',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                GestureDetector(
                  onTap: () => controller.pickImage(isCover: true),
                  child: Obx(() {
                    if (controller.coverImageFile.value != null) {
                      return Image.file(
                        controller.coverImageFile.value!,
                        fit: BoxFit.cover,
                        height: 150,
                        width: double.infinity,
                      );
                    } else if (controller.coverImageUrl != null &&
                        controller.coverImageUrl!.isNotEmpty) {
                      return Image.network(
                        controller.coverImageUrl!,
                        fit: BoxFit.cover,
                        height: 150,
                        width: double.infinity,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                _buildPlaceholderCoverImage(),
                      );
                    } else {
                      return _buildPlaceholderCoverImage();
                    }
                  }),
                ),
                Positioned(
                  left: 10,
                  bottom: -40,
                  child: GestureDetector(
                    onTap: () => controller.pickImage(isCover: false),
                    child: Obx(() {
                      if (controller.profileImageFile.value != null) {
                        return CircleAvatar(
                          radius: 42,
                          backgroundImage: FileImage(
                            controller.profileImageFile.value!,
                          ),
                        );
                      } else {
                        return UserProfileAvatar(
                          backgroundRadius: 42,
                          foregroundRadius: 40,
                          imageUrl: userController.user.value.profileImage,
                        );
                      }
                    }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(YSizes.defaultSpace / 2),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Form(
                      key: controller.key,
                      child: Column(
                        children: [
                          _buildTextField(
                            label: 'Name',
                            controller: controller.name,
                          ),
                          _buildTextField(
                            label: 'Bio',
                            controller: controller.bio,
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderCoverImage() {
    return Container(
      height: 150,
      color: Colors.blue.shade800,
      child: const Center(
        child: Icon(Icons.camera_alt_outlined, color: Colors.white54, size: 48),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: YSizes.spaceBtwInputFields),
      child: TextFormField(
        validator: (value) => Validator.validateEmptyText(label, value),
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const UnderlineInputBorder(),
        ),
      ),
    );
  }
}
