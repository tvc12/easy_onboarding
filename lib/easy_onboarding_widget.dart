part of easy_onboarding;

class EasyOnBoardingWidget extends BaseEasyOnBoardingWidget {
  @override
  BaseEasyOnBoardingState createState() => EasyOnBoardingState();
}

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

  Offset getPosition(GlobalKey<State<StatefulWidget>> currentKey) {
    try {
      final RenderBox findRenderObject = currentKey.currentContext.findRenderObject();

      return findRenderObject.localToGlobal(Offset.zero);
    } catch (ex) {
      debugPrint('Error $runtimeType.getPosition $ex');
      return null;
    }
  }

  @override
  Widget defaultBuilder(
    BuildContext context,
    Widget widgetOnBoarding,
    Widget arrowWidget,
    Widget descriptionWidget,
    Offset position,
  ) {
    final bool isTopToBottom = direction == EasyOnBoardingDirection.TopToBottom;
    final BaseOnBoardingWidgetBuilder child = isTopToBottom
        ? _TopToBottomOnBoardingBuilder(
            onBoardingData: widget.onBoardingData,
            child: widgetOnBoarding,
            arrowWidget: arrowWidget,
            descriptionWidget: descriptionWidget,
            position: position,
          )
        : _BottomToTopOnBoardingBuilder(
            onBoardingData: widget.onBoardingData,
            child: widgetOnBoarding,
            arrowWidget: arrowWidget,
            descriptionWidget: descriptionWidget,
            position: position,
          );

    return child;
  }
}
