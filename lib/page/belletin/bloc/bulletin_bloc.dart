import 'dart:async';
import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onesthrm/page/belletin/bloc/bulletin_state.dart';

typedef BulletinBlocFactory = BulletinBloc Function();

class BulletinBloc extends Cubit<BulletinState> {
  String? _lastDismissedHeadline;

  BulletinBloc() : super(const BulletinState()) {
    loadHeadline();
    Timer.periodic(const Duration(minutes: 10), (_) {
      loadHeadline();
    });
  }

  // Announcements auto-expire after 24 hours so stale tickers don't ride forever.
  static const Duration _expiry = Duration(hours: 24);

  void loadHeadline() async {
    emit(state.copyWith(status: NetworkStatus.loading));
    await Future.delayed(const Duration(seconds: 1));
    final data = await SharedUtil.getValue(bulletinKey);
    // Sanitize: reject junk values like "{}", "[]", "null", pure whitespace, or JSON-object strings
    var cleaned = _sanitize(data);
    // If sanitized empty — clear the stored value so it doesn't linger
    if (cleaned.isEmpty && data != null && data.isNotEmpty) {
      SharedUtil.setValue(bulletinKey, "");
      SharedUtil.setValue(bulletinTimestampKey, "");
    }
    // Enforce 24h TTL: if timestamp is missing or older than _expiry, drop the headline.
    if (cleaned.isNotEmpty) {
      final tsRaw = await SharedUtil.getValue(bulletinTimestampKey);
      final ts = int.tryParse(tsRaw ?? '') ?? 0;
      final ageOk = ts > 0 &&
          DateTime.now().millisecondsSinceEpoch - ts < _expiry.inMilliseconds;
      if (!ageOk) {
        cleaned = '';
        SharedUtil.setValue(bulletinKey, "");
        SharedUtil.setValue(bulletinTimestampKey, "");
      }
    }
    final isDismissed = cleaned == _lastDismissedHeadline;
    final parsed = _parseType(cleaned);
    emit(state.copyWith(
        status: NetworkStatus.success,
        headline: parsed.text,
        dismissed: isDismissed,
        type: parsed.type));
  }

  // Detects urgency from the headline itself. Sender apps may prefix the text
  // with "[URGENT]", "URGENT:", or the RTL equivalents ("דחוף", "عاجل"). The
  // prefix is stripped so the badge carries the signal and the ticker shows
  // only the message body.
  _BulletinParsed _parseType(String raw) {
    if (raw.isEmpty) return _BulletinParsed(raw, BulletinType.info);
    final lower = raw.toLowerCase();
    final urgentPrefixes = [
      '[urgent]',
      'urgent:',
      'urgent -',
      'דחוף:',
      'דחוף -',
      '[דחוף]',
      'عاجل:',
      'عاجل -',
      '[عاجل]',
    ];
    for (final p in urgentPrefixes) {
      if (lower.startsWith(p)) {
        return _BulletinParsed(raw.substring(p.length).trim(), BulletinType.urgent);
      }
    }
    return _BulletinParsed(raw, BulletinType.info);
  }

  String _sanitize(String? raw) {
    if (raw == null) return '';
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return '';
    // Junk values we've seen from the server/location-sync path
    if (trimmed == '{}' || trimmed == '[]' || trimmed == 'null' || trimmed == 'empty') return '';
    // Anything that looks like a JSON object/array shouldn't reach the ticker
    if ((trimmed.startsWith('{') && trimmed.endsWith('}')) ||
        (trimmed.startsWith('[') && trimmed.endsWith(']'))) return '';
    return trimmed;
  }

  void dismiss() {
    _lastDismissedHeadline = state.headline;
    emit(state.copyWith(dismissed: true));
  }
}

class _BulletinParsed {
  final String text;
  final BulletinType type;
  _BulletinParsed(this.text, this.type);
}
