import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neighborly_flutter_app/core/theme/text_style.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import 'package:neighborly_flutter_app/core/widgets/text_field_widget.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/get_profile_bloc/get_profile_bloc.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/widgets/gender_dropdown_widget.dart';
import 'package:neighborly_flutter_app/features/upload/presentation/bloc/upload_post_bloc/upload_post_bloc.dart';
import 'package:neighborly_flutter_app/features/upload/presentation/widgets/post_button_widget.dart';

class BasicInformationScreen extends StatefulWidget {
  const BasicInformationScreen({super.key});

  @override
  State<BasicInformationScreen> createState() => _BasicInformationScreenState();
}

class _BasicInformationScreenState extends State<BasicInformationScreen> {
  bool isActive = false;
  late bool isUsernamePasswordFilled = false;
  late bool isEmailFilled = false;
  late bool isPhoneNumberFilled = false;
  bool noConnection = false;

  late TextEditingController _usernamePasswordController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _bioController;

  File? _selectedImage; // Store the selected image

  @override
  void initState() {
    _usernamePasswordController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _bioController = TextEditingController();
    _fetchProfile();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _usernamePasswordController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
  }

  void _fetchProfile() {
    var state = context.read<GetProfileBloc>().state;
    if (state is! GetProfileSuccessState) {
      BlocProvider.of<GetProfileBloc>(context)
          .add(GetProfileButtonPressedEvent());
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 14.0, left: 14.0, right: 14.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              child: const Icon(Icons.arrow_back_ios, size: 20),
                              onTap: () => context.pop(),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Basic Information',
                              style: blackNormalTextStyle,
                            ),
                          ],
                        ),
                        BlocConsumer<UploadPostBloc, UploadPostState>(
                          listener: (context, state) {
                            if (state is UploadPostFailureState) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.error)),
                              );
                            } else if (state is UploadPostSuccessState) {
                              // _contentController.clear();
                              // _titleController.clear();
                              // _removeImage();
                              // context.go('/homescreen');
                            }
                          },
                          builder: (context, state) {
                            if (state is UploadPostLoadingState) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            return PostButtonWidget(
                              title: 'Save',
                              onTapListener: () async {
                                List<double> location =
                                    ShardPrefHelper.getLocation();

                                List<Placemark> placemarks =
                                    await placemarkFromCoordinates(
                                  location[0],
                                  location[1],
                                );

                                // BlocProvider.of<UploadPostBloc>(context).add(
                                //   UploadPostPressedEvent(
                                //     city: placemarks[0].locality ?? '',
                                //     content: _contentController.text.trim(),
                                //     title: _titleController.text.trim(),
                                //     type: 'post',
                                //     multimedia: _selectedImage,
                                //     allowMultipleVotes: false,
                                //   ),
                                // );
                              },
                              isActive: true,
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  BlocBuilder<GetProfileBloc, GetProfileState>(
                    builder: (context, state) {
                      if (state is GetProfileSuccessState) {
                        _bioController.text = state.profile.bio ?? '';
                        _emailController.text = state.profile.email;

                        // _phoneNumberController.text = state.profile.phoneNumber;
                        _usernamePasswordController.text =
                            state.profile.username;
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: ClipOval(
                                  child: Container(
                                    width: 90,
                                    height: 90,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: _selectedImage == null
                                        ? Image.network(
                                            state.profile.picture,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.file(
                                            _selectedImage!,
                                            width: double.infinity,
                                            height: 260,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Center(
                                child: InkWell(
                                  onTap: _pickImage,
                                  child: Text(
                                    'Edit photo',
                                    style: noUnderlineblueNormalTextStyle,
                                  ),
                                ),
                              ),
                              // const SizedBox(height: 20),
                              Text(
                                'Username',
                                style: greyonboardingBody1Style,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFieldWidget(
                                border: true,
                                onChanged: (value) {
                                  setState(() {
                                    isUsernamePasswordFilled =
                                        _usernamePasswordController.text
                                            .trim()
                                            .isNotEmpty;
                                  });
                                },
                                controller: _usernamePasswordController,
                                lableText: '',
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Email Id',
                                style: greyonboardingBody1Style,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFieldWidget(
                                border: true,
                                onChanged: (value) {
                                  setState(() {
                                    isEmailFilled =
                                        _emailController.text.trim().isNotEmpty;
                                  });
                                },
                                controller: _emailController,
                                lableText: '',
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Phone number',
                                style: greyonboardingBody1Style,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFieldWidget(
                                border: true,
                                onChanged: (value) {
                                  setState(() {
                                    isPhoneNumberFilled = _phoneNumberController
                                        .text
                                        .trim()
                                        .isNotEmpty;
                                  });
                                },
                                controller: _phoneNumberController,
                                lableText: '',
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Gender',
                                style: greyonboardingBody1Style,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              GenderDropdown(
                                selectedGender: _selectedGender,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedGender = newValue;
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Bio',
                                style: greyonboardingBody1Style,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 150,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextField(
                                  onChanged: (value) {},
                                  controller: _bioController,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  minLines: 1,
                                ),
                              ),
                              const SizedBox(
                                height: 45,
                              ),
                            ],
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ],
              ),
            )));
  }
}
