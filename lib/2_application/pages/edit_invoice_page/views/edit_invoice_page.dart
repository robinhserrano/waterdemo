// import 'package:flutter/material.dart';
// import 'package:sprout_mobile_exam_serrano/1_domain/1_domain/entities/product_details_entity.dart';
// import 'package:sprout_mobile_exam_serrano/2_application/pages/product_details/widgets/image_slider.dart';

// class ProductDetailsPageLoaded extends StatelessWidget {
//   const ProductDetailsPageLoaded({required this.product, super.key});
//   final ProductDetailsEntity product;
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       children: [
//         ImageSlider(
//           imageUrls: product.images,
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(
//             horizontal: 12,
//             vertical: 4,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 product.title,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 20,
//                 ),
//               ),
//               Row(
//                 children: [
//                   RichText(
//                     text: TextSpan(
//                       children: [
//                         WidgetSpan(
//                           child: Transform.translate(
//                             offset: const Offset(0, -4),
//                             child: const Text(
//                               r'$',
//                               style: TextStyle(color: Colors.red),
//                             ),
//                           ),
//                         ),
//                         TextSpan(
//                           text: (product.price -
//                                   (product.price *
//                                       (product.discountPercentage / 100)))
//                               .toStringAsFixed(2),
//                           style: const TextStyle(
//                             color: Color(0xfffa455f),
//                             fontWeight: FontWeight.w600,
//                             fontSize: 24,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(
//                     width: 4,
//                   ),
//                   Text(
//                     '\$${product.price}',
//                     style: const TextStyle(
//                       decoration: TextDecoration.lineThrough,
//                       decorationColor: Colors.grey,
//                       color: Colors.grey,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 20,
//                     ),
//                   ),
//                   const SizedBox(
//                     width: 4,
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       vertical: 2,
//                       horizontal: 1.5,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.red.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(32),
//                     ),
//                     child: Text(
//                       '-${product.discountPercentage.toInt()}%',
//                       style: const TextStyle(
//                         color: Color(0xfffa455f),
//                         fontWeight: FontWeight.w700,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   const Icon(
//                     Icons.star,
//                     color: Colors.amber,
//                   ),
//                   Text(
//                     '${product.rating.toStringAsFixed(1)} / 5',
//                   ),
//                   const Spacer(),
//                   Text(
//                     'Stock: ${product.stock}',
//                     style: const TextStyle(
//                       color: Colors.blueGrey,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         Divider(
//           color: Colors.grey.shade300,
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(
//             horizontal: 12,
//             vertical: 4,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Product Details',
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 16,
//                 ),
//               ),
//               Text(
//                 'Brand: ${product.brand}',
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//               Text(
//                 'Category: ${product.category}',
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//               Text(
//                 'Description: ${product.description}',
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
