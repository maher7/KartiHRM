import 'dart:async';
import 'package:collection/collection.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta_club_api/meta_club_api.dart';

part 'onboarding_event.dart';

part 'onboarding_state.dart';

typedef OnboardingBlocFactory = OnboardingBloc Function();

class OnboardingBloc extends HydratedBloc<OnboardingEvent, OnboardingState> {
  final MetaClubApiClient _metaClubApiClient;
  final Branding branding;
  final BrandingColorProvider brandingColorProvider;

  OnboardingBloc(
      {required MetaClubApiClient metaClubApiClient, required this.branding, required this.brandingColorProvider})
      : _metaClubApiClient = metaClubApiClient,
        super(const OnboardingState()) {
    ///Initialize BrandingColorProvider
    branding.startUp(colorProvider: brandingColorProvider, colors: state.selectedCompany?.colors);

    ///will be react based on event
    on<CompanyListEvent>(_onCompanyLoaded);
    on<OnSelectedCompanyEvent>(_onSelectedCompany);
    // on<OnSearchCompanyEvent>(_onSearchCompany);

    ///trigger event
    add(CompanyListEvent(searchText: ''));
  }

  FutureOr<void> _onSelectedCompany(OnSelectedCompanyEvent event, Emitter<OnboardingState> emit) async {
    final company = event.selectedCompany;
    globalState.set(companyName, company.companyName);
    globalState.set(companyId, company.id);
    globalState.set(companyUrl, company.url);
    globalState.set(companySubDomain, company.subdomain);
    branding.setBrand(company.colors);
    emit(state.copyWith(selectedCompany: company));
  }

  FutureOr<void> _onCompanyLoaded(CompanyListEvent event, Emitter<OnboardingState> emit) async {
    emit(state.copyWith(status: NetworkStatus.loading));

    final companyModel = await _metaClubApiClient.getCompanyList(search: event.searchText);

    companyModel.fold((l) {
      emit(state.copyWith(status: NetworkStatus.failure));
    }, (r) {
      List<Company> companies = r?.companyList ?? [];

      Company? selected;

      // ✅ Auto-select if only one company
      if (companies.length == 1) {
        selected = companies.first;
        globalState.set(companyName, selected.companyName);
        globalState.set(companyId, selected.id);
        globalState.set(companyUrl, selected.url);
        globalState.set(companySubDomain, selected.subdomain);
        branding.setBrand(selected.colors);
      } else {
        // keep previous selection if still exists
        selected = companies.firstWhereOrNull((c) => c.id == state.selectedCompany?.id);
      }

      emit(state.copyWith(
        status: NetworkStatus.success,
        companyListModel: r,
        selectedCompany: selected,
        theme: getTheme(),
      ));
    });
  }


  ThemeData getTheme() {
    TextTheme? textTheme;
    try {
      textTheme = GoogleFonts.getTextTheme(state.selectedCompany?.fontFamily ?? 'Poppins');
    } catch (_) {
      textTheme = GoogleFonts.getTextTheme('Poppins');
    }

    return ThemeData(
        primaryColor: Branding.colors.primaryLight,
        primaryColorLight: Branding.colors.primaryLight,
        primaryColorDark: Branding.colors.primaryDark,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Branding.colors.primaryLight),
        textTheme: textTheme,
        appBarTheme: AppBarTheme(
            backgroundColor: Branding.colors.primaryLight,
            iconTheme: IconThemeData(color: Branding.colors.textInversePrimary),
            titleTextStyle: TextStyle(color: Branding.colors.textInversePrimary, fontSize: 18.r)));
  }

  @override
  OnboardingState? fromJson(Map<String, dynamic> json) {
    return OnboardingState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(OnboardingState state) {
    return state.toJson();
  }
}
