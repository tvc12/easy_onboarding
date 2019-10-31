part of easy_onboarding;

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
