part of 'splash_cubit.dart';

enum SplashStatus { loading, updateRequired, updateNotRequired}

class SplashState extends Equatable {
  const SplashState({
    this.status = SplashStatus.loading,
    this.privacyPolicyUrl = "https://www.google.com",
    this.termsAndConditionsUrl = "https://www.google.com",
  });

  final SplashStatus status;
  final String privacyPolicyUrl;
  final String termsAndConditionsUrl;

  SplashState copyWith({
    SplashStatus? status,
    String? privacyPolicyUrl,
    String? termsAndConditionsUrl,
  }) {
    return SplashState(
      status: status ?? this.status,
      privacyPolicyUrl: privacyPolicyUrl ?? this.privacyPolicyUrl,
      termsAndConditionsUrl: termsAndConditionsUrl ?? this.termsAndConditionsUrl,
    );
  }

  @override
  List<Object> get props => [status, privacyPolicyUrl, termsAndConditionsUrl];
}