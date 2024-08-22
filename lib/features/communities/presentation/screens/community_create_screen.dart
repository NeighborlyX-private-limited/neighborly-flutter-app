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

class CommunityCreateScreen extends StatefulWidget {
  const CommunityCreateScreen({super.key});

  @override
  State<CommunityCreateScreen> createState() => _CommunityCreateScreenState();
}

class _CommunityCreateScreenState extends State<CommunityCreateScreen> {
  late var communityCreateCubit;
  int currentStep = 1;
  File? fileToUpload;

  final nameEC = TextEditingController();
  final descriptionEC = TextEditingController();
  final locationEC = TextEditingController();
  final typeEC = TextEditingController(text: 'public');
  final radiusEC = TextEditingController();

  @override
  void initState() {
    super.initState();

    communityCreateCubit = BlocProvider.of<CommunityCreateCubit>(context);
    radiusEC.text = '1';
    currentStep = 1;
  }

  @override
  void dispose() {
    super.dispose();
    nameEC.dispose();
    descriptionEC.dispose();
    locationEC.dispose();
    typeEC.dispose();
    radiusEC.dispose();
  }

  Future<dynamic> bottomSheetConfirmNotSaved(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        // String? userId = ShardPrefHelper.getUserID();
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
                          borderRadius: BorderRadius.circular(50), // Ajuste o raio conforme necessário
                        ),
                        // padding: EdgeInsets.all(15)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.black, fontSize: 18, height: 0.3),
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
                          borderRadius: BorderRadius.circular(50), // Ajuste o raio conforme necessário
                        ),
                        // padding: EdgeInsets.all(15)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Yes',
                          style: TextStyle(color: Colors.white, fontSize: 18, height: 0.3),
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

  void jumpNext() {
    setState(() {
      currentStep++;
    });
  }

  String titleSelector(int step) {
    switch (step) {
      case 1:
        return 'create - basic';
      case 2:
        return 'create - descr.';
      case 3:
        return 'create - locat.';
      case 4:
        return 'create - image';
      default:
        return 'create';
    }
  }

  void processSave() {
    // #save
    print('... ${nameEC.text}');
    print('... ${descriptionEC.text}');
    print('... ${locationEC.text}');
    print('... ${typeEC.text}');
    print('... ${radiusEC.text}');

    if (nameEC.text.trim() == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Name is mandatory'),
        ),
      );
      setState(() {
        currentStep = 1;
      });
    }

    if (locationEC.text.trim() == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location is mandatory'),
        ),
      );
      setState(() {
        currentStep = 3;
      });
    }

    if ((locationEC.text.trim() != '') && (nameEC.text.trim() != '')) {
      communityCreateCubit.createCommunity(
          CommunityModel(
            id: '',
            name: nameEC.text,
            description: descriptionEC.text,
            locationStr: locationEC.text,
            createdAt: DateTime.now().toString(),
            avatarUrl: '',
            karma: 0,
            membersCount: 1,
            isPublic: typeEC.text != 'public' ? false : true,
            isJoined: true,
            isMuted: false,
            users: [],
            admins: [],
            blockList: [],
          ),
          fileToUpload);
    }

    //    final nameEC = TextEditingController();
    // final descriptionEC = TextEditingController();
    // final locationEC = TextEditingController();
    // final typeEC = TextEditingController();
    // final radiusEC = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onTap: () {
            print('currentStep=${currentStep}');

            if (currentStep == 1) {
              bottomSheetConfirmNotSaved(context);
              return;
            }

            setState(() {
              currentStep--;
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
                borderRadius: BorderRadius.circular(50), // Ajuste o raio conforme necessário
              ),
              // padding: EdgeInsets.all(15)
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                currentStep == 4 ? 'Save' : 'Next >',
                style: TextStyle(color: Colors.white, fontSize: 18, height: 0.3),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: BlocConsumer<CommunityCreateCubit, CommunityCreateState>(
        listener: (context, state) {
          print('... state.currentUser: ${state.status}');

          switch (state.status) {
            case Status.loading:
              break;
            case Status.failure:
              // hideLoader();
              // showError(state.errorMessage ?? 'Some error');
              print('ERROR ${state.failure?.message}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Something went wrong! ${state.failure?.message}'),
                ),
              );
              break;
            case Status.success:
              print('Success JUMP to ${state.newCommunityId}');
              Navigator.of(context).pop();
              context.push('/groups/${state.newCommunityId}');
              break;
            case Status.initial:
              break;
          }
        },
        builder: (context, state) {
          //
          //
          return BlocBuilder<CommunityCreateCubit, CommunityCreateState>(
            bloc: communityCreateCubit,
            builder: (context, state) {
              if (state.status == Status.loading) {
                return const CommunityMainSheemer();
              }

              return Container(
                padding: EdgeInsets.only(top: 15),
                width: double.infinity,
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //
                      //
                      if (currentStep == 1) ...[
                        Step1area(nameController: nameEC, typeController: typeEC),
                      ],
                      //
                      //
                      if (currentStep == 2) ...[
                        Step2area(descriptionController: descriptionEC),
                      ],
                      //
                      //
                      if (currentStep == 3) ...[
                        Step3area(locationController: locationEC, radiusController: radiusEC),
                      ],
                      //
                      //
                      if (currentStep == 4) ...[
                        Step4area(
                          isLoading: state.uploadIsLoading,
                          currentFile: fileToUpload,
                          onSelectImage: (newFile) {
                            print('newFile=${newFile.path}');

                            // ignore: unnecessary_null_comparison
                            if (newFile != null) {
                              setState(() {
                                fileToUpload = newFile;
                              });

                              communityCreateCubit.onUpdateFile(newFile);
                            }
                          },
                        ),
                      ],
                      //
                      //
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

// #####################################################
// #####################################################
// #####################################################

class Step1area extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController typeController;
  const Step1area({
    Key? key,
    required this.nameController,
    required this.typeController,
  }) : super(key: key);

  @override
  State<Step1area> createState() => _Step1areaState();
}

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
          TextFieldWidget(
            border: true,
            onChanged: (value) {},
            controller: widget.nameController,
            lableText: '',
          ),
          const SizedBox(height: 30),
          //
          //
          DropdownSearchField(
            label: 'Choose your location',
            items: ['public', 'private'],
            onChanged: (value) {
              widget.typeController.text = value ?? '';
            },
            initialValue: widget.typeController.text,
            placeholder: 'Community Type',
            // validator: Validatorless.required('Preenchimento é obrigatório'),
          ),
        ],
      ),
    );
  }
}

