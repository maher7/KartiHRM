import 'package:flutter/material.dart';

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
              'assets/images/ic_logo.png', // Replace with the actual image path
              height: 24,
            ),
            const SizedBox(width: 8),
            const Text(
              'UHRM Powered by',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const Text(
          'One Utilities Cambodia',
          style: TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            children: [
              _buildTextLink('Contact Details'),
              _buildTextLink('T&C'),
              _buildTextLink('Privacy Policy'),
              _buildTextLink('Support Policy'),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _buildTextLink(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        color: Colors.blue, // Adjust color if needed
        decoration: TextDecoration.underline,
      ),
    );
  }
}
