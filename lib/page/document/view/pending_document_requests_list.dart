import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/document/bloc/document_bloc.dart';
import 'package:onesthrm/page/document/view/document_response_sheet.dart';
import 'package:onesthrm/page/leave/view/content/general_list_shimmer.dart';

class PendingDocumentRequestsList extends StatelessWidget {
  const PendingDocumentRequestsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentBloc, DocumentState>(
      buildWhen: (prev, curr) =>
          prev.pendingStatus != curr.pendingStatus || prev.pendingItems != curr.pendingItems,
      builder: (context, state) {
        if (state.pendingStatus == NetworkStatus.loading) {
          return const GeneralListShimmer();
        }
        final items = state.pendingItems?.items ?? [];
        if (items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 12),
                Text(
                  "no_pending_requests".tr(),
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final doc = items[index];
            return _PendingRequestCard(doc: doc);
          },
        );
      },
    );
  }
}

class _PendingRequestCard extends StatelessWidget {
  final DocumentItem doc;
  const _PendingRequestCard({required this.doc});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.orange.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.description_outlined, color: Colors.orange.shade700, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  doc.docTypeName ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "action_required".tr(),
                  style: TextStyle(color: Colors.orange.shade800, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (doc.description != null && doc.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                doc.description!,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.black54, fontSize: 13),
              ),
            ),
          if (doc.requester != null)
            Text(
              "${"requested_by".tr()}: ${doc.requester?.name ?? ''}",
              style: const TextStyle(color: Colors.black87, fontSize: 12),
            ),
          if (doc.date != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                "${"request_date".tr()}: ${getDDMMYYYYAsString(date: doc.date!, inputFormat: 'yyyy-MM-dd', outputFormat: 'dd MMM yyyy')}",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ),
          if (doc.docKey != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Icon(Icons.link, size: 14, color: Colors.blue.shade400),
                  const SizedBox(width: 4),
                  Text(
                    "${"auto_saves_to".tr()}: ${doc.docKey!.replaceAll('_', ' ')}",
                    style: TextStyle(color: Colors.blue.shade600, fontSize: 11),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  builder: (_) => BlocProvider.value(
                    value: context.read<DocumentBloc>(),
                    child: DocumentResponseSheet(documentItem: doc),
                  ),
                );
              },
              icon: const Icon(Icons.upload_file, size: 18),
              label: Text("upload_response".tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
