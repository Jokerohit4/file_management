import 'package:file_management/business_logic/sign_up_sign_in/sign_up_sign_in_cubit.dart';
import 'package:file_management/business_logic/upload_files/upload_files_cubit.dart';
import 'package:file_management/pages/sign_up_sign_in_screen.dart';
import 'package:file_management/pages/file_upload_and_display/pages/upload_files_screen.dart';
import 'package:file_management/services/routes/route_arguments.dart';
import 'package:file_management/services/routes/route_transistions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///guides the routes and allows named routing
class Routes {
  // static const String settingsViewRoute = "/settingsViewRoute";
  static const String uploadFilesScreenRoute = "/uploadFilesScreenRoute";
  static const String signInSignUpRoute = "/signInSignUpRoute";

  static Route<dynamic>? generateRoutes(RouteSettings? settings) {
    switch (settings!.name) {

      case uploadFilesScreenRoute:
        return FadeRoute(
            page: BlocProvider(
                create: (context) => UploadFilesCubit(),
                child: const UploadFileScreen()));

      case signInSignUpRoute:
        var args = settings.arguments as SignUpSignInRouteArguments;
        return FadeRoute(
            page: BlocProvider(
                create: (context) => SignUpSignInCubit(),
                child: SignUpSignInScreen(isSignUp: args.isSignUp)));

      default:
        return FadeRoute(
          page: const Scaffold(
            body: Center(
              child: Text(
                'No route defined',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        );
    }
  }
}
