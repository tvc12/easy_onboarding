part of easy_onboarding;

class _BottomToTopOnBoardingBuilder extends BaseOnBoardingWidgetBuilder {
  _BottomToTopOnBoardingBuilder({
    @required EasyOnBoardingData onBoardingData,
    @required Widget child,
    @required Widget arrowWidget,
    @required Widget descriptionWidget,
    @required Offset position,
  }) : super(onBoardingData, child, arrowWidget, descriptionWidget, position);

  @override
  Widget build(BuildContext context) {
    return _bottomToTopBuilder(context, child, arrowWidget, descriptionWidget, position);
  }

  Widget _bottomToTopBuilder(
    BuildContext context,
    Widget child,
    Widget arrowWidget,
    Widget tooltipWidget,
    Offset position,
  ) {
    final bool isLeft = onBoardingData.crossAxisAlignment == CrossAxisAlignment.start;
    final double left = isLeft ? position.dx : null;
    final double right = isLeft ? null : _getPaddingRight(context, position.dx);
    final double bottom = _getPaddingBottom(context, position.dy);

    child = Positioned(
      top: position.dy,
      left: left,
      right: right,
      child: _setDefaultSize(child),
    );
    final Widget newChild = Positioned(
      bottom: bottom,
      left: left,
      right: right,
      child: _onBoardingColumn(
        children: <Widget>[
          tooltipWidget,
          _rotateWidget(arrowWidget),
        ],
      ),
    );
    return Stack(
      children: <Widget>[
        child,
        newChild,
      ],
    );
  }

  Widget _rotateWidget(Widget child, {int quarterTurns = 90}) {
    return RotatedBox(child: child, quarterTurns: quarterTurns);
  }

  double _getPaddingBottom(BuildContext context, double top) {
    try {
      double height = MediaQuery.of(context).size.height;
      return height - top;
    } catch (ex) {
      return 0;
    }
  }
}
