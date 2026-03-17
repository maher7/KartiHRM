import 'package:flutter/material.dart';

class ViewWithBulletin extends StatelessWidget {
  final Widget child;

  const ViewWithBulletin({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // NewsBulletinContent(),
        Expanded(child: child)],
    );
  }
}
