part of 'extension.dart';

extension ExtBuildContext on BuildContext {
  ThemeData get theme => Theme.of(this);

  double get height => MediaQuery.of(this).size.height;

  double get width => MediaQuery.of(this).size.width;

  /// performs a simple [Navigator.pop] action and returns given [result]
  void navigateBack({dynamic result}) => Navigator.pop(this, result);

  /// performs a simple [Navigator.push] action with given [route]
  Future<dynamic> navigateTo(String screen, Object? argument) async {
    return Navigator.of(this).pushNamed(
      screen,
      arguments: argument ?? {},
    );
  }

  void navigateNoPop(String screen, Object? arguments) {
    Navigator.of(this).pushNamedAndRemoveUntil(
      screen,
      (route) => false,
      arguments: arguments,
    );
  }

  void navigateBackAndNext(String screen, Object? argument) {
    navigateBack();
    navigateTo(screen, argument);
  }

  // void present(Widget screen) {
  //   Navigator.of(this).push(CupertinoPageRoute<Widget>(fullscreenDialog: true, builder: (_) => screen));
  // }

  /// performs a simple [Navigator.pushReplacement] action with given [route]
  void replaceWith(String screen, Object? argument) {
    Navigator.of(this).popUntil((route) => route.isFirst);
    Navigator.of(this).pushReplacementNamed(screen, arguments: argument ?? {});
  }

  void popUntilFirst() {
    Navigator.of(this).popUntil((route) => route.isFirst);
  }

  /// performs a [Navigator.pushReplacement] action with given [route] and will replace only current screen not whole flow
  void replaceOnly(Widget screen) {
    Navigator.of(this).pushReplacement(MaterialPageRoute<Widget>(builder: (_) {
      return screen;
    }));
  }

  /// performs a [Navigator.pushReplacement] action with given [route] and will replace only current screen not whole flow
  void replaceOnlyNamed(String screen, Object? argument) {
    Navigator.of(this).pushReplacementNamed(screen, arguments: argument);
  }
//
// void showError(String message, {Duration? duration, FlushbarStatusCallback? onStatusChanged}) {
//   HapticFeedback.heavyImpact();
//   Flushbar(
//     title: 'Error!',
//     message: message,
//     duration: duration ?? const Duration(seconds: 2),
//     // backgroundColor: AppColors.colorRed,
//     // titleColor: AppColors.colorWhite,
//     // messageColor: AppColors.colorWhite,
//     flushbarPosition: FlushbarPosition.TOP,
//     onStatusChanged: onStatusChanged,
//   ).show(this);
// }
//
// void showSuccess(String message, {Duration? duration, FlushbarStatusCallback? onStatusChanged}) {
//   HapticFeedback.heavyImpact();
//   Flushbar(
//     title: 'Success!',
//     message: message,
//     duration: duration ?? const Duration(seconds: 2),
//     backgroundColor: Colors.green,
//     // titleColor: AppColors.colorWhite,
//     // messageColor: AppColors.colorWhite,
//     flushbarPosition: FlushbarPosition.TOP,
//     onStatusChanged: onStatusChanged,
//   ).show(this);
// }
//
// void showInfo(String message, {Duration? duration, FlushbarStatusCallback? onStatusChanged}) {
//   HapticFeedback.heavyImpact();
//   Flushbar(
//     title: 'Information!',
//     message: message,
//     duration: duration ?? const Duration(seconds: 2),
//     // backgroundColor: AppColors.colorRed,
//     // titleColor: AppColors.colorWhite,
//     // messageColor: AppColors.colorWhite,
//     flushbarPosition: FlushbarPosition.TOP,
//     onStatusChanged: onStatusChanged,
//   ).show(this);
// }
}