// #####################################################
// #####################################################
// #####################################################

class Step2area extends StatefulWidget {
  final TextEditingController descriptionController;
  const Step2area({
    Key? key,
    required this.descriptionController,
  }) : super(key: key);

  @override
  State<Step2area> createState() => _Step2areaState();
}

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
          //
          Container(
            height: 450,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            // margin: EdgeInsets.all(15),
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
                  )),
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

// #####################################################
// #####################################################
// #####################################################

class Step3area extends StatefulWidget {
  final TextEditingController locationController;
  final TextEditingController radiusController;
  const Step3area({
    Key? key,
    required this.locationController,
    required this.radiusController,
  }) : super(key: key);

  @override
  State<Step3area> createState() => _Step3areaState();
}

class _Step3areaState extends State<Step3area> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          //
          DropdownSearchField(
            label: 'Choose your location',
            items: kLocationList,
            onChanged: (value) {
              widget.locationController.text = value ?? '';
            },
            initialValue: widget.locationController.text,
            placeholder: 'Location',
            // validator: Validatorless.required('Preenchimento é obrigatório'),
          ),
          const SizedBox(height: 30),
          //
          //
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
                widget.radiusController.text = '${lowerValue}';
              });
            },
          ),
          //
          //
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

// #####################################################
// #####################################################
// #####################################################

class Step4area extends StatefulWidget {
  final File? currentFile;
  final bool? isLoading;
  final Function(File) onSelectImage;
  const Step4area({
    Key? key,
    this.currentFile,
    required this.onSelectImage,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<Step4area> createState() => _Step4areaState();
}

class _Step4areaState extends State<Step4area> {
  late File? selectedImage;

  @override
  void initState() {
    super.initState();

    selectedImage = widget.currentFile;
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

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
          //
          Stack(
            children: [
              if (widget.isLoading == true) ...[
                ClipOval(
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.width * 0.7,
                      // height: 190,
                      decoration:   BoxDecoration(
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
                      )),
                ),
              ],
              ClipOval(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.width * 0.7,
                  // height: 190,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: selectedImage != null && selectedImage?.path != null
                      ? Image.file(
                          selectedImage!,
                          width: double.infinity,
                          // height: 260,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          'https://eu.ui-avatars.com/api/?name=XX&background=random&rounded=true',
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    if(widget.isLoading == true) return; 

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
