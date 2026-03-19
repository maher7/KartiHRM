import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:core/core.dart';


class NoDataFoundWidget extends StatelessWidget {
  final String title;
  final String assetImage;

  const NoDataFoundWidget({super.key, this.title = 'no_data_found', this.assetImage = 'assets/images/no_data_found.json'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(assetImage, repeat: false, height: DeviceUtil.isTablet ? 280 : 150),
            const SizedBox(height: 12),
            Text(
              title.tr(),
              style: TextStyle(
                color: Colors.black38,
                fontSize: DeviceUtil.isTablet ? 20 : 15,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
