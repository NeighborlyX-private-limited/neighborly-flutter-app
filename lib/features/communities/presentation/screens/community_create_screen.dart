import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/constants/status.dart';
import '../../../../core/models/community_model.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/widgets/dropdown_search_field.dart';
import '../../../../core/widgets/text_field_widget.dart';
import '../bloc/communities_create_cubit.dart';
import '../widgets/community_sheemer.dart';
import '../../../../core/constants/imagepickercompress.dart';

class CommunityCreateScreen extends StatefulWidget {
  const CommunityCreateScreen({super.key});

  @override
  State<CommunityCreateScreen> createState() => _CommunityCreateScreenState();
}

class _CommunityCreateScreenState extends State<CommunityCreateScreen> {
  final nameEC = TextEditingController();
  final descriptionEC = TextEditingController();
  final typeEC = TextEditingController(text: 'public');
  final radiusEC = TextEditingController();

  /// in future we have plan to add location during create community
  //final locationEC = TextEditingController();

  File? fileToUpload;
  late CommunityCreateCubit communityCreateCubit;
  int currentStep = 1;

  ///init method
  @override
  void initState() {
    super.initState();
    communityCreateCubit = BlocProvider.of<CommunityCreateCubit>(context);
    radiusEC.text = '3';
    currentStep = 1;
  }

  ///dispose method
  @override
  void dispose() {
    nameEC.dispose();
    descriptionEC.dispose();
    typeEC.dispose();
    radiusEC.dispose();
    //locationEC.dispose();
    super.dispose();
  }

  ///  jump to next form
  void jumpNext() {
    setState(() {
      if (currentStep == 2) {
        /// because we have comment 3rd step to get radius of the from the user
        currentStep += 2;
      } else {
        currentStep++;
      }
    });
  }

  /// title selection
  String titleSelector(int step) {
    switch (step) {
      case 1:
        return 'create - basic';
      case 2:
        return 'create - descr.';
      // case 3:
      //   return 'create - locat.';
      case 4:
        return 'create - image';
      default:
        return 'create';
    }
  }

  /// user leave with save with creating gorups confirmation bottom sheet
  Future<dynamic> bottomSheetConfirmNotSaved(BuildContext context) {
    return showModalBottomSheet(
      backgroundColor: AppColors.whiteColor,
      showDragHandle: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          height: 120,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Are you sure you want leave without save?',
                style: TextStyle(fontSize: 16),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            height: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff635BFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Yes',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            height: 0.3,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void processSave() {
    ///  Save process start
    print('...nameEC: ${nameEC.text}');
    print('...descriptionEC: ${descriptionEC.text}');
    print('...typeEC: ${typeEC.text}');
    print('...radiusEC: ${radiusEC.text}');
    print('...fine to uploade: $fileToUpload');

    /// group name can not be empty
    if (nameEC.text.trim() == '') {
      setState(() {
        currentStep = 1;
      });
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('Name is mandatory'),
            ),
          );
      }
    } else {
      String radiusInput = radiusEC.text;
      double radiusDouble = double.parse(radiusInput);
      communityCreateCubit.createCommunity(
        CommunityModel(
          id: '',
          name: nameEC.text,
          description: descriptionEC.text,
          isPublic: typeEC.text != 'public' ? false : true,
          radius: radiusDouble.toInt(),
          displayName: '',
          locationStr: '',
          avatarUrl: '',
          karma: 0,
          membersCount: 1,
          isJoined: true,
          isAdmin: true,
          isMuted: false,
          users: [],
          admins: [],
          blockList: [],
          createdAt: DateTime.now().toString(),
        ),
        fileToUpload,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onTap: () {
            if (currentStep == 1) {
              bottomSheetConfirmNotSaved(context);
              return;
            }
            setState(() {
              if (currentStep == 4) {
                currentStep -= 2;
              } else {
                currentStep--;
              }
            });
          },
        ),
        title: Text(titleSelector(currentStep)),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (currentStep == 4) {
                processSave();
              } else {
                jumpNext();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                currentStep == 4 ? 'Save' : 'Next >',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  height: 0.3,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: BlocConsumer<CommunityCreateCubit, CommunityCreateState>(
        listener: (context, state) {
          ///failure state
          if (state.status == Status.failure) {
            if (mounted) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text('oops something went wrong!'),
                  ),
                );
            }
          }

          ///success state
          if (state.status == Status.success) {
            if (mounted) {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              context.push('/groups/${state.newCommunityId}');
            }
          }
        },
        builder: (context, state) {
          return BlocBuilder<CommunityCreateCubit, CommunityCreateState>(
            builder: (context, state) {
              ///  loading state
              if (state.status == Status.loading) {
                return const CommunityMainSheemer();
              }

              return Container(
                padding: EdgeInsets.only(top: 15),
                width: double.infinity,
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      /// for name and group type
                      if (currentStep == 1) ...[
                        Step1area(
                          nameController: nameEC,
                          typeController: typeEC,
                        ),
                      ],

                      /// for group desc
                      if (currentStep == 2) ...[
                        Step2area(
                          descriptionController: descriptionEC,
                        ),
                      ],

                      ///for location and radius
                      // if (currentStep == 3) ...[
                      //   Step3area(
                      //     //locationController: locationEC,
                      //     radiusController: radiusEC,
                      //   ),
                      // ],

                      /// for group icon or image
                      if (currentStep == 4) ...[
                        Step4area(
                          isLoading: state.uploadIsLoading,
                          currentFile: fileToUpload,
                          onSelectImage: (newFile) {
                            // ignore: unnecessary_null_comparison
                            if (newFile != null) {
                              setState(() {
                                fileToUpload = newFile;
                              });
                            }
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

///step 1 area for taking group name, choose group type
class Step1area extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController typeController;
  const Step1area({
    super.key,
    required this.nameController,
    required this.typeController,
  });

  @override
  State<Step1area> createState() => _Step1areaState();
}

///step 1 area state for taking group name, choose group type
class _Step1areaState extends State<Step1area> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Name',
            style: greyonboardingBody1Style,
          ),
          const SizedBox(height: 5),

          /// name text field
          TextFieldWidget(
            border: true,
            onChanged: (value) {},
            controller: widget.nameController,
            lableText: '',
          ),
          const SizedBox(height: 30),

          ///group type drop down
          DropdownSearchField(
            label: 'Choose your group type',
            items: ['public', 'private'],
            onChanged: (value) {
              widget.typeController.text = value ?? 'public';
            },
            initialValue: widget.typeController.text,
            placeholder: 'Community Type',
          ),
        ],
      ),
    );
  }
}

