import 'dart:async';
import 'dart:io';

import 'package:file_management/services/bloc/auth/auth_event.dart';
import 'package:file_management/services/bloc/auth/auth_state.dart';
import 'package:file_management/services/storage/firebase_firestore.dart';
import 'package:file_management/utils/constants/app_keys.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth;
  final CloudStorage _storage = CloudStorage();

  AuthBloc(this._firebaseAuth) : super(AuthInitial()) {
    on<AuthRequested>(_onAuthRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthRegistrationRequested>(_onAuthRegistrationRequested);
    on<AuthGoogleRequested>(_onGoogleRegistrationRequested);
    on<AuthCheckRequested>(_onCheckRequested); // Listen for the check event

    // Trigger an initial check
    add(AuthCheckRequested());
  }

  final GoogleSignIn _googleSignIn = kIsWeb ?  GoogleSignIn(
    clientId: '241495568904-50s338q32g82iqbsjh9nud70ovffd8qp.apps.googleusercontent.com.apps.googleusercontent.com',
  ) : GoogleSignIn();

  Future<void> _onAuthRequested(
      AuthRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoadInProgress());
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(AuthLoadSuccess(userCredential.user!));
    } catch (e) {
      emit(AuthLoadFailure(e.toString()));
    }
  }

  Future<void> _onAuthRegistrationRequested(
      AuthRegistrationRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoadInProgress());
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      Map<String,dynamic> userData = {
        "email":event.email,
        AppKeys.storage : "",
      };
      _storage.assignUser(userData,userCredential.user!.uid);
      emit(AuthLoadSuccess(userCredential.user!));
    } catch (e) {
      emit(AuthLoadFailure(e.toString()));
    }
  }

  Future<void> _onGoogleRegistrationRequested(
      AuthGoogleRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoadInProgress());
    try {
      GoogleSignInAccount? googleSignInAccount;

      if (isMobilePlatform()) {
        googleSignInAccount = await _googleSignIn.signIn();
      } else {
        googleSignInAccount = await _googleSignIn.signInSilently();
      }

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleSignInAccount.authentication;
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        Map<String,dynamic> userData = {
          "email":userCredential.user!.email,
          AppKeys.storage : "",
        };
        _storage.assignUser(userData,userCredential.user!.uid);
        emit(AuthLoadSuccess(userCredential.user!));
      }
    } catch (e) {
      emit(AuthLoadFailure(e.toString()));
    }
  }

  bool isMobilePlatform() {
    return Platform.isAndroid || Platform.isIOS;
  }

  Future<void> _onCheckRequested(
      AuthCheckRequested event, Emitter<AuthState> emit) async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      emit(AuthLoadSuccess(currentUser));
    } else {
      emit(AuthSignedOut());
    }
  }

  Future<void> _onSignOutRequested(
      AuthSignOutRequested event, Emitter<AuthState> emit) async {
    await _firebaseAuth
        .signOut()
        .whenComplete(() => emit(AuthSignedOut()))
        .onError((error, stackTrace) => debugPrint(error.toString()));
  }
}
