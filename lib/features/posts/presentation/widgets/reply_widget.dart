// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:neighborly_flutter_app/core/utils/helpers.dart';

// class ReplyWidget extends StatelessWidget {

//   const ReplyWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           width: 40,
//           height: 40,
//           decoration: const BoxDecoration(
//             shape: BoxShape.circle,
//           ),
//           child: widget.comment.proPic != null
//               ? Image.network(
//                   widget.comment.proPic!,
//                   fit: BoxFit.contain,
//                 )
//               : Image.asset(
//                   'assets/second_pro_pic.png',
//                   fit: BoxFit.contain,
//                 ),
//         ),
//         const SizedBox(
//           width: 12,
//         ),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 widget.comment.userName,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 14,
//                 ),
//               ),
//               const SizedBox(
//                 height: 4,
//               ),
//               Text(
//                 widget.comment.text,
//                 style: TextStyle(
//                   color: Colors.grey[800],
//                   fontSize: 15,
//                   height: 1.3,
//                 ),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Text(
//                     timeAgo(widget.comment.createdAt),
//                     style: const TextStyle(
//                       color: Colors.grey,
//                       fontWeight: FontWeight.w400,
//                       fontSize: 14,
//                       height: 1.3,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
