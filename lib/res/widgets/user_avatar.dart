import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Circular user avatar that shows the user's photo when available, falling
/// back to a colored circle with the user's initials.
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = 44,
    this.backgroundColor,
    this.textColor = Colors.white,
    this.borderWidth = 0,
    this.borderColor = Colors.white,
  });

  final String? imageUrl;
  final String? name;
  final double size;
  final Color? backgroundColor;
  final Color textColor;
  final double borderWidth;
  final Color borderColor;

  // Palette of distinct colors for initials fallback
  static const List<Color> _palette = [
    Color(0xFF5E81F4),
    Color(0xFFFF6B6B),
    Color(0xFF26C6DA),
    Color(0xFFFFA726),
    Color(0xFF66BB6A),
    Color(0xFFAB47BC),
    Color(0xFFEC407A),
    Color(0xFF7E57C2),
  ];

  Color _colorForName(String name) {
    if (name.isEmpty) return _palette[0];
    final hash = name.codeUnits.fold<int>(0, (a, b) => a + b);
    return _palette[hash % _palette.length];
  }

  String _initials(String? name) {
    if (name == null || name.trim().isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      final first = parts[0];
      return first.length >= 2
          ? first.substring(0, 2).toUpperCase()
          : first.substring(0, 1).toUpperCase();
    }
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final hasValidUrl = imageUrl != null &&
        imageUrl!.isNotEmpty &&
        imageUrl != 'null' &&
        !imageUrl!.contains('default.png') &&
        !imageUrl!.contains('default-profile') &&
        !imageUrl!.endsWith('/') &&
        Uri.tryParse(imageUrl!)?.hasScheme == true;

    final bgColor = backgroundColor ?? _colorForName(name ?? '');
    final initialsText = _initials(name);

    final avatar = ClipOval(
      child: SizedBox(
        height: size,
        width: size,
        child: hasValidUrl
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                placeholder: (_, __) => _initialsCircle(bgColor, initialsText),
                errorWidget: (_, __, ___) => _initialsCircle(bgColor, initialsText),
              )
            : _initialsCircle(bgColor, initialsText),
      ),
    );

    if (borderWidth <= 0) return avatar;
    return Container(
      padding: EdgeInsets.all(borderWidth),
      decoration: BoxDecoration(
        color: borderColor,
        shape: BoxShape.circle,
      ),
      child: avatar,
    );
  }

  Widget _initialsCircle(Color bg, String text) {
    return Container(
      color: bg,
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w700,
          fontSize: size * 0.4,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
