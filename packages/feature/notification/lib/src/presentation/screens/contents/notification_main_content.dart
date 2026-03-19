import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notification/src/presentation/cubits/add_notification_cubit.dart';
import 'package:notification/src/presentation/cubits/notification_list_cubit.dart';
import 'package:notification/src/presentation/cubits/notification_list_state.dart';
import 'notification_item.dart';
import 'notification_item_details.dart';

class NotificationMainContent extends StatelessWidget {
  const NotificationMainContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return BlocBuilder<NotificationListCubit, NotificationListState>(
          builder: (context, state) {
            if (state.status == NetworkStatus.success && state.readNotifications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_off_outlined,
                      size: 64,
                      color: Colors.grey.shade300,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No notifications yet',
                      style: TextStyle(
                        fontSize: 16.r,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'You\'ll see your notifications here',
                      style: TextStyle(
                        fontSize: 13.r,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              );
            }
            if (state.status == NetworkStatus.loading) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (content, index) {
                    return TileShimmer(titleHeight: 55.0);
                  },
                  itemCount: 10);
            }
            return ListView.separated(
                shrinkWrap: true,
                itemBuilder: (content, index) {
                  final notification = state.readNotifications[index];
                  return NotificationItem(
                    notification: notification,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                              value: context.read<AddEditNotificationCubit>(),
                              child: NotificationItemDetails(
                                notification: notification,
                                dateFormat: state.dateFormat,
                              ))));
                    },
                  );
                },
                separatorBuilder: (_, __) => Divider(
                      height: 1,
                      color: Colors.grey.shade200,
                    ),
                itemCount: state.readNotifications.length);
          },
        );
      },
    );
  }
}
