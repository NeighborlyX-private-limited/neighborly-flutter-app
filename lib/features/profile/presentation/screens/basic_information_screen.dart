import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neighborly_flutter_app/core/constants/constants.dart';
import 'package:neighborly_flutter_app/core/widgets/dropdown_search_field.dart';
import 'package:neighborly_flutter_app/dependency_injection.dart';
import 'package:neighborly_flutter_app/features/profile/data/repositories/city_repositories.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/change_home_city_bloc/change_home_city_event.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/change_home_city_bloc/change_home_city_state.dart';
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
import '../../../../core/constants/imagepickercompress.dart';

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

  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _bioController;
  late TextEditingController _locationController;
  late String _selectedGender;
  late String _selectedCity;
  bool isPhoneVerified = true;
  bool isOTPSent = false;

  File? _selectedImage; // Store the selected image

  @override
  void initState() {
    _locationController = TextEditingController();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _bioController = TextEditingController();
    _selectedGender = ShardPrefHelper.getGender() ?? 'Male';
    print(ShardPrefHelper.getHomeCity());
    _selectedCity = ShardPrefHelper.getHomeCity() ?? 'Delhi';

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
    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery).then((file) {
      return compressImage(imageFileX: file);
    });

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

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
                                    content:
                                        Text('Profile updated successfully')),
                              );
                              context.pop('');
                            }
                          },
                          builder: (context, state) {
                            if (state is EditProfileLoadingState) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            return BlocConsumer<ResendOtpBloc, ResendOTPState>(
                                listener: (BuildContext context,
                                    ResendOTPState resentstate) {
                              if (resentstate is ResendOTPFailureState) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(resentstate.error)),
                                );
                              } else if (resentstate is ResendOTPSuccessState) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(resentstate.message)),
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
                                  // List<double> location =
                                  //     ShardPrefHelper.getLocation();

                                  // List<Placemark> placemarks =
                                  //     await placemarkFromCoordinates(
                                  //   location[0],
                                  //   location[1],
                                  // );

                                  _phoneNumberController.text.trim().isNotEmpty
                                      ? ShardPrefHelper.setPhoneNumber(
                                          _phoneNumberController.text.trim())
                                      : ShardPrefHelper.setPhoneNumber('');

                                  ShardPrefHelper.setGender(_selectedGender);
                                  ShardPrefHelper.setHomeCity(_selectedCity);

                                  ShardPrefHelper.setUsername(
                                      _usernameController.text.trim());

                                  if (isPhoneVerified) {
                                    BlocProvider.of<EditProfileBloc>(context)
                                        .add(
                                      EditProfileButtonPressedEvent(
                                        bio: _bioController.text.trim(),
                                        phoneNumber:
                                            _phoneNumberController.text.trim(),
                                        username:
                                            _usernameController.text.trim(),
                                        image: _selectedImage,
                                        gender: _selectedGender,

                                        // homeCoordinates: location,
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
                                            data: _phoneNumberController.text
                                                .trim(),
                                            verificationFor: 'phone-register',
                                            onVerifiedSuccessfully: () {
                                              // This function is executed after verification
                                              BlocProvider.of<EditProfileBloc>(
                                                      context)
                                                  .add(
                                                EditProfileButtonPressedEvent(
                                                  bio: _bioController.text
                                                      .trim(),
                                                  phoneNumber:
                                                      _phoneNumberController
                                                          .text
                                                          .trim(),
                                                  username: _usernameController
                                                      .text
                                                      .trim(),
                                                  image: _selectedImage,
                                                  gender: _selectedGender,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );

                                      //}
                                      //navigate to otp screen;
                                    } else {
                                      BlocProvider.of<EditProfileBloc>(context)
                                          .add(
                                        EditProfileButtonPressedEvent(
                                          bio: _bioController.text.trim(),
                                          phoneNumber: _phoneNumberController
                                              .text
                                              .trim(),
                                          username:
                                              _usernameController.text.trim(),
                                          image: _selectedImage,
                                          gender: _selectedGender,
                                          // homeCoordinates: location,
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
                        // Set initial values when the state is fetched successfully
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

                        _emailController.text = state.profile.email != null &&
                                state.profile.email != ''
                            ? '${state.profile.email}'
                            : '';
                        _usernameController.text = state.profile.username;

                        _phoneNumberController.text =
                            state.profile.phoneNumber != '' &&
                                    state.profile.phoneNumber != null
                                ? '${state.profile.phoneNumber}'
                                : '';
                        isPhoneVerified =
                            state.profile.isPhoneVerified ?? false;
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
                                        color: Colors.red,
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
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                state.profile.email != ''
                                    ? 'Email Id ($checkEmailVerified)'
                                    : 'Email Id',
                                style: greyonboardingBody1Style,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
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
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                state.profile.phoneNumber != ''
                                    ? 'Phone number ($checkPhoneVerified)'
                                    : 'Phone number',
                                style: greyonboardingBody1Style,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFieldWidget(
                                border: true,
                                onChanged: (value) {},
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
                              // BlocProvider<CityBloc, CityState>(
                              //   // Create the BLoC instance

                              //   child: BlocListener<CityBloc, CityState>(
                              //     listener: (context, state) {
                              //       if (state is CityUpdatedState) {
                              //         ScaffoldMessenger.of(context)
                              //             .showSnackBar(
                              //           SnackBar(
                              //               content: Text(
                              //                   'City updated to ${state.city} successfully!')),
                              //         );
                              //       } else if (state is CityErrorState) {
                              //         ScaffoldMessenger.of(context)
                              //             .showSnackBar(
                              //           SnackBar(
                              //               content: Text(
                              //                   'Failed to update city: ${state.errorMessage}')),
                              //         );
                              //       }
                              //     },
                              //     child: CityDropdown(
                              //       selectCity: _selectedCity,
                              //       onChanged: (String? newValue) {
                              //         setState(() {
                              //           _selectedCity = newValue!;
                              //         });

                              //         // Trigger the BLoC event only for the CityDropdown button
                              //         if (newValue != null) {
                              //           context.read<CityBloc>().add(
                              //               CitySelectedEvent(city: newValue));
                              //         }
                              //       },
                              //     ),
                              //   ),
                              // ),
                              // Wrap the dropdown button inside BlocListener and BlocProvider if necessary.

                              BlocProvider(
                                create: (context) => CityBloc(sl<
                                    CityRepository>()), // Create and provide the CityBloc.
                                child: BlocListener<CityBloc, CityState>(
                                  listener: (context, state) {
                                    if (state is CityUpdatedState) {
                                      print("yes");
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'City updated to ${state.city} successfully!')),
                                      );
                                    } else if (state is CityErrorState) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Failed to update city: ${state.errorMessage}')),
                                      );
                                    }
                                  },
                                  child: CityDropdown(
                                    selectCity: _selectedCity,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedCity = newValue!;
                                      });

                                      // Trigger the BLoC event only for the CityDropdown button.
                                      if (newValue != null) {
                                        // Add the UpdateCityEvent to the CityBloc when a new city is selected.
                                        context
                                            .read<CityBloc>()
                                            .add(UpdateCityEvent(newValue));
                                      }
                                    },
                                  ),
                                ),
                              ),

                              // CityDropdown(
                              //   selectCity: _selectedCity,
                              //   onChanged: (String? newValue) {
                              //     setState(() {
                              //       _selectedCity = newValue!;
                              //     });
                              //   },
                              // ),
                              // DropdownSearchField(
                              //   label: 'City',
                              //   items: kCityList,
                              //   onChanged: (value) {
                              //     _locationController.text = value ?? '';
                              //   },
                              //   initialValue: _locationController.text,
                              //   placeholder: _locationController.text,
                              //   // validator: Validatorless.required('Preenchimento é obrigatório'),
                              // ),
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
                                  textCapitalization:
                                      TextCapitalization.sentences,
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
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ],
              ),
            )));
  }
}
