import 'package:file_management/business_logic/sign_up_sign_in/sign_up_sign_in_state.dart';
import 'package:file_management/services/bloc/auth/auth_bloc.dart';
import 'package:file_management/services/bloc/auth/auth_event.dart';
import 'package:file_management/services/bloc/auth/auth_state.dart';
import 'package:file_management/utils/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpSignInCubit extends Cubit<SignUpSignInState> {
  SignUpSignInCubit() : super(SignUpSignInState(tabValue: 0));

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLogin = true;

  get emailController => _emailController;

  get passwordController => _passwordController;

  get formKey => _formKey;

  void tabValueUpdate(int value) {
    if (value == 1) {
      isLogin = false;
      emit(SignUpSignInState(tabValue: 1));
    } else {
      isLogin = true;
      emit(SignUpSignInState(tabValue: 0));
    }
  }

  void onPressGoogle(BuildContext context){
    BlocProvider.of<AuthBloc>(context).add(
            AuthGoogleRequested(),
          );
  }

  void onUnBuiltFunctions(BuildContext context){
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: AppColors.black, content: Text('We are still working on it')));
  }



  void onPressLoginRegister(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      isLogin ? _onPressLogin(context) : _onPressRegister(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: AppColors.white,
        content: Text('Please check your inputs.', style: TextStyle(color: AppColors.red)),
      ));
    }
  }

  void _onPressLogin(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(
      AuthRequested(
          email: _emailController.text, password: _passwordController.text),
    );
  }


  void _onPressRegister(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(
      AuthRegistrationRequested(
          email: _emailController.text, password: _passwordController.text),
    );
  }

  String? emailValidator() {
    final emailRegex = RegExp(
      r"^[a-zA-Z\d._%+-]+@[a-zA-Z\d.-]+\.[a-zA-Z]{2,4}$",
    );

    if (_emailController.text.isEmpty) {
      return 'Email cannot be empty';
    } else if (!emailRegex.hasMatch(_emailController.text)) {
      return 'Enter a valid email address';
    } else {
      return null; // The email is valid
    }
  }

  String? passwordValidator() {
    if (_passwordController.text.isEmpty) {
      return 'Password cannot be empty';
    } else if (_passwordController.text.length < 8) {
      return 'Password must be at least 8 characters long';
    } else if (!RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$")
        .hasMatch(_passwordController.text)) {
      return 'Password must contain a letter and a number';
    } else {
      return null; // The password is valid
    }
  }
}
