abstract class AuthEvent {}

class AuthRequested extends AuthEvent {
  final String email;
  final String password;

  AuthRequested({required this.email, required this.password});
}

class AuthSignOutRequested extends AuthEvent {}


class AuthGetUser extends AuthEvent{}

class AuthRegistrationRequested extends AuthEvent{
  final String email;
  final String password;

  AuthRegistrationRequested({required this.email, required this.password});

}


class AuthGoogleRequested extends AuthEvent{}

class AuthCheckRequested extends AuthEvent{}