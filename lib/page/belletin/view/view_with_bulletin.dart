import 'package:flutter/material.dart';
import 'package:onesthrm/page/belletin/content/news_bulletin_content.dart';

class ViewWithBulletin extends StatelessWidget {
  final Widget child;

  const ViewWithBulletin({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const NewsBulletinContent(),
        Expanded(child: child),
      ],
    );
  }
}
