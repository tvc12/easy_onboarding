part of easy_onboarding;

class _TopToBottomOnBoardingBuilder extends BaseOnBoardingWidgetBuilder {
  _TopToBottomOnBoardingBuilder({
    @required EasyOnBoardingData onBoardingData,
    @required Widget child,
    @required Widget arrowWidget,
    @required Widget descriptionWidget,
    @required Offset position,
    Key key,
  }) : super(onBoardingData, child, arrowWidget, descriptionWidget, position, key: key);

  @override
  Widget build(BuildContext context) {
    final Widget widget = _setLayoutFromTopToBottom(child, arrowWidget, descriptionWidget);
    return _positionWidgetFromTopToBottom(context, widget, position);
  }

  Widget _setLayoutFromTopToBottom(
    Widget widgetOnBoarding,
    Widget arrowWidget,
    Widget descriptionWidget,
  ) {
    final Widget child = _setDefaultSize(widgetOnBoarding);
    return _onBoardingColumn(
      children: <Widget>[
        _onBoardingColumn(children: <Widget>[child, arrowWidget]),
        descriptionWidget,
      ],
    );
  }

  Widget _positionWidgetFromTopToBottom(
    BuildContext context,
    Widget child,
    Offset position,
  ) {
    final bool isLeft = onBoardingData.crossAxisAlignment == CrossAxisAlignment.start;
    final double left = isLeft ? position.dx : null;
    final double right = isLeft ? null : _getPaddingRight(context, position.dx);

    return Positioned(
      top: position.dy,
      left: left,
      right: right,
      child: child,
    );
  }
}
