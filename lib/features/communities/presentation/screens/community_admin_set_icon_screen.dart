import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neighborly_flutter_app/core/constants/status.dart';
import 'package:neighborly_flutter_app/core/widgets/custom_snackbar.dart';
import 'package:neighborly_flutter_app/core/widgets/indicator/custom_circular_progress_indicator.dart';
import '../../../../core/theme/colors.dart';
import '../bloc/community_detail_cubit.dart';
import '../../../../core/constants/imagepickercompress.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  File? _selectedImage;
  String avatarUrl = '';
  bool isLoading = false;

// INIT STATE
  @override
  void initState() {
    super.initState();
    communityCubit = BlocProvider.of<CommunityDetailsCubit>(context);

    avatarUrl = communityCubit.state.community?.avatarUrl ?? '';
  }

  // HEX COLOR CODE DECODER
  Color parseColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    return Color(int.parse('0xFF$hexColor'));
  }

  // PIC IMAGE FROM
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();

    try {
      setState(() {
        isLoading = true;
      });

      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        final XFile compressedImage = await compressImage(imageFileX: image);
        setState(() {
          _selectedImage = File(compressedImage.path);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

// BUILD
  @override
  Widget build(BuildContext context) {
    bool isColor = avatarUrl.length > 1 && avatarUrl.length < 8;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          AppLocalizations.of(context)!.community_Icon,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontSize: 18,
          ),
        ),
        actions: [
          // SAVE BUTTON
          BlocConsumer<CommunityDetailsCubit, CommunityDetailsState>(
            listener: (context, state) {
              // FAILURE STATE
              if (state.status == Status.failure) {
                showSnackBar(
                  context: context,
                  message:
                      state.failure?.message ?? 'oops something went wrong',
                );
              }
              // SUCCESS STATE
              if (state.status == Status.success) {
                communityCubit.getCommunityDetail(
                  communityCubit.state.community?.id ?? '',
                );
                Navigator.of(context).pop();
              }
            },
            builder: (context, state) {
              // LOADING STATE
              if (state.status == Status.loading) {
                return Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: CustomCircularIndicator(),
                );
              }
              return TextButton(
                onPressed: () {
                  if (_selectedImage == null) {
                    showSnackBar(
                      context: context,
                      message: AppLocalizations.of(context)!
                          .select_a_image_to_be_saved,
                    );
                  } else {
                    communityCubit.updateIcon(
                      communityCubit.state.community?.id ?? '',
                      _selectedImage,
                    );
                  }
                },
                child: Text(
                  AppLocalizations.of(context)!.save,
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(top: 16),
        width: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                ClipOval(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.width * 0.7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          isColor ? parseColor(avatarUrl) : Colors.transparent,
                      image: isColor
                          ? null
                          : DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(
                                avatarUrl.contains('#')
                                    ? avatarUrl.replaceFirst('#', '')
                                    : avatarUrl,
                              ),
                            ),
                    ),
                    child: _selectedImage != null
                        ? Image.file(
                            _selectedImage!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : SizedBox(),
                  ),
                ),
                if (isLoading) CustomCircularIndicator(),
                Positioned(
                  bottom: 10,
                  right: 25,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.lightBackgroundColor,
                      ),
                      child: Icon(
                        Icons.camera_alt,
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
