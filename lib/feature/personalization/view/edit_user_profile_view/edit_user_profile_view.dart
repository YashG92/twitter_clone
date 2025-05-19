import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/feature/personalization/view/user_profile/widget/user_profile_avatar.dart';
import 'package:twitter_clone/utils/constants/constants.dart';

import '../../controller/edit_user_controller.dart';

class EditUserProfileView extends StatelessWidget {
  const EditUserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditUserController());
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          Obx(
            () =>
                controller.isLoading.value
                    ? CircularProgressIndicator()
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
                    } else if (controller.coverImageUrl != null) {
                      return Image.network(
                        controller.coverImageUrl!,
                        fit: BoxFit.cover,
                        height: 150,
                        width: double.infinity,
                      );
                    } else {
                      return Container(
                        height: 150,
                        color: Colors.blue.shade800,
                        child: Center(
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white54,
                            size: 48,
                          ),
                        ),
                      );
                    }
                  }),
                ),
                Positioned(
                  left: 10,
                  bottom: -40,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      GestureDetector(
                        onTap: () => controller.pickImage(isCover: false),
                        child: Obx(
                          () =>
                              controller.profileImageFile.value != null
                                  ? CircleAvatar(
                                    radius: 42,
                                    backgroundImage: FileImage(
                                      controller.profileImageFile.value!,
                                    ),
                                  )
                                  : UserProfileAvatar(
                                    backgroundRadius: 42,
                                    foregroundRadius: 40,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            Padding(
              padding: EdgeInsets.all(YSizes.defaultSpace / 2),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Form(
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
                          //_buildTextField(label: 'Location', controller: controller.location),
                          //_buildTextField(label: 'Website', controller: controller.website),
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: YSizes.spaceBtwInputFields),
      child: TextField(
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
