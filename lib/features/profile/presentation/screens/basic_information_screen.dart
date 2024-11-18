import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/core/utils/helpers.dart';
import 'package:neighborly_flutter_app/core/widgets/bouncing_logo_indicator.dart';
import 'package:neighborly_flutter_app/dependency_injection.dart';
import 'package:neighborly_flutter_app/features/profile/data/repositories/city_repositories.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/change_home_city_bloc/change_home_city_event.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/change_home_city_bloc/change_home_city_state.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/get_my_comments_bloc/get_my_comments_bloc.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/get_my_posts_bloc/get_my_posts_bloc.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/widgets/city_dropdown.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/utils/shared_preference.dart';
import '../../../../core/widgets/text_field_widget.dart';
import '../../../upload/presentation/widgets/post_button_widget.dart';
import '../bloc/change_home_city_bloc/change_home_city_bloc.dart';
import '../bloc/edit_profile_bloc/edit_profile_bloc.dart';
import '../bloc/get_profile_bloc/get_profile_bloc.dart';
import '../widgets/gender_dropdown_widget.dart';
import '../../../authentication/presentation/screens/otp_screen_profile_update.dart';
import '../../../authentication/presentation/bloc/resend_otp_bloc/resend_otp_bloc.dart';
import 'package:image_cropper/image_cropper.dart';

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '2x3 (customized)';
}

class BasicInformationScreen extends StatefulWidget {
  const BasicInformationScreen({super.key});

  @override
  State<BasicInformationScreen> createState() => _BasicInformationScreenState();
}

class _BasicInformationScreenState extends State<BasicInformationScreen> {
  bool isActive = false;
  bool isEmpty = false;
  bool isEmailFilled = false;
  bool noConnection = false;
  bool isUserNameShort = false;
  bool invalidPhone = false;

  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _bioController;
  // late TextEditingController _locationController;
  late String _selectedGender;
  late String _selectedCity;
  bool isPhoneVerified = true;
  bool isOTPSent = false;
  late String authType;
  File? _selectedImage;

  @override
  void initState() {
    // _locationController = TextEditingController();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _bioController = TextEditingController();
    _selectedGender = ShardPrefHelper.getGender() ?? 'Male';
    _selectedCity = ShardPrefHelper.getHomeCity() ?? 'Delhi';
    authType = ShardPrefHelper.getAuthtype() ?? 'email';

    _fetchProfile();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _bioController.dispose();
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

    // Pick the image from the gallery
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // Crop the image
      File? croppedFile = await _cropImage(image.path);

      if (croppedFile != null) {
        setState(() {
          _selectedImage = croppedFile;
        });
      }
    }
  }

