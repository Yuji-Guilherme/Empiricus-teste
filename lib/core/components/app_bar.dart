import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget actionWidget;
  final Widget? title;

  const CustomAppBar({super.key, required this.actionWidget, this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 68,
      leading: Padding(
        padding: const .only(left: 5),
        child: Container(
          padding: const .all(12),
          child: SvgPicture.asset('assets/images/logo.svg', fit: .contain),
        ),
      ),
      title: title,
      centerTitle: true,
      actions: [Padding(padding: const .only(right: 4), child: actionWidget)],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(68);
}
