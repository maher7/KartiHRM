import 'package:equatable/equatable.dart';

class DocumentItem {
  final int? id;
  final String? date;
  final int? userId;
  final int? targetEmployeeId;
  final int? initiatedBy;
  final int? docTypeId;
  final String? docTypeName;
  final String? docKey;
  final String? description;
  final String? responseDescription;
  final String? requestFile;
  final String? responseFile;
  final String? responseFileExpireDate;
  final String? responseStatus;
  final DocumentInform? requester;
  final DocumentInform? targetEmployee;
  final DocumentInform? documentInform;

  DocumentItem({
    this.id,
    this.date,
    this.userId,
    this.targetEmployeeId,
    this.initiatedBy,
    this.docTypeId,
    this.docTypeName,
    this.docKey,
    this.description,
    this.responseDescription,
    this.requestFile,
    this.responseFile,
    this.responseFileExpireDate,
    this.responseStatus,
    this.requester,
    this.targetEmployee,
    this.documentInform,
  });

  bool get isAdminInitiated => initiatedBy == 2;

  factory DocumentItem.fromJson(Map<String, dynamic> json) {
    return DocumentItem(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      date: json['date'],
      userId: json['user_id'] != null ? int.tryParse(json['user_id'].toString()) : null,
      targetEmployeeId: json['target_employee_id'] != null ? int.tryParse(json['target_employee_id'].toString()) : null,
      initiatedBy: json['initiated_by'] != null ? int.tryParse(json['initiated_by'].toString()) : null,
      docTypeId: json['user_document_type_id'] != null ? int.tryParse(json['user_document_type_id'].toString()) : null,
      docTypeName: json['document_type'],
      docKey: json['doc_key'],
      description: json['request_description'],
      responseDescription: json['response_description'],
      requestFile: json['request_file'],
      responseFile: json['response_file'],
      responseFileExpireDate: json['response_file_expire_date'],
      responseStatus: json['response_status'],
      requester: json['requester'] != null ? DocumentInform.fromJson(json['requester']) : null,
      targetEmployee: json['target_employee'] != null ? DocumentInform.fromJson(json['target_employee']) : null,
      documentInform: json['informed_to'] != null ? DocumentInform.fromJson(json['informed_to']) : null,
    );
  }
}

class DocumentInform extends Equatable {
  final String? name;
  final String? employeeId;
  final String? department;
  final String? designation;

  const DocumentInform({this.name, this.employeeId, this.department, this.designation});

  factory DocumentInform.fromJson(Map<String, dynamic> json) {
    return DocumentInform(
        name: json['name'],
        employeeId: json['employee_id'],
        department: json['department'],
        designation: json['designation']);
  }

  @override
  List<Object?> get props => [name, employeeId, department, designation];
}

class DocumentItems extends Equatable {
  final List<DocumentItem> items;

  const DocumentItems({this.items = const []});

  factory DocumentItems.fromJson(Map<String, dynamic> json) {
    return DocumentItems(
        items: json['data']['data'] != null
            ? List<DocumentItem>.from((json['data']['data'] as List).map((e) => DocumentItem.fromJson(e)))
            : []);
  }

  @override
  List<Object?> get props => [items];
}
