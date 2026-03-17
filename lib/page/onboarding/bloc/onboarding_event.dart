part of "onboarding_bloc.dart";

abstract class OnboardingEvent extends Equatable{
  @override
  List<Object> get props => [];
}
class CompanyListEvent extends OnboardingEvent {
  final String searchText;
  CompanyListEvent({required this.searchText});
  @override
  List<Object> get props => [searchText];
}

class OnSelectedCompanyEvent extends OnboardingEvent {
  final Company selectedCompany;
  OnSelectedCompanyEvent({required this.selectedCompany});
  @override
  List<Object> get props => [selectedCompany];
}
