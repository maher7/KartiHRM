part of 'document_bloc.dart';

class DocumentState extends Equatable {
  final NetworkStatus? status;
  final NetworkStatus? pendingStatus;
  final NetworkStatus? respondStatus;
  final String? date;
  final String? reason;
  final String? documentPath;
  final DocumentType? docType;
  final DocumentTypes? documentTypes;
  final DocumentItems? documentItems;
  final DocumentItems? pendingItems;
  final PhoneBookUser? selectedEmployee;

  const DocumentState({
    this.status,
    this.pendingStatus,
    this.respondStatus,
    this.date,
    this.selectedEmployee,
    this.docType,
    this.documentTypes,
    this.reason,
    this.documentItems,
    this.pendingItems,
    this.documentPath,
  });

  DocumentState copy({
    NetworkStatus? status,
    NetworkStatus? pendingStatus,
    NetworkStatus? respondStatus,
    String? date,
    DocumentType? docType,
    DocumentTypes? documentTypes,
    DocumentItems? documentItems,
    DocumentItems? pendingItems,
    String? reason,
    String? documentPath,
    PhoneBookUser? selectedEmployee,
  }) {
    return DocumentState(
      status: status ?? this.status,
      pendingStatus: pendingStatus ?? this.pendingStatus,
      respondStatus: respondStatus ?? this.respondStatus,
      date: date ?? this.date,
      docType: docType ?? this.docType,
      reason: reason ?? this.reason,
      documentItems: documentItems ?? this.documentItems,
      pendingItems: pendingItems ?? this.pendingItems,
      documentTypes: documentTypes ?? this.documentTypes,
      documentPath: documentPath ?? this.documentPath,
      selectedEmployee: selectedEmployee ?? this.selectedEmployee,
    );
  }

  @override
  List<Object?> get props => [status, pendingStatus, respondStatus, date, selectedEmployee, docType, documentItems, pendingItems, documentTypes];
}
