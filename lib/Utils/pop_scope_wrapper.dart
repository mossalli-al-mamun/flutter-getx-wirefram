import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/colors_ext.dart';
import '../Controller/locale/localization_service_controller.dart';

class PopScopeWrapper extends StatelessWidget {
  const PopScopeWrapper({super.key, required this.child});

  final Widget child;

  Future<bool> _showBackDialog(BuildContext context) async {
    return (await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(tr.areYouSure),
          content: Text(tr.areYouSureDetails),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
                foregroundColor: context.primary,
              ),
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(tr.neverMind),
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
                foregroundColor: context.primary,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: Text(tr.leave),
            ),
          ],
        );
      },
    )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      // ✅ New API: use `onPopInvokedWithResult`
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;

        final shouldPop = await _showBackDialog(context);
        if (!context.mounted) return;

        if (shouldPop) {
          final isFirst = ModalRoute.of(context)?.isFirst ?? false;
          if (isFirst) {
            SystemNavigator.pop(); // Exit app
          } else {
            Navigator.of(context).pop(true); // Pop route
          }
        }
      },
      child: child,
    );
  }
}
