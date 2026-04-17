import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesthrm/page/document/bloc/document_bloc.dart';
import 'package:onesthrm/res/widgets/custom_button.dart';
import 'create_document_request_page.dart';
import 'document_requested_list.dart';
import 'pending_document_requests_list.dart';

class DocumentsRequestPage extends StatelessWidget {
  const DocumentsRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final docBloc = instance<DocumentBlocFactory>();

    return BlocProvider<DocumentBloc>(
      create: (_) => docBloc()
        ..add(GetDocumentTypeData())
        ..add(GetDocumentData())
        ..add(GetPendingDocumentRequests()),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            title: Text(
              "documents".tr(),
              style: TextStyle(fontSize: 18.r),
            ),
            bottom: TabBar(
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Theme.of(context).primaryColor,
              tabs: [
                Tab(text: "my_requests".tr()),
                Tab(text: "pending_requests".tr()),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              DocumentsContent(),
              PendingDocumentRequestsList(),
            ],
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(0)),
            child: Padding(
              padding: EdgeInsets.all(8.0.r),
              child: Builder(
                builder: (context) {
                  return CustomHButton(
                    title: "send document request".tr(),
                    clickButton: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                  value: context.read<DocumentBloc>(), child: const CreateDocumentRequestPage())));
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
