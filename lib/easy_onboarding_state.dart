part of easy_onboarding;

class EasyOnBoardingState extends BaseEasyOnBoardingState {
  EasyOnBoardingBuilder get builder => widget.builder;

  EasyOnBoardingDirection get direction => widget.direction;

  @override
  Widget buildOnBoardingLayer(BuildContext context, GlobalKey currentKey) {
    final Widget child = _getOnBoardingWidget(currentKey);
    final Offset point = getPosition(currentKey) ?? Offset.zero;
    final Widget arrowWidget = buildArrow();
    final Widget toolTipWidget = buildDescription(widget.description);
    return child != null
        ? builder(context, child, arrowWidget, toolTipWidget, point)
        : SizedBox();
  }

  Widget buildArrow() {
    return Container(
      width: 40,
      height: 40,
      child: Icon(Icons.arrow_drop_down),
    );
  }

  Widget _getOnBoardingWidget(GlobalKey currentKey) {
    final EasyOnBoardingObject child = currentKey.currentWidget;
    assert(
      child is EasyOnBoardingObject,
      'Widget with global key must extend from EasyOnboardingObject',
    );

    final Widget newWidget = child.cloneWithoutGlobalKey();
    assert(newWidget is Widget, 'cloneWithoutGlobalKey must return a widget');
    assert(
      child.key != newWidget.key,
      'cloneWithoutGlobalKey return a widget have a key same parent (this)',
    );

    return newWidget;
  }

  Widget buildDescription(String description) {
    description ??= '';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.red[400],
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 290),
        child: Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(
            height: 1.4,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _defaultLayout(
    Widget widgetOnBoarding,
    Widget arrowWidget,
    Widget descriptionWidget,
    Offset position,
  ) {
    final bool isTopToBottom = direction == EasyOnBoardingDirection.TopToBottom;
    final EasyOnBoardingBuilder builder =
        isTopToBottom ? _topToBottomBuilder : _bottomToTopBuilder;

    return widgetOnBoarding;
  }

  Widget _bottomToTopBuilder(
    Widget child,
    Widget arrowWidget,
    Widget tooltipWiget,
    Offset position,
  ) {
    final bool isLeft = widget.crossAxisAlignment == CrossAxisAlignment.start;
    final double left = isLeft ? position.dx : null;
    final double right = isLeft ? null : _getRight(position.dx);
    Log.debug('_positionWidgetBottomToTop: RIGHT: $right, LEFT: $left');
    final double bottom = _getBottom(position.dy);
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
      child: _defaultColumn([
        tooltipWiget,
        _rotateWidget(arrowWidget),
      ]),
    );
    return Stack(
      children: <Widget>[
        child,
        newChild,
      ],
    );
  }

  Widget _setDefaultSize(Widget child) {
    return child is EasyOnBoardingObject
        ? SizedBox.fromSize(child: child, size: getSize(widget.currentKey))
        : child;
  }

  Size getSize(GlobalKey<State<StatefulWidget>> currentKey) {
    try {
      final RenderBox findRenderObject =
          currentKey.currentContext.findRenderObject();

      return findRenderObject.size;
    } catch (ex) {
      return Size.zero;
    }
  }

  Offset getPosition(GlobalKey<State<StatefulWidget>> currentKey) {
    try {
      final RenderBox findRenderObject =
          currentKey.currentContext.findRenderObject();

      return findRenderObject.localToGlobal(Offset.zero);
    } catch (ex) {
      debugPrint('Error $runtimeType.getPosition $ex');
      return null;
    }
  }
}

abstract class BaseOnBoardingWidgetBuilder extends StatelessWidget {
  final Widget child;
  final Widget arrowWidget;
  final Widget descriptionWidget;
  final Offset offset;

  const BaseOnBoardingWidgetBuilder(
    this.child,
    this.arrowWidget,
    this.descriptionWidget,
    this.offset, {
    Key key,
  }) : super(key: key);

  Widget _defaultColumn(List<Widget> children) {
    return Flex(
      direction: Axis.vertical,
//      mainAxisAlignment: widget.mainAxisAlignment,
//      crossAxisAlignment: widget.crossAxisAlignment,
      mainAxisSize: MainAxisSize.max,
      children: children,
    );
  }
}

class BottomToTopOnBoardingBuilder extends BaseOnBoardingWidgetBuilder {
  BottomToTopOnBoardingBuilder({
    @required Widget child,
    @required Widget arrowWidget,
    @required Widget descriptionWidget,
    @required Offset offset,
    Key key,
  }) : super(child, arrowWidget, descriptionWidget, offset, key: key);

  @override
  Widget build(BuildContext context) {
    final Widget widget =
        _layoutTopToBottom(child, arrowWidget, descriptionWidget);
    return _positionWidgetTopToBottom(child, offset);
  }

  Widget _layoutTopToBottom(
    Widget widgetOnBoarding,
    Widget arrowWidget,
    Widget descriptionWidget,
  ) {
    final Widget child = _setDefaultSize(widgetOnBoarding);
    return _defaultColumn(
      <Widget>[
        _defaultColumn(<Widget>[child, arrowWidget]),
        descriptionWidget,
      ],
    );
  }

  Widget _positionWidgetTopToBottom(
    Widget child,
    Offset position,
  ) {
    final bool isLeft = widget.crossAxisAlignment == CrossAxisAlignment.start;
    final double left = isLeft ? position.dx : null;
    final double right = isLeft ? null : _getRight(position.dx);

    return Positioned(
      top: position.dy,
      left: left,
      right: right,
      child: child,
    );
  }
}
