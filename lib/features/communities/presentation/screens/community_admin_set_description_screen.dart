import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/colors.dart';
import '../bloc/community_detail_cubit.dart';

class CommunityAdminDescriptionScreen extends StatefulWidget {
  const CommunityAdminDescriptionScreen({
    super.key,
  });

  @override
  State<CommunityAdminDescriptionScreen> createState() =>
      _CommunityAdminDescriptionScreenState();
}

class _CommunityAdminDescriptionScreenState
    extends State<CommunityAdminDescriptionScreen> {
  late CommunityDetailsCubit communityCubit;
  final newDescriptionEC = TextEditingController();

  @override
  void initState() {
    super.initState();
    communityCubit = BlocProvider.of<CommunityDetailsCubit>(context);
    newDescriptionEC.text = communityCubit.state.community?.description ?? '';
  }

  @override
  void dispose() {
    newDescriptionEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackgroundColor,
      appBar: AppBar(
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
          'Description',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
        actions: [
          TextButton(
              onPressed: () {
                if (newDescriptionEC.text.trim() == '') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Select a description to be saved'),
                    ),
                  );
                } else {
                  communityCubit.updateDescription(
                      communityCubit.state.community?.id ?? '',
                      newDescriptionEC.text.trim());
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
              ))
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(top: 15),
        width: double.infinity,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 450,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                margin: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (value) {},
                  controller: newDescriptionEC,
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
        ),
      ),
    );
  }
}
