import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../bottom_navigation/view/bottom_navigation_page.dart';

class AppPermissionPage extends StatefulWidget {
  const AppPermissionPage({super.key});

  @override
  State<AppPermissionPage> createState() => _AppPermissionPageState();

  static Route route(){
    return MaterialPageRoute(builder: (_) => const AppPermissionPage());
  }

}

class _AppPermissionPageState extends State<AppPermissionPage> {

  @override
  void initState() {
    SharedUtil.setBoolValue(isDisclosure, true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Branding.colors.primaryLight, Branding.colors.primaryDark],
        )),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24.0),
              const Icon(Icons.location_on_rounded, color: Colors.white, size: 48.0),
              const SizedBox(height: 16.0),
              Text('location_disclosure_title'.tr(),
                style: const TextStyle(fontSize: 22.0, color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              Text('location_disclosure_subtitle'.tr(),
                style: TextStyle(fontSize: 14.0, color: Colors.white.withValues(alpha: 0.8))),
              const SizedBox(height: 32.0),
              Expanded(
                child: ListView(
                  children: [
                    _buildFeatureItem(
                      icon: Icons.my_location_rounded,
                      text: 'location_feature_attendance'.tr(),
                    ),
                    const SizedBox(height: 16.0),
                    _buildFeatureItem(
                      icon: Icons.social_distance_rounded,
                      text: 'location_feature_distance'.tr(),
                    ),
                    const SizedBox(height: 16.0),
                    _buildFeatureItem(
                      icon: Icons.route_rounded,
                      text: 'location_feature_tracking'.tr(),
                    ),
                    const SizedBox(height: 16.0),
                    _buildFeatureItem(
                      icon: Icons.speed_rounded,
                      text: 'location_feature_efficiency'.tr(),
                    ),
                    const SizedBox(height: 24.0),
                    Row(
                      children: [
                        Icon(Icons.info_outline_rounded, color: Colors.white.withValues(alpha: 0.7), size: 18.0),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Text('location_change_later'.tr(),
                            style: TextStyle(fontSize: 13.0, color: Colors.white.withValues(alpha: 0.7))),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final navigator = instance<GlobalKey<NavigatorState>>().currentState!;
                    navigator.pushAndRemoveUntil(BottomNavigationPage.route(), (route) => false);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                    elevation: 0,
                  ),
                  child: Text(tr("next"),
                      style: TextStyle(color: Branding.colors.primaryLight, fontWeight: FontWeight.bold, fontSize: 16.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(icon, color: Colors.white, size: 24.0),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Text(text,
              style: const TextStyle(fontSize: 14.0, color: Colors.white, height: 1.4)),
          ),
        ],
      ),
    );
  }
}
