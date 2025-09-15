import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neighborly_flutter_app/core/widgets/custom_snackbar.dart';
import '../../../../core/constants/status.dart';
import '../../../../core/models/community_model.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../bloc/communities_create_cubit.dart';
import '../widgets/community_sheemer.dart';
import '../../../../core/constants/imagepickercompress.dart';
import '../../../../l10n/app_localizations.dart';

class CommunityCreateScreen extends StatefulWidget {
  const CommunityCreateScreen({super.key});

  @override
  State<CommunityCreateScreen> createState() => _CommunityCreateScreenState();
}

class _CommunityCreateScreenState extends State<CommunityCreateScreen> {
  final nameEC = TextEditingController();
  final descriptionEC = TextEditingController();
  final typeEC = TextEditingController();
  final radiusEC = TextEditingController();
  final nameFocusNode = FocusNode();

  late CommunityCreateCubit communityCreateCubit;
  bool bothFieldEnable = false;
  bool isButtonActive = false;

  File? fileToUpload;
  int currentStep = 1;

  // INIT STATE
  @override
  void initState() {
    super.initState();

    communityCreateCubit = BlocProvider.of<CommunityCreateCubit>(context);
    radiusEC.text = '3';
    currentStep = 1;
  }

  // DISPOSE
  @override
  void dispose() {
    nameEC.dispose();
    descriptionEC.dispose();
    typeEC.dispose();
    radiusEC.dispose();
    nameFocusNode.dispose();
    super.dispose();
  }

  // JUMP TO NEXT SCREEN FOR CREATE COMMUNITY
  void jumpNext() {
    setState(() {
      currentStep++;
    });
  }

