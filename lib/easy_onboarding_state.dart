part of easy_onboarding;

class EasyOnBoardingState extends BaseEasyOnBoardingState {
  @override
  Widget buildOnBoardingLayer(BuildContext context, GlobalKey currentKey) {
    final Widget child = _getOnBoardingWidget(currentKey);
    final Offset point = getPosition(currentKey) ?? Offset.zero;
    final Widget arrowWidget = buildArrow();
    final Widget toolTipWidget = buildDescription(description);
    return child != null ? builder(context, child, arrowWidget, toolTipWidget, point) : SizedBox();
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
    final BaseOnBoardingWidgetBuilder child = isTopToBottom
        ? TopToBottomOnBoardingBuilder(
            onBoardingData: widget.onBoardingData,
            child: widgetOnBoarding,
            arrowWidget: arrowWidget,
            descriptionWidget: descriptionWidget,
            position: position,
          )
        : BottomToTopOnBoardingBuilder(
            onBoardingData: widget.onBoardingData,
            child: widgetOnBoarding,
            arrowWidget: arrowWidget,
            descriptionWidget: descriptionWidget,
            position: position,
          );

    return child;
  }

  Offset getPosition(GlobalKey<State<StatefulWidget>> currentKey) {
    try {
      final RenderBox findRenderObject = currentKey.currentContext.findRenderObject();

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
  final Offset position;
  final EasyOnBoardingData onBoardingData;

  const BaseOnBoardingWidgetBuilder(
    this.onBoardingData,
    this.child,
    this.arrowWidget,
    this.descriptionWidget,
    this.position, {
    Key key,
  }) : super(key: key);

  Widget _onBoardingColumn({List<Widget> children = const <Widget>[]}) {
    return Flex(
      direction: Axis.vertical,
      mainAxisAlignment: onBoardingData.mainAxisAlignment,
      crossAxisAlignment: onBoardingData.crossAxisAlignment,
      mainAxisSize: MainAxisSize.max,
      children: children,
    );
  }

  double _getPaddingRight(BuildContext context, double left) {
    try {
      final double childWidth = _getSizeWidget(onBoardingData.currentKey).width;
      double width = MediaQuery.of(context).size.width;
      return width - left - childWidth;
    } catch (ex) {
      return 0;
    }
  }

  Size _getSizeWidget(GlobalKey<State<StatefulWidget>> currentKey) {
    try {
      final RenderBox findRenderObject = currentKey.currentContext.findRenderObject();

      return findRenderObject.size;
    } catch (ex) {
      return Size.zero;
    }
  }

  Widget _setDefaultSize(Widget child) {
    return child is EasyOnBoardingObject
        ? SizedBox.fromSize(child: child, size: _getSizeWidget(onBoardingData.currentKey))
        : child;
  }
}
