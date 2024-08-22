import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/colors.dart';

class EventEmptyGoing extends StatelessWidget {
  const EventEmptyGoing({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/event_empty.svg'),
    
        Text(
          'You\'re not goiing to any events yet.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 5),
        //
        //
        Text(
          'Explore and join one to see it here',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
        const SizedBox(
           height: 15,
        ),
        // 
        // 
        ElevatedButton(
          onPressed: () {
            // Lógica ao clicar no botão
            // context.go('/groups/create');
            print('Explore Events');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50), // Ajuste o raio conforme necessário
            ),
            // padding: EdgeInsets.all(15)
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: Text(
              'Explore Events',
              style: TextStyle(color: Colors.white, fontSize: 16, height: 0.3),
            ),
          ),
        )
      ],
    );
  }
}
