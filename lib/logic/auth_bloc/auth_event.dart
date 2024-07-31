part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignInRequest extends AuthEvent {
  final String email;
  final String password;

  SignInRequest({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SignUpRequest extends AuthEvent {
  final String email;
  final String password;
  final String fullname;
  final File? photo;

  SignUpRequest({required this.email, required this.password, required this.fullname, this.photo});

  @override
  List<Object?> get props => [email, password, fullname, photo];
}

class SignOutRequest extends AuthEvent {}

class AuthAuthenticate extends AuthEvent {
  final String uid;

  AuthAuthenticate({required this.uid});

  @override
  List<Object?> get props => [uid];
}

class AuthUnauthenticate extends AuthEvent {}