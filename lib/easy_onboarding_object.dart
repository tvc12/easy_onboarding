part of easy_onboarding;

abstract class EasyOnBoardingObject extends Widget {
  /// Clone object, remove global key because flutter don't allow two key same time
  Widget cloneWithoutGlobalKey();
}

enum EasyOnBoardingDirection {
  ///Component layout:
  ///
  /// **Description**
  ///
  ///     |
  ///
  /// **Arrow**
  ///
  ///     |
  ///
  /// **Widget**
  TopToBottom,

  ///Component layout:
  ///
  /// **Widget**
  ///
  ///     |
  ///
  /// **Arrow**
  ///
  ///     |
  ///
  /// **Description**
  BottomToTop,
}

typedef EasyOnBoardingBuilder = Widget Function(
  BuildContext context,
  Widget child,
  Widget arrowWidget,
  Widget toolTipWidget,
  Offset position,
);
