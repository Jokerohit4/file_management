import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoadInProgress extends AuthState {}

class AuthLoadSuccess extends AuthState {
  final User user;

  AuthLoadSuccess( this.user);
}

class AuthLoadFailure extends AuthState {

  final String message;

  AuthLoadFailure( this.message);
}

class AuthSignedOut extends AuthState {}
