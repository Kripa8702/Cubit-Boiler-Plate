part of 'auth_cubit.dart';

enum AuthStatus { unknown, loading, success, failure }

class AuthState extends Equatable {
  const AuthState({
    this.authenticationStatus = AuthStatus.unknown,
    this.loginStatus = AuthStatus.unknown,
    this.signUpStatus = AuthStatus.unknown,
    this.emailForConfirmation,
    this.user,
    this.message,
  });

  final AuthStatus authenticationStatus;
  final AuthStatus loginStatus;
  final AuthStatus signUpStatus;

  final String? emailForConfirmation;
  final User? user;
  final String? message;

  @override
  List<Object> get props => [
        authenticationStatus,
        loginStatus,
        signUpStatus,
      ];

  AuthState copyWith({
    AuthStatus? authenticationStatus,
    AuthStatus? loginStatus,
    AuthStatus? signUpStatus,
    String? emailForConfirmation,
    User? user,
    String? message,
  }) {
    return AuthState(
      authenticationStatus: authenticationStatus ?? this.authenticationStatus,
      loginStatus: loginStatus ?? this.loginStatus,
      signUpStatus: signUpStatus ?? this.signUpStatus,
      emailForConfirmation: emailForConfirmation ?? this.emailForConfirmation,
      user: user ?? this.user,
      message: message ?? this.message,
    );
  }
}
