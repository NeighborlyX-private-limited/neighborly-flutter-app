import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/colors.dart';
import '../bloc/community_detail_cubit.dart';
import '../../../../core/constants/imagepickercompress.dart';

class CommunityAdminIconScreen extends StatefulWidget {
  const CommunityAdminIconScreen({
    super.key,
  });

  @override
  State<CommunityAdminIconScreen> createState() =>
      _CommunityAdminIconScreenState();
}

class _CommunityAdminIconScreenState extends State<CommunityAdminIconScreen> {
  late CommunityDetailsCubit communityCubit;

  final bool showChange = true;
  File? _selectedImage;
  late String communityId;
  String avatarUrl = '';

  ///init state method
  @override
  void initState() {
    super.initState();
    communityCubit = BlocProvider.of<CommunityDetailsCubit>(context);
    communityId = communityCubit.state.community?.id ?? '';
    avatarUrl = communityCubit.state.community?.avatarUrl ?? '';
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// color parser
  Color parseColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    return Color(int.parse('0xFF$hexColor'));
  }

  ///pic image from gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery).then(
      (file) {
        return compressImage(imageFileX: file);
      },
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
        // communityCubit.updateIcon(communityId, _selectedImage!);
        // communityCubit.onUpdateFile(_selectedImage!);
      });
    }
  }

  Future<dynamic> bottomSheetConfirmNotSaved(BuildContext context) {
    return showModalBottomSheet(
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
                'if you leave, the icon will not be saved. Are you sure?',
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
                              color: Colors.black, fontSize: 18, height: 0.3),
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

  @override
  Widget build(BuildContext context) {
    bool isColor = avatarUrl.length > 1 && avatarUrl.length < 8;
    return Scaffold(
      backgroundColor: AppColors.lightBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.pop(context);
            // bottomSheetConfirmNotSaved(context);
          },
        ),

        ///community icon
        title: Text(
          'Community Icon',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
        actions: [
          _selectedImage == null
              ? TextButton(
                  onPressed: () {
                    _pickImage();
                  },
                  child: Text(
                    'Change',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : TextButton(
                  onPressed: () {
                    if (_selectedImage == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Select a image to be saved'),
                        ),
                      );
                    } else {
                      communityCubit.updateIcon(
                        communityCubit.state.community?.id ?? '',
                        _selectedImage,
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(top: 15),
        width: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipOval(
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.width * 0.7,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isColor
                              ? parseColor(avatarUrl)
                              : Colors.transparent,
                          image: isColor
                              ? null
                              : DecorationImage(
                                  fit: BoxFit.cover,
                                  image: CachedNetworkImageProvider(
                                    avatarUrl.contains('#')
                                        ? avatarUrl.replaceFirst('#', '')
                                        : avatarUrl,
                                  ),
                                )),
                      child:
                          _selectedImage != null && _selectedImage?.path != null
                              ? Image.file(
                                  _selectedImage!,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                )
                              : SizedBox()),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
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
      ),
    );
  }
}
