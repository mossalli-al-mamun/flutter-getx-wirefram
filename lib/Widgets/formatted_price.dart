// import 'package:flutter/material.dart';
//
// import '../Config/themes/appStyles/text_styles.dart';
// import '../Utils/currency_formatter.dart';
//
// class FormattedPrice extends StatelessWidget {
//   const FormattedPrice({super.key, this.regularPrice, this.salePrice});
//
//   final dynamic regularPrice;
//   final dynamic salePrice;
//
//   @override
//   Widget build(BuildContext context) {
//     return Text.rich(
//       TextSpan(
//         children: [
//           TextSpan(
//             text: regularPrice != null ? currencyFormatter(regularPrice) : '',
//             style: AppTextStyle.bodyMedium
//                 .copyWith(decoration: salePrice != null ? TextDecoration.lineThrough: TextDecoration.none),
//           ),
//           TextSpan(text: regularPrice != null ? ' ': ''),
//           TextSpan(
//             text: salePrice != null ? currencyFormatter(salePrice) : '',
//             style: AppTextStyle.bodySmall,
//           ),
//         ],
//       ),
//     );
//   }
// }
