import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PoweredByWidget extends StatelessWidget {
  const PoweredByWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/karti_transparent.png',
              height: 24,
            ),
            const SizedBox(width: 8),
            const Text(
              'Powered by Karti',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            children: [
              _buildTextLink('Contact Details', 'https://karti.online/contact'),
              _buildTextLink('T&C', 'https://karti.online/terms'),
              _buildTextLink('Privacy Policy', 'https://karti.online/privacy'),
              _buildTextLink('Support Policy', 'https://karti.online/support'),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _buildTextLink(String text, String url) {
    return InkWell(
      borderRadius: BorderRadius.circular(4),
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Branding.colors.primaryLight,
            decoration: TextDecoration.underline,
            decorationColor: Branding.colors.primaryLight,
          ),
        ),
      ),
    );
  }
}
