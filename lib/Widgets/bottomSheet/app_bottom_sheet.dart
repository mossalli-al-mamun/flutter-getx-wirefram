import 'package:flutter/material.dart';
import 'package:flutter_getx_wireframe/Utils/extensions/size_extension.dart';
import '../../Config/themes/text_styles.dart';
import '../../Utils/device_dimension.dart';

class AppBottomSheet extends StatelessWidget {
  final String? title;
  final String? selected;
  final Widget? widget;
  final double? afterLineSpace;
  final double? sheetHeight;

  const AppBottomSheet(
      {super.key,
      this.title,
      this.selected,
      this.widget,
      this.afterLineSpace = 10.0,
      this.sheetHeight});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: sheetHeight,
      constraints: BoxConstraints(
          maxHeight: deviceDimension(context).height / 2.25,
          minHeight: deviceDimension(context).height / 3.25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          30.height,
          Container(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              title ?? '',
              style: AppTextStyle.titleSmall,
            ),
          ),
          30.height,
          Container(
            height: 1,
            color: Color(0xFFE8E8E8),
          ),
          SizedBox(
            height: afterLineSpace,
          ),
          widget!,
          30.height,
        ],
      ),
    );
  }
}
