import 'dart:io';
import 'package:core/core.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meta_club_api/meta_club_api.dart';

class RespondToDocumentRequest {
  final HRMCoreBaseService hrmCoreBaseService;

  RespondToDocumentRequest({required this.hrmCoreBaseService});

  Future<Either<Failure, bool>> call({required int requestId, required File file, String? description}) {
    return hrmCoreBaseService.respondToDocumentRequest(requestId: requestId, file: file, description: description);
  }
}
