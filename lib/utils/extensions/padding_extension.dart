part of 'extension.dart';

extension PaddingExt on Widget {
  Padding paddingSymmetric({double vertical = 0.0, double horizontal = 0.0, Key? key}) =>
      Padding(
          key: key,
          padding: EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
          child: this);

  Padding paddingLTRB({double top = 0.0, double  bottom =0.0,double left =0.0,double right =0.0 ,Key? key}) =>
      Padding(
          key: key,
          padding: EdgeInsets.fromLTRB(left, top, right, bottom),
          child: this);



}
