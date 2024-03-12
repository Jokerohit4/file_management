part of 'extension.dart';

extension WidgetExtension on double {
  Widget get widthSizedBox => SizedBox(width: this);

  Widget get heightSizedBox => SizedBox(height: this);

  Widget get expandedWidthSizedBox => Expanded(child: SizedBox(width: this));

  Widget get expandedHeightSizedBox => Expanded(child: SizedBox(height: this,));
}

extension SizeBoxExtension on int {
  Widget get widthSizedBox => SizedBox(width: toDouble());

  Widget get heightSizedBox => SizedBox(height: toDouble());

  Widget get expandedWidthSizedBox => Expanded(child: SizedBox(width: toDouble()));

  Widget get expandedHeightSizedBox => Expanded(child: SizedBox(height: toDouble()));
}