///step 2 area for taking group description
class Step2area extends StatefulWidget {
  final TextEditingController descriptionController;
  const Step2area({
    super.key,
    required this.descriptionController,
  });

  @override
  State<Step2area> createState() => _Step2areaState();
}

///step 2 area state for taking group description
class _Step2areaState extends State<Step2area> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Community Description',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 7),
          Container(
            height: 450,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              onChanged: (value) {},
              controller: widget.descriptionController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Describe your community',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                ),
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              minLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}

///step 3 area for taking group location and radius
class Step3area extends StatefulWidget {
  //final TextEditingController locationController;
  final TextEditingController radiusController;
  const Step3area({
    super.key,
    //required this.locationController,
    required this.radiusController,
  });

  @override
  State<Step3area> createState() => _Step3areaState();
}

///step 3 area state for taking group location and radius
class _Step3areaState extends State<Step3area> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // DropdownSearchField(
          //   label: 'Choose your location',
          //   items: kLocationList,
          //   onChanged: (value) {
          //     widget.locationController.text = value ?? '';
          //   },
          //   initialValue: widget.locationController.text,
          //   placeholder: 'Location',
          //   // validator: Validatorless.required('Preenchimento é obrigatório'),
          // ),
          // const SizedBox(height: 30),
          Text(
            'Community Radius',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 7),
          FlutterSlider(
            values: [double.parse(widget.radiusController.text)],
            max: kMaxRadius,
            min: kMinRadius,
            onDragging: (handlerIndex, lowerValue, upperValue) {
              setState(() {
                widget.radiusController.text = '$lowerValue';
              });
            },
          ),
          Text(
            '  ${widget.radiusController.text} miles',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

///step 4 area  for taking group icon
class Step4area extends StatefulWidget {
  final File? currentFile;
  final bool? isLoading;
  final Function(File) onSelectImage;
  const Step4area({
    super.key,
    this.currentFile,
    required this.onSelectImage,
    this.isLoading = false,
  });

  @override
  State<Step4area> createState() => _Step4areaState();
}

///step 4 area state for taking group icon
class _Step4areaState extends State<Step4area> {
  late File? selectedImage;

  @override
  void initState() {
    super.initState();
    selectedImage = widget.currentFile;
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery).then((file) {
      return compressImage(imageFileX: file);
    });

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
        widget.onSelectImage(selectedImage!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Image Cover/Avatar',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 7),
          Stack(
            children: [
              if (widget.isLoading == true) ...[
                ClipOval(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.width * 0.7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.7),
                    ),
                    child: Center(
                      child: SizedBox(
                        height: 40,
                        width: 40,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              ClipOval(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.width * 0.7,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: selectedImage != null && selectedImage?.path != null
                      ? Image.file(
                          selectedImage!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          'https://eu.ui-avatars.com/api/?name=group&background=random&rounded=true',
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    if (widget.isLoading == true) return;

                    _pickImage();
                  },
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.lightBackgroundColor,
                    ),
                    child: Icon(
                      Icons.change_circle,
                      color: AppColors.primaryColor,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