// Function to crop the image
  Future<File?> _cropImage(String imagePath) async {
    CroppedFile? croppedFile =
        await ImageCropper().cropImage(sourcePath: imagePath, uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Cropper',
        toolbarColor: AppColors.deepOrangeColor,
        toolbarWidgetColor: AppColors.whiteColor,
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPresetCustom(),
        ],
      ),
    ]);

    if (croppedFile != null) {
      return File(croppedFile.path);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 14.0,
                  left: 14.0,
                  right: 14.0,
                ),
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
                    BlocConsumer<EditProfileBloc, EditProfileState>(
                      listener: (context, state) {
                        if (state is EditProfileFailureState) {
                          if (state.error.contains('cannot be empty')) {
                            setState(() {
                              isEmpty = true;
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.error)),
                            );
                          }
                        } else if (state is EditProfileSuccessState) {
                          _usernameController.clear();
                          _bioController.clear();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Profile updated successfully'),
                            ),
                          );
                          //context.go(location)
                          print('here 1');
                          context.go('/profile');
                          BlocProvider.of<GetProfileBloc>(context)
                              .add(GetProfileButtonPressedEvent());
                          BlocProvider.of<GetMyPostsBloc>(context)
                              .add(GetMyPostsButtonPressedEvent());
                          BlocProvider.of<GetMyCommentsBloc>(context)
                              .add(GetMyCommentsButtonPressedEvent());
                        }
                      },
                      builder: (context, state) {
                        if (state is EditProfileLoadingState) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return BlocConsumer<ResendOtpBloc, ResendOTPState>(
                            listener: (
                          BuildContext context,
                          ResendOTPState resentstate,
                        ) {
                          if (resentstate is ResendOTPFailureState) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(resentstate.error),
                              ),
                            );
                          } else if (resentstate is ResendOTPSuccessState) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(resentstate.message),
                              ),
                            );

                            //  Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => OtpScreenProfileUpdate(
                            //       data: _phoneNumberController.text.trim(),
                            //       verificationFor: 'phone-register',
                            //       onVerifiedSuccessfully: () {
                            //         // This function is executed after verification
                            //         BlocProvider.of<EditProfileBloc>(context).add(
                            //           EditProfileButtonPressedEvent(
                            //             bio: _bioController.text.trim(),
                            //             phoneNumber: _phoneNumberController.text.trim(),
                            //             username: _usernameController.text.trim(),
                            //             image: _selectedImage,
                            //             gender: _selectedGender,
                            //           ),
                            //         );
                            //       },
                            //     ),
                            //   ),
                            // );
                          }
                        }, builder: (context, resentstate) {
                          return PostButtonWidget(
                            title: 'Save',
                            onTapListener: () async {
                              var userName = _usernameController.text.trim();
                              var phoneNumber =
                                  _phoneNumberController.text.trim();
                              var bio = _bioController.text.trim();
                              var email = _emailController.text.trim();
                              if (userName.length < 6) {
                                setState(() {
                                  isUserNameShort = true;
                                });
                                return;
                              }
                              if (phoneNumber.isNotEmpty &&
                                  !isValidPhoneNumber(phoneNumber)) {
                                setState(() {
                                  invalidPhone = true;
                                });
                                return;
                              }
                              // if(){}
                              _phoneNumberController.text.trim().isNotEmpty
                                  ? ShardPrefHelper.setPhoneNumber(
                                      _phoneNumberController.text.trim(),
                                    )
                                  : ShardPrefHelper.setPhoneNumber('');
                              ShardPrefHelper.setGender(_selectedGender);
                              ShardPrefHelper.setUsername(userName);
                              if (isPhoneVerified) {
                                BlocProvider.of<EditProfileBloc>(context).add(
                                  EditProfileButtonPressedEvent(
                                    bio: _bioController.text.trim(),
                                    phoneNumber:
                                        _phoneNumberController.text.trim(),
                                    username: _usernameController.text.trim(),
                                    image: _selectedImage,
                                    gender: _selectedGender,
                                  ),
                                );
                              } else {
                                if (_phoneNumberController.text
                                    .trim()
                                    .isNotEmpty) {
                                  //  BlocProvider.of<ResendOtpBloc>(context).add(
                                  //   ResendOTPButtonPressedEvent(
                                  //     phone: _phoneNumberController.text.trim(),
                                  //   ),
                                  // );
                                  //if (resentstate is ResendOTPSuccessState && isOTPSent) {
                                  setState(() {
                                    isOTPSent = true;
                                  });
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //   SnackBar(content: Text("OTP sent successfully")),
                                  // );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          OtpScreenProfileUpdate(
                                        data:
                                            _phoneNumberController.text.trim(),
                                        verificationFor: 'phone-register',
                                        onVerifiedSuccessfully: () {
                                          BlocProvider.of<EditProfileBloc>(
                                                  context)
                                              .add(
                                            EditProfileButtonPressedEvent(
                                              bio: _bioController.text.trim(),
                                              phoneNumber:
                                                  _phoneNumberController.text
                                                      .trim(),
                                              username: _usernameController.text
                                                  .trim(),
                                              image: _selectedImage,
                                              gender: _selectedGender,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                } else {
                                  BlocProvider.of<EditProfileBloc>(context).add(
                                    EditProfileButtonPressedEvent(
                                      bio: _bioController.text.trim(),
                                      phoneNumber:
                                          _phoneNumberController.text.trim(),
                                      username: _usernameController.text.trim(),
                                      image: _selectedImage,
                                      gender: _selectedGender,
                                    ),
                                  );
                                }
                              }
                            },
                            isActive: true,
                          );
                        });
                      },
                    )
                  ],
                ),
              ),
              BlocBuilder<GetProfileBloc, GetProfileState>(
                builder: (context, state) {
                  if (state is GetProfileSuccessState) {
                    _bioController.text = state.profile.bio ?? '';
                    String checkEmailVerified =
                        state.profile.isEmailVerified != null &&
                                state.profile.email != '' &&
                                state.profile.isEmailVerified == true
                            ? 'Verified'
                            : 'Not Verified';
                    String checkPhoneVerified =
                        state.profile.isPhoneVerified != null &&
                                state.profile.phoneNumber != '' &&
                                state.profile.isPhoneVerified == true
                            ? 'Verified'
                            : 'Not Verified';

                    _emailController.text =
                        state.profile.email != null && state.profile.email != ''
                            ? '${state.profile.email}'
                            : '';
                    _usernameController.text = state.profile.username;

                    _phoneNumberController.text =
                        state.profile.phoneNumber != '' &&
                                state.profile.phoneNumber != null
                            ? '${state.profile.phoneNumber}'
                            : '';
                    isPhoneVerified = state.profile.isPhoneVerified ?? false;
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
                          isEmpty
                              ? const Text(
                                  'Username and gender cannot be empty',
                                  style: TextStyle(
                                    color: AppColors.redColor,
                                    fontSize: 15,
                                  ),
                                )
                              : Container(),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Username',
                            style: greyonboardingBody1Style,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextFieldWidget(
                            border: true,
                            onChanged: (value) {},
                            controller: _usernameController,
                            lableText: '',
                          ),
                          isUserNameShort
                              ? const Text(
                                  'Username should be at least 6 character long.',
                                  style: TextStyle(
                                    color: AppColors.redColor,
                                    fontSize: 15,
                                  ),
                                )
                              : Container(),
                          const SizedBox(
                            height: 10,
                          ),
                          authType == 'email'
                              ? Text(
                                  'Email Id',
                                  style: greyonboardingBody1Style,
                                )
                              // ? Text(
                              //     state.profile.email != ''
                              //         ? 'Email Id ($checkEmailVerified)'
                              //         : 'Email Id',
                              //     style: greyonboardingBody1Style,
                              //   )
                              : SizedBox(),
                          authType == 'email'
                              ? const SizedBox(
                                  height: 5,
                                )
                              : SizedBox(),
                          authType == 'email'
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(color:AppColors.lightGreyColor),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextField(
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    enabled: false,
                                    onChanged: (value) {},
                                    controller: _emailController,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    minLines: 1,
                                  ),
                                )
                              : SizedBox(),
                          authType == 'phone'
                              // ? Text(
                              //     state.profile.phoneNumber != ''
                              //         ? 'Phone number ($checkPhoneVerified)'
                              //         : 'Phone number',
                              //     style: greyonboardingBody1Style,
                              //   )
                              ? Text(
                                  'Phone number',
                                  style: greyonboardingBody1Style,
                                )
                              : SizedBox(),
                          authType == 'phone'
                              ? const SizedBox(
                                  height: 5,
                                )
                              : SizedBox(),
                          authType == 'phone'
                              ? TextFieldWidget(
                                  enabled: false,
                                  inputType: TextInputType.phone,
                                  maxLength: 10,
                                  border: true,
                                  onChanged: (value) {},
                                  controller: _phoneNumberController,
                                  lableText: 'Phone Number',
                                  digitsOnly: true,
                                )
                              : SizedBox(),
                          invalidPhone
                              ? const Text(
                                  'Invalid Phone number.',
                                  style: TextStyle(
                                    color: AppColors.redColor,
                                    fontSize: 15,
                                  ),
                                )
                              : Container(),
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
                                _selectedGender = newValue!;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'City',
                            style: greyonboardingBody1Style,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          BlocProvider(
                            create: (context) => CityBloc(
                              sl<CityRepository>(),
                            ),
                            child: BlocListener<CityBloc, CityState>(
                              listener: (context, state) {
                                if (state is CityUpdatedState) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'City updated to ${state.city} successfully!'),
                                    ),
                                  );
                                } else if (state is CityErrorState) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Failed to update city: ${state.errorMessage}'),
                                    ),
                                  );
                                }
                              },
                              child: CityDropdown(
                                selectCity: _selectedCity,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedCity = newValue!;
                                  });

                                  if (newValue != null) {
                                    context.read<CityBloc>().add(
                                          UpdateCityEvent(newValue),
                                        );
                                  }
                                },
                              ),
                            ),
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.lightGreyColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              maxLength: 200,
                              textCapitalization: TextCapitalization.sentences,
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
                    return Center(
                      child: BouncingLogoIndicator(
                        logo: 'images/logo.svg',
                      ),
                    );
                    // return const Center(
                    //   child: CircularProgressIndicator(),
                    // );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
