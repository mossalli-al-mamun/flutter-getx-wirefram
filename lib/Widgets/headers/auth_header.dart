import 'package:flutter/material.dart';

import '../../Config/themes/text_styles.dart';

class AuthHeader extends StatelessWidget {
  final String? title;
  final String? subTitle;

  const AuthHeader({super.key, required this.title, this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: AlignmentDirectional.topStart,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title!,
              style: AppTextStyle.displaySmall,
              textAlign: TextAlign.start,
            ),
            if (subTitle != null)
              Text(
                subTitle!,
                style: AppTextStyle.bodyMedium,
                textAlign: TextAlign.start,
              )
          ],
        ));
  }
}
