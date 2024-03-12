import 'package:file_management/business_logic/sign_up_sign_in/sign_up_sign_in_cubit.dart';
import 'package:file_management/business_logic/sign_up_sign_in/sign_up_sign_in_state.dart';
import 'package:file_management/utils/constants/string_constants.dart';
import 'package:file_management/utils/extensions/extension.dart';
import 'package:file_management/utils/styles/app_colors.dart';
import 'package:file_management/utils/styles/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUpSignInScreen extends StatelessWidget {
  const SignUpSignInScreen({super.key, required this.isSignUp});

  final bool isSignUp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Form(
                key: context.read<SignUpSignInCubit>().formKey,
                child: Column(
          children: [
            0.15.sh.heightSizedBox,
            Text(
              StringConstants.loginToDashBoardAccount,
              style: AppTextStyle.titleTextStyle,
            ),
            0.05.sh.heightSizedBox,
            tabs(),
            field(true, context),
            field(false, context),
            button(),
            0.03.sh.heightSizedBox,
            Row(
              children: [
                const Text(StringConstants.orRegisterWith),
                textButtons(StringConstants.facebook,context),
                textButtons(StringConstants.google,context),
                textButtons(StringConstants.linkedIn,context),
              ],
            )
          ],
                ).paddingSymmetric(horizontal: MediaQuery.of(context).size.width / 12),
              ),
        ));
  }

  Widget tabs() {
    return BlocBuilder<SignUpSignInCubit, SignUpSignInState>(
      builder: (context, state) {
        return Row(
          children: [
            tabButton(context, 0, state.tabValue),
            const SizedBox(width: 20),
            tabButton(context, 1, state.tabValue),
          ],
        );
      },
    );
  }

  Widget tabButton(BuildContext context, int n, int tabValue) {
    Color color = n == tabValue ? AppColors.black : AppColors.grey;
    return GestureDetector(
        onTap: () => context.read<SignUpSignInCubit>().tabValueUpdate(n),
        child: Column(
          children: [
            Text(n == 0 ? StringConstants.login : StringConstants.register,
                style: AppTextStyle.subtitleTextStyle.copyWith(
                  fontWeight: n == tabValue ? FontWeight.bold : FontWeight.w400,
                  color: color,
                )),
            n == tabValue
                ? Container(
                    width: n == 0 ? 40 : 60,
                    height: 2.0, // Thickness of the underline
                    color: AppColors.black, // Color of the underline
                  )
                : const SizedBox(),
          ],
        ));
  }

  Widget button() {
    return BlocBuilder<SignUpSignInCubit, SignUpSignInState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => context
                  .read<SignUpSignInCubit>()
                  .onPressLoginRegister(isSignUp, context),
              child: Container(
                width: 0.3.sw,
                padding: const EdgeInsets.symmetric(vertical: 10),
                color: AppColors.yellow,
                child: Center(
                  child: Text(
                    state.tabValue == 0
                        ? StringConstants.login
                        : StringConstants.register,
                    style: AppTextStyle.subtitleTextStyle
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            state.tabValue == 0
                ? Text(
                    StringConstants.forgotYourPassword,
                    style: AppTextStyle.subtitleTextStyle,
                  )
                : const SizedBox.shrink(),
          ],
        );
      },
    );
  }

  Widget textButtons(String txt,BuildContext context) {
    return GestureDetector(
      onTap: ()=>txt == StringConstants.google ? context.read<SignUpSignInCubit>().onPressGoogle(context) : context.read<SignUpSignInCubit>().onUnBuiltFunctions(context),
      child: Text(
        txt,
        style: AppTextStyle.subtitleTextStyle,
      ),
    ).paddingSymmetric(horizontal: 0.015.sw);
  }

  Widget field(bool isEmail, BuildContext context) {
    return TextFormField(
      validator: (_) => isEmail
          ? context.read<SignUpSignInCubit>().emailValidator()
          : context.read<SignUpSignInCubit>().passwordValidator(),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: isEmail
          ? context.read<SignUpSignInCubit>().emailController
          : context.read<SignUpSignInCubit>().passwordController,
      obscureText:!isEmail,
      decoration: InputDecoration(
        hintText: isEmail ? StringConstants.email : StringConstants.password,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ).paddingSymmetric(vertical: 0.02.sh);
  }
}
