import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/colors.dart';

class CommunityEmptyWidget extends StatelessWidget {
  const CommunityEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.lightBackgroundColor,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //
          //
          SvgPicture.asset(
            'assets/group-empty.svg',
            width: MediaQuery.of(context).size.width * 0.60,
            // height: 84,
          ),
          const SizedBox(height: 20),
          //
          //
          Text(
            'No Community Groups Yet',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 10),
          //
          //
          Text(
            'Be the first to create a group and start connecting!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 25),
          //
          //

          ElevatedButton(
            onPressed: () {
              // Lógica ao clicar no botão
              context.go('/groups/create');
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff635BFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      50), // Ajuste o raio conforme necessário
                ),
                padding: EdgeInsets.all(15)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Start a Community',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