  // LEAVE THE SCREEN WITH CREATE GROUP
  Future<dynamic> bottomSheetConfirmNotSaved(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteColor,
      showDragHandle: true,
      builder: (BuildContext context) {
        return Container(
          height: 120,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!
                    .are_you_sure_you_want_leave_without_save,
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
                        backgroundColor: Colors.grey[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          AppLocalizations.of(context)!.cancel,
                          style: TextStyle(
                            color: AppColors.blackColor,
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
                          AppLocalizations.of(context)!.yes,
                          style: TextStyle(
                            color: AppColors.whiteColor,
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
    if (nameEC.text.trim() == '') {
      setState(() {
        currentStep = 1;
      });
      if (mounted) {
        showSnackBar(context: context, message: 'Name is mandatory');
      }
    } else {
      String radiusInput = radiusEC.text;
      double radiusDouble = double.parse(radiusInput);
      communityCreateCubit.createCommunity(
        CommunityModel(
          requestStatus: false,
          id: '',
          name: nameEC.text,
          description: descriptionEC.text,
          isPublic: typeEC.text != 'Private' ? true : false,
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
          lastMessageTime: '',
          lastMessage: '',
        ),
        fileToUpload,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          leading: GestureDetector(
            child: Icon(
              Icons.arrow_back_ios,
            ),
            onTap: () {
              if (currentStep == 1) {
                bottomSheetConfirmNotSaved(context);
                return;
              }
              setState(() {
                currentStep--;
              });
            },
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (currentStep == 3) {
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
                  currentStep == 3
                      ? AppLocalizations.of(context)!.create_community
                      : AppLocalizations.of(context)!.next,
                  style: TextStyle(
                    color: AppColors.whiteColor,
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
            // FAILURE STATE
            if (state.status == Status.failure) {
              if (mounted) {
                showSnackBar(
                  context: context,
                  message: state.failure?.message ?? 'Name is mandatory.',
                );
              }
            }

            // SUCCESS STATE
            if (state.status == Status.success) {
              if (mounted) {
                context.go('/group-details/${state.newCommunityId}');
              }
            }
          },
          builder: (context, state) {
            // LOADING STATE
            if (state.status == Status.loading) {
              return const CommunityMainSheemer();
            }
            return Container(
              padding: EdgeInsets.only(top: 15),
              width: double.infinity,
              color: AppColors.whiteColor,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // GROUP NAME AND GROUP TYPE
                    if (currentStep == 1) ...[
                      Step1area(
                        nameController: nameEC,
                        typeController: typeEC,
                        nameFocusNode: nameFocusNode,
                      ),
                    ],

                    // GROUP DESCRIPTION
                    if (currentStep == 2) ...[
                      Step2area(
                        descriptionController: descriptionEC,
                      ),
                    ],

                    // GROUP ICON
                    if (currentStep == 3) ...[
                      Step3area(
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
        ),
      ),
    );
  }
}

// SET GROUP NAME AND GROUP TYPE
class Step1area extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController typeController;
  final FocusNode nameFocusNode;
  const Step1area({
    super.key,
    required this.nameController,
    required this.typeController,
    required this.nameFocusNode,
  });

  @override
  State<Step1area> createState() => _Step1areaState();
}

class _Step1areaState extends State<Step1area> {
// COMMUNITY TYPE BOTTOM SHEET
  void _showCommunityTypeBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteColor,
      useRootNavigator: true,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Community type",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text(
                  "Public",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Anyone can join, see posts, and participate in discussions.',
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                leading: SvgPicture.asset(
                  'assets/outline-public.svg',
                  height: 30,
                  width: 30,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _updateCommunityType("Public");
                },
              ),
              ListTile(
                title: Text(
                  "Private",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Only invited members can join, view posts, and engage in conversations.',
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                leading: SvgPicture.asset(
                  'assets/outline-lock.svg',
                  height: 30,
                  width: 30,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _updateCommunityType("Private");
                },
              ),
            ],
          ),
        );
      },
    );
  }

// UPDATE COMMUNITY TYPE
  void _updateCommunityType(String type) {
    setState(() {
      widget.typeController.text = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                AppLocalizations.of(context)!.community_name,
                style: greyonboardingBody1Style,
              ),
              Text(
                " *",
                style: TextStyle(
                  color: AppColors.redColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),

          // GROUP NAME TEXT FIELD
          TextField(
            maxLines: null,
            controller: widget.nameController,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.community_name,
              hintStyle: TextStyle(
                color: AppColors.lightGreyColor.withOpacity(0.4),
                fontWeight: FontWeight.normal,
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            // THIS IS NOT IN USE BUT I NEED TO MAKE THE NEXT BUTTON ENABLE WHEN NAME AND TYPE BOTH ARE SELECTED
            // CURRENTLY IF TYPE IS NOT SELECTED BY DEFAULT IT IS PUBLIC.
            onChanged: (value) {
              if (widget.typeController.text != 'Choose community type' &&
                  widget.nameController.text != '') {
                setState(() {});
              }
            },
          ),

          const SizedBox(height: 30),
          Row(
            children: [
              Text(
                AppLocalizations.of(context)!.community_Type,
                style: greyonboardingBody1Style,
              ),
              Text(
                " *",
                style: TextStyle(
                  color: AppColors.redColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 5),
          // GROUP TYPE DROP DOWN
          GestureDetector(
            onTap: _showCommunityTypeBottomSheet,
            child: AbsorbPointer(
              child: TextField(
                controller: widget.typeController,
                decoration: InputDecoration(
                  hintText: "Choose community type",
                  hintStyle: TextStyle(
                    color: AppColors.lightGreyColor.withOpacity(0.4),
                    fontWeight: FontWeight.normal,
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: AppColors.primaryColor,
                    ),
                  ),
                  suffixIcon: Container(
                    height: 20,
                    width: 20,
                    padding: EdgeInsets.only(top: 12),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/dropdown-icon.svg',
                        height: 20,
                        width: 20,
                      ),
                    ),
                  ),
                ),
                onChanged: (value) {
                  if (widget.typeController.text != 'Choose community type' &&
                      widget.nameController.text != '') {
                    setState(() {});
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// GROUP DESCRIPTION
class Step2area extends StatefulWidget {
  final TextEditingController descriptionController;
  const Step2area({
    super.key,
    required this.descriptionController,
  });

  @override
  State<Step2area> createState() => _Step2areaState();
}

class _Step2areaState extends State<Step2area> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.community_Description,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 7),
          Container(
            height: 450,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.greyColor),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              onChanged: (value) {},
              controller: widget.descriptionController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: AppLocalizations.of(context)!.describe_your_community,
                hintStyle: TextStyle(
                  color: AppColors.greyColor.withOpacity(0.4),
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

// GROUP ICON
class Step3area extends StatefulWidget {
  final File? currentFile;
  final bool? isLoading;
  final Function(File) onSelectImage;
  const Step3area({
    super.key,
    this.currentFile,
    required this.onSelectImage,
    this.isLoading = false,
  });

  @override
  State<Step3area> createState() => _Step3areaState();
}

class _Step3areaState extends State<Step3area> {
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.image_Cover_Avatar,
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
                      color: AppColors.primaryColor,
                    ),
                    child: Center(
                      child: SizedBox(
                        height: 40,
                        width: 40,
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
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
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryColor,
                    ),
                  ),
                  child: selectedImage != null && selectedImage?.path != null
                      ? Image.file(
                          selectedImage!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Center(
                          child: Text('Choose a photo'),
                        ),
                ),
              ),
              Positioned(
                bottom: 20,
                right: 30,
                child: GestureDetector(
                  onTap: () {
                    if (widget.isLoading == true) return;

                    _pickImage();
                  },
                  child: Icon(
                    Icons.change_circle,
                    color: AppColors.primaryColor,
                    size: 30,
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
