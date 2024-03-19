import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_management/business_logic/sign_up_sign_in/sign_up_sign_in_cubit.dart';
import 'package:file_management/business_logic/upload_files/upload_files_cubit.dart';
import 'package:file_management/business_logic/uploaded_files/uploaded_files_cubit.dart';
import 'package:file_management/pages/file_upload_and_display/file_upload_and_display_screen.dart';
import 'package:file_management/pages/sign_up_sign_in_screen.dart';
import 'package:file_management/pages/file_upload_and_display/pages/upload_files_screen.dart';
import 'package:file_management/services/bloc/auth/auth_bloc.dart';
import 'package:file_management/services/bloc/auth/auth_state.dart';
import 'package:file_management/services/bloc/network/network_bloc.dart';
import 'package:file_management/services/bloc/network/network_state.dart';
import 'package:file_management/services/routes/routes.dart';
import 'package:file_management/utils/styles/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBP8YrxCl2ivZPslJUhWL34NdAlYGp3QZY",
          authDomain: "file-management-7b390.firebaseapp.com",
          projectId: "file-management-7b390",
          storageBucket: "file-management-7b390.appspot.com",
          messagingSenderId: "19178217149",
          appId: "1:19178217149:web:6cf14688ea3df6455aa1d4",
          measurementId: "G-Q9F31V6WNQ"
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  // await FirebaseAppCheck.instance.activate(
  //   // You can also use a `ReCaptchaEnterpriseProvider` provider instance as an
  //   // argument for `webProvider`
  //   webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
  //   // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
  //   // your preferred provider. Choose from:
  //   // 1. Debug provider
  //   // 2. Safety Net provider
  //   // 3. Play Integrity provider
  //   androidProvider: AndroidProvider.debug,
  //   // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
  //   // your preferred provider. Choose from:
  //   // 1. Debug provider
  //   // 2. Device Check provider
  //   // 3. App Attest provider
  //   // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
  //   appleProvider: AppleProvider.appAttest,
  // );
  Connectivity connectivity = Connectivity();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(FirebaseAuth.instance)),
        BlocProvider(create: (context) => NetworkBloc(connectivity)),
        BlocProvider( create: (context) => UploadFilesCubit(),),
        BlocProvider( create: (context) => UploadedFilesCubit(),),
      ],
      child: ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return const MyApp();
          }),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'File Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      onGenerateRoute: Routes.generateRoutes,
      home: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
        if (state is AuthLoadSuccess) {
          return BlocBuilder<NetworkBloc, NetworkState>(
            builder: (context, state) {
              if (state is NetworkOffline) {
                return const Scaffold(body: Center(child:Text("No Internet Connection, non authenticated")));
              } else if (state is NetworkOnline) {
                return const FileUploadAndDisplayScreen();
              } else {
            return  kIsWeb
                ?   const FileUploadAndDisplayScreen()
                : const CircularProgressIndicator();
              }
            },
          );
        }
        else {
          return BlocBuilder<NetworkBloc, NetworkState>(
            builder: (context, state) {
              if (state is NetworkOffline) {
                return const Scaffold(body: Center(child: Text("No Internet Connection, non authenticated")));
              } else if (state is NetworkOnline) {
                return BlocProvider(
                    create: (context) => SignUpSignInCubit(),
                    child: const SignUpSignInScreen(isSignUp: false));
              } else {
                return  kIsWeb
                ? BlocProvider(
                    create: (context) => SignUpSignInCubit(),
                    child: const SignUpSignInScreen(isSignUp: false))
                    : const CircularProgressIndicator();
              }
            },
          );
        }
      }),
    );
  }
}
