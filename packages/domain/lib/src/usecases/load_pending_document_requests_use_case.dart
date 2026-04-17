import 'package:core/core.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meta_club_api/meta_club_api.dart';

class LoadPendingDocumentRequests extends BaseUseCase<DocumentItems> {
  final HRMCoreBaseService hrmCoreBaseService;

  LoadPendingDocumentRequests({required this.hrmCoreBaseService});

  @override
  Future<Either<Failure, DocumentItems>> call() {
    return hrmCoreBaseService.pendingDocumentRequests();
  }
}
