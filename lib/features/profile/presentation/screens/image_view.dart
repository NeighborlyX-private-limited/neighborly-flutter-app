// import 'package:flutter/material.dart';

// class CenterPopupDemo extends StatelessWidget {
//   const CenterPopupDemo({super.key});

//   void _showImagePopup(BuildContext context, String imageUrl) {
//     final screenHeight = MediaQuery.of(context).size.height;

//     showDialog(
//       context: context,
//       barrierDismissible: true, // Tap outside to dismiss
//       builder: (BuildContext context) {
//         return Dialog(
//           backgroundColor: Colors.transparent,
//           insetPadding: EdgeInsets.zero,
//           child: Center(
//             child: Container(
//               height: screenHeight * 0.5,
//               width: double.infinity,
//               margin: const EdgeInsets.symmetric(horizontal: 16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(16),
//                 child: Image.network(
//                   imageUrl,
//                   fit: BoxFit.cover,
//                   loadingBuilder: (context, child, loadingProgress) {
//                     if (loadingProgress == null) return child;
//                     return const Center(child: CircularProgressIndicator());
//                   },
//                   errorBuilder: (context, error, stackTrace) =>
//                       const Center(child: Icon(Icons.error)),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     const imageUrl =
//         'https://images.unsplash.com/photo-1516117172878-fd2c41f4a759'; // 🔁 Replace with dynamic value

//     return Scaffold(
//       appBar: AppBar(title: const Text('Image Popup Demo')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () => _showImagePopup(context, imageUrl),
//           child: const Text('Show Image Popup'),
//         ),
//       ),
//     );
//   }
// }
