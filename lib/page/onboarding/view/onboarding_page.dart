import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/animation/bounce_animation/bounce_animation_builder.dart';
import 'package:onesthrm/page/leave/view/content/general_list_shimmer.dart';
import 'package:onesthrm/page/login/view/login_page.dart';
import 'package:onesthrm/page/onboarding/bloc/onboarding_bloc.dart';
import 'package:core/core.dart';
import 'package:onesthrm/res/common/debouncer.dart';
import 'package:onesthrm/res/nav_utail.dart';
import 'package:onesthrm/res/widgets/custom_button.dart';

typedef OnboardingPageFactory = OnboardingPage Function();

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  static Route route() {
    final onBoarding = instance<OnboardingPageFactory>();
    return MaterialPageRoute(builder: (_) => onBoarding());
  }

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  bool _hasRedirected = false;
  @override
  Widget build(BuildContext context) {
    final deBouncer = Debounce(milliseconds: 1000);
    return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: Visibility(
          visible: isSAAS == false ? false : true,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(0)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocBuilder<OnboardingBloc, OnboardingState>(
                builder: (context, state) {
                  return CustomHButton(
                    title: "next".tr(),
                    padding: 16,
                    clickButton: () {
                      if(state.selectedCompany != null){
                        NavUtil.pushAndRemoveUntil(context,  LoginPage(selectedCompany: state.selectedCompany));
                      }else {
                        Fluttertoast.showToast(msg: "please_select_company".tr());
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ),
        body: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, state) {
             if (isSAAS == true && state.companyListModel?.companyList?.length == 1 && !_hasRedirected) {
              _hasRedirected = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                NavUtil.pushAndRemoveUntil(context, LoginPage(selectedCompany: state.selectedCompany));
              });
            } else if (isSAAS == false && !_hasRedirected && state.companyListModel?.companyList?.length == 1 && state.selectedCompany != null) {
              _hasRedirected = true;

              /// Wait until the frame is rendered before navigating
              WidgetsBinding.instance.addPostFrameCallback((_) {
                NavUtil.pushAndRemoveUntil(context, LoginPage(selectedCompany: state.selectedCompany));
              });
            }
            return isSAAS == false ? Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    BounceAnimationBuilder(
                      builder: (_, __) {
                        return Center(
                          child: InteractiveViewer(
                            scaleEnabled: false,
                            boundaryMargin: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Image.asset("assets/images/karti_transparent.png", scale: 3),
                          ),
                        );
                      },
                    )
                  ],
                )) :  Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 66),
                    Center(
                        child:
                            Image.asset('assets/images/company_logo.png', fit: BoxFit.cover, height: 130, width: 130)),
                    Center(
                        child: Text("login_your_account".tr(),
                            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold))),
                    SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text("enter_company_id_name".tr(),
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal, color: Colors.black38)),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
                      child: TextFormField(
                        onChanged: (value) {
                          deBouncer.run(() => context.read<OnboardingBloc>().add(CompanyListEvent(searchText: value.toString())));
                        },
                        style: TextStyle(fontSize: 12.r),
                        decoration: InputDecoration(
                          hintText: "EX : 254163",
                          hintStyle: TextStyle(fontSize: 12.r, color: Colors.black54),
                          fillColor: Colors.white,
                          filled: true,
                          border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12.0)),
                              borderSide: BorderSide(color: Colors.grey)),
                          suffixIcon: IconButton(
                            icon: Icon(CupertinoIcons.search, color: Colors.black54),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: state.status == NetworkStatus.loading
                          ? const GeneralListShimmer()
                          : (state.companyListModel?.companyList?.isEmpty ?? true)
                          ? Center(
                        child: NoDataFoundWidget(title: "no_company_found".tr(),)
                      )
                          : ListView.builder(
                        itemCount: state.companyListModel?.companyList?.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          Company? company = state.companyListModel?.companyList?[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(color: colorPrimary)),
                            child: RadioListTile<Company?>(
                                title: Text(company?.companyName ?? '',
                                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold,color: colorPrimary)),
                                value: company,
                                groupValue: state.selectedCompany,
                                onChanged: (Company? value) {
                                  context
                                      .read<OnboardingBloc>()
                                      .add(OnSelectedCompanyEvent(selectedCompany: value!));
                                }),
                          );
                        },
                      ),
                    ),

                  ],
                ),
              ],
            );
          },
        ));
  }
}
