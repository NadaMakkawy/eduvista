part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

// Signup State
final class SignupState extends AuthState {}

final class SignupLoading extends SignupState {}

final class SignupSuccess extends SignupState {}

final class SignupFailed extends SignupState {}

// Login State
final class LoginState extends AuthState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {}

final class LoginFailed extends LoginState {
  final String error;

  LoginFailed(this.error);
}

// Logout State
final class LogOutState extends AuthState {}

final class LogOutLoading extends LoginState {}

final class LogOutSuccess extends LoginState {}

final class LogOutFailed extends LoginState {
  final String error;

  LogOutFailed(this.error);
}
