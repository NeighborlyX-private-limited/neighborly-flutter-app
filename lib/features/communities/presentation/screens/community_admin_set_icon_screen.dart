// import 'dart:io';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:neighborly_flutter_app/core/widgets/custom_snackbar.dart';
// import '../../../../core/theme/colors.dart';
// import '../bloc/community_detail_cubit.dart';
// import '../../../../core/constants/imagepickercompress.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class CommunityAdminIconScreen extends StatefulWidget {
//   const CommunityAdminIconScreen({
//     super.key,
//   });

//   @override
//   State<CommunityAdminIconScreen> createState() =>
//       _CommunityAdminIconScreenState();
// }

// class _CommunityAdminIconScreenState extends State<CommunityAdminIconScreen> {
//   late CommunityDetailsCubit communityCubit;

//   final bool showChange = true;
//   File? _selectedImage;
//   late String communityId;
//   String avatarUrl = '';

//   ///init state method
//   @override
//   void initState() {
//     super.initState();
//     communityCubit = BlocProvider.of<CommunityDetailsCubit>(context);
//     communityId = communityCubit.state.community?.id ?? '';
//     avatarUrl = communityCubit.state.community?.avatarUrl ?? '';
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   /// color parser
//   Color parseColor(String hexColor) {
//     hexColor = hexColor.replaceAll('#', '');
//     return Color(int.parse('0xFF$hexColor'));
//   }

//   ///pic image from gallery
//   Future<void> _pickImage() async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? image =
//         await picker.pickImage(source: ImageSource.gallery).then(
//       (file) {
//         return compressImage(imageFileX: file);
//       },
//     );

//     if (image != null) {
//       setState(() {
//         _selectedImage = File(image.path);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool isColor = avatarUrl.length > 1 && avatarUrl.length < 8;
//     return Scaffold(
//       backgroundColor: AppColors.lightBackgroundColor,
//       appBar: AppBar(
//         backgroundColor: AppColors.whiteColor,
//         leading: GestureDetector(
//           child: Icon(
//             Icons.arrow_back_ios,
//             color: Colors.black,
//           ),
//           onTap: () {
//             Navigator.pop(context);
//           },
//         ),

//         ///community icon text
//         title: Text(
//           AppLocalizations.of(context)!.community_Icon,
//           style: TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.normal,
//             fontSize: 18,
//           ),
//         ),
//         centerTitle: false,
//         actions: [
//           TextButton(
//             onPressed: () {
//               if (_selectedImage == null) {
//                 showSnackBar(
//                   context: context,
//                   message:
//                       AppLocalizations.of(context)!.select_a_image_to_be_saved,
//                 );
//               } else {
//                 communityCubit.updateIcon(
//                   communityCubit.state.community?.id ?? '',
//                   _selectedImage,
//                 );
//                 Navigator.of(context).pop();
//               }
//             },
//             child: Text(
//               AppLocalizations.of(context)!.save,
//               style: TextStyle(
//                 color: AppColors.primaryColor,
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: Container(
//         padding: EdgeInsets.only(top: 15),
//         width: double.infinity,
//         color: Colors.white,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Stack(
//               children: [
//                 ClipOval(
//                   child: Container(
//                     width: MediaQuery.of(context).size.width * 0.7,
//                     height: MediaQuery.of(context).size.width * 0.7,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color:
//                           isColor ? parseColor(avatarUrl) : Colors.transparent,
//                       image: isColor
//                           ? null
//                           : DecorationImage(
//                               fit: BoxFit.cover,
//                               image: CachedNetworkImageProvider(
//                                 avatarUrl.contains('#')
//                                     ? avatarUrl.replaceFirst('#', '')
//                                     : avatarUrl,
//                               ),
//                             ),
//                     ),
//                     child:
//                         _selectedImage != null && _selectedImage?.path != null
//                             ? Image.file(
//                                 _selectedImage!,
//                                 width: double.infinity,
//                                 fit: BoxFit.cover,
//                               )
//                             : SizedBox(),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 0,
//                   right: 0,
//                   child: GestureDetector(
//                     onTap: () {
//                       _pickImage();
//                     },
//                     child: Container(
//                       width: 45,
//                       height: 45,
//                       decoration: const BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: AppColors.lightBackgroundColor,
//                       ),
//                       child: Icon(
//                         Icons.change_circle,
//                         color: AppColors.primaryColor,
//                         size: 30,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neighborly_flutter_app/core/constants/status.dart';
import 'package:neighborly_flutter_app/core/widgets/bouncing_logo_indicator.dart';
import 'package:neighborly_flutter_app/core/widgets/custom_snackbar.dart';
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

  final bool showChange = true;
  File? _selectedImage;
  late String communityId;
  String avatarUrl = '';
  bool isLoading = false; // New loading flag

  @override
  void initState() {
    super.initState();
    communityCubit = BlocProvider.of<CommunityDetailsCubit>(context);
    communityId = communityCubit.state.community?.id ?? '';
    avatarUrl = communityCubit.state.community?.avatarUrl ?? '';
  }

  /// Color parser
  Color parseColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    return Color(int.parse('0xFF$hexColor'));
  }

  /// Pick image from gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          isLoading = true;
        });
        final XFile? compressedImage = await compressImage(imageFileX: image);
        setState(() {
          _selectedImage = File(compressedImage?.path ?? image.path);
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
        centerTitle: false,
        actions: [
          BlocConsumer<CommunityDetailsCubit, CommunityDetailsState>(
            listener: (context, state) {
              if (state.status == Status.failure) {
                showSnackBar(
                  context: context,
                  message:
                      state.failure?.message ?? 'oops something went wrong',
                );
              }
              if (state.status == Status.success) {
                communityCubit.getCommunityDetail(
                  communityCubit.state.community?.id ?? '',
                );
                Navigator.of(context).pop();
              }
            },
            builder: (context, state) {
              if (state.status == Status.loading) {
                return Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: BouncingLogoIndicator(logo: ''),
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
        padding: EdgeInsets.only(top: 15),
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
                if (isLoading)
                  CircularProgressIndicator(
                    color: AppColors.whiteColor,
                  ),
                Positioned(
                  bottom: 0,
                  right: 0,
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
