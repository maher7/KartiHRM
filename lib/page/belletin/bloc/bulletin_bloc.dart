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

  void loadHeadline() async {
    emit(state.copyWith(status: NetworkStatus.loading));
    await Future.delayed(const Duration(seconds: 1));
    SharedUtil.getValue(bulletinKey).then((data) {
      // Sanitize: reject junk values like "{}", "[]", "null", pure whitespace, or JSON-object strings
      final cleaned = _sanitize(data);
      // If sanitized empty — clear the stored value so it doesn't linger
      if (cleaned.isEmpty && data != null && data.isNotEmpty) {
        SharedUtil.setValue(bulletinKey, "");
      }
      final isDismissed = cleaned == _lastDismissedHeadline;
      emit(state.copyWith(status: NetworkStatus.success, headline: cleaned, dismissed: isDismissed));
    });
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
