part of easy_onboarding;

abstract class EasyOnboardingObject extends Widget {
  /// Clone object, remove global key because flutter don't allow two key same time
  Widget cloneWithoutGlobalKey();
}

enum EasyOnboardingDirection {
  BottomToTop,
  TopToBottom,
}

typedef EasyOnboardingBuilder = Widget Function(
  BuildContext context,
  Widget child,
  Widget arrowWidget,
  Widget toolTipWidget,
  Offset position,
);

abstract class BaseEasyOnboardingWidget extends StatefulWidget {
  final GlobalKey currentKey;
  final String description;
  final Duration timeShowTooltips;
  final EasyOnboardingBuilder builder;

  const BaseEasyOnboardingWidget({
    @required this.currentKey,
    @required this.description,
    Key key,
    this.timeShowTooltips = const Duration(milliseconds: 300),
  })  : builder = null,
        assert(currentKey is GlobalKey, 'currentKey musn\'t null'),
        assert(description is String, 'description musn\'t null'),
        assert(timeShowTooltips is Duration, 'timeShowTooltips musn\'t null'),
        super(key: key);

  const BaseEasyOnboardingWidget.builder({
    @required this.builder,
    @required this.currentKey,
    @required this.description,
    Key key,
    this.timeShowTooltips = const Duration(milliseconds: 300),
  })  : assert(builder is EasyOnboardingBuilder, 'builder musn\'t null'),
        assert(currentKey is GlobalKey, 'currentKey musn\'t null'),
        assert(description is String, 'description musn\'t null'),
        assert(timeShowTooltips is Duration, 'timeShowTooltips musn\'t null'),
        super(key: key);

  @override
  BaseEasyOnboardingState createState();
}

abstract class BaseEasyOnboardingState extends State<BaseEasyOnboardingWidget> {
  GlobalKey get currentKey => widget.currentKey;
  String get description => widget.description;

  bool showOnboarding = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showOnboarding = true;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTapCancel,
      child: Stack(
        children: <Widget>[
          buildBlurLayer(),
          showOnboarding ? _buildOnboarding() : SizedBox(),
        ],
      ),
    );
  }

  Widget _buildOnboarding() {
    return FutureBuilder<void>(
      future: Future<void>.delayed(widget.timeShowTooltips),
      builder: (_, AsyncSnapshot<void> snapShot) {
        switch (snapShot.connectionState) {
          case ConnectionState.done:
            return buildOnboardingLayer(currentKey);
          default:
            return SizedBox();
        }
      },
    );
  }

  Widget buildBlurLayer() {
    return BackdropFilter(
      child: Container(
        color: Color.fromARGB((0.7 * 255).toInt(), 18, 18, 18),
      ),
      filter: ImageFilter.blur(
        sigmaX: 1,
        sigmaY: 1,
      ),
    );
  }

  Widget buildOnboardingLayer(GlobalKey currentKey);

  void onTapCancel() {
    Navigator.of(context).pop();
  }
}

class EasyOnboardingState extends BaseEasyOnboardingState {
  EasyOnboardingBuilder get builder => widget.builder;
  @override
  Widget buildOnboardingLayer(GlobalKey currentKey) {
    final Widget child = _getOnboardingWidget(currentKey);
    final Offset point = getPosition(currentKey) ?? Offset.zero;
    final Widget arrowWidget = buildArrow();
    final Widget tootlTipWidget = buildDescription(widget.description);
    // return child != null
    //     // ? builder(
    //     //     child.cloneWithoutGlobalKey(),
    //     //     arrowWidget,
    //     //     tootlTipWidget,
    //     //     point,
    //     //     _defaultLayout,
    //     //   )
    //     : SizedBox();
  }

  Widget buildArrow() {
    return Container(
      width: 40,
      height: 40,
      child: Icon(Icons.arrow_drop_down),
    );
  }

  Widget _getOnboardingWidget(GlobalKey currentKey) {
    final EasyOnboardingObject child = currentKey.currentWidget;
    assert(
      child is EasyOnboardingObject,
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
        // color: XedColors.waterMelon,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 290),
        child: Text(
          description,
          textAlign: TextAlign.center,
          // style: RegularTextStyle(16).copyWith(
          //   height: 1.4,
          //   fontSize: 16,
          //   color: XedColors.white255,
          // ),
        ),
      ),
    );
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
