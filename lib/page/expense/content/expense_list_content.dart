import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesthrm/page/expense/bloc/expense_bloc.dart';
import 'package:onesthrm/page/expense/content/expense_details.dart';
import 'package:onesthrm/page/expense/content/expense_list_shimmer.dart';
import 'package:onesthrm/res/nav_utail.dart';

class ExpenseListContent extends StatelessWidget {
  const ExpenseListContent({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<ExpenseBloc>();
    return context.read<ExpenseBloc>().state.responseExpenseList?.data.length != null
        ? bloc.state.responseExpenseList?.data.isNotEmpty == true
            ? Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  itemCount: bloc.state.responseExpenseList?.data.length ?? 0,
                  itemBuilder: (context, i) {
                    final data = bloc.state.responseExpenseList?.data[i];
                    return Container(
                      margin: EdgeInsets.only(bottom: 8.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade100),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            NavUtil.navigateScreen(context, ExpenseDetails(data: data));
                          },
                          child: Padding(
                            padding: EdgeInsets.all(14.r),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        data?.category ?? "",
                                        style: TextStyle(fontSize: 14.r, fontWeight: FontWeight.w600, color: Colors.black87),
                                      ),
                                    ),
                                    Text(
                                      data?.dateShow ?? "",
                                      style: TextStyle(fontSize: 11.r, color: Colors.black38),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                Row(
                                  children: [
                                    _buildBadge(
                                      label: data?.status ?? '',
                                      colorHex: data?.statusColor,
                                    ),
                                    SizedBox(width: 8.w),
                                    _buildBadge(
                                      label: data?.payment ?? '',
                                      colorHex: data?.paymentColor,
                                    ),
                                    const Spacer(),
                                    Icon(Icons.arrow_forward_ios_rounded, size: 14.r, color: Colors.black26),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            : const Expanded(child: NoDataFoundWidget())
        : const ExpenseListShimmer();
  }

  Widget _buildBadge({required String label, String? colorHex}) {
    Color badgeColor;
    try {
      badgeColor = Color(int.parse(colorHex ?? '0xFF999999'));
    } catch (_) {
      badgeColor = Colors.grey;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 10.r,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
