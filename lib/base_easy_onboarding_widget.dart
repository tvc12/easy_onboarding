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

abstract class BaseEasyOnBoardingWidget extends StatefulWidget {
  final Duration timeShowTooltips;
  final EasyOnBoardingBuilder builder;
  final EasyOnBoardingData onBoardingData;

  BaseEasyOnBoardingWidget({
    @required this.onBoardingData,
    Key key,
    this.timeShowTooltips = const Duration(milliseconds: 300),
  })  : builder = null,
        assert(onBoardingData != null, 'onBoardingData musn\'t null'),
        super(key: key);

  BaseEasyOnBoardingWidget.builder({
    @required this.builder,
    @required this.onBoardingData,
    Key key,
    this.timeShowTooltips = const Duration(milliseconds: 300),
  })  : assert(builder is EasyOnBoardingBuilder, 'builder musn\'t null'),
        assert(onBoardingData != null, 'onBoardingData musn\'t null'),
        super(key: key);

  @override
  BaseEasyOnBoardingState createState();
}

abstract class BaseEasyOnBoardingState extends State<BaseEasyOnBoardingWidget> {
  EasyOnBoardingBuilder get builder => widget.builder;

  GlobalKey get currentKey => widget.onBoardingData.currentKey;

  String get description => widget.onBoardingData.description;

  EasyOnBoardingDirection get direction => widget.onBoardingData.direction;

  CrossAxisAlignment get crossAxisAlignment => widget.onBoardingData.crossAxisAlignment;

  MainAxisAlignment get mainAxisAlignment => widget.onBoardingData.mainAxisAlignment;

  bool showOnBoarding = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showOnBoarding = true;
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
          showOnBoarding ? _buildOnBoarding(context) : SizedBox(),
        ],
      ),
    );
  }

  Widget _buildOnBoarding(BuildContext context) {
    return FutureBuilder<void>(
      future: Future<void>.delayed(widget.timeShowTooltips),
      builder: (_, AsyncSnapshot<void> snapShot) {
        switch (snapShot.connectionState) {
          case ConnectionState.done:
            return buildOnBoardingLayer(context, currentKey);
          default:
            return SizedBox();
        }
      },
    );
  }

  Widget buildBlurLayer() {
    return BackdropFilter(
      child: Container(
        color: Color.fromARGB(178, 18, 18, 18),
      ),
      filter: ImageFilter.blur(
        sigmaX: 1,
        sigmaY: 1,
      ),
    );
  }

  Widget buildOnBoardingLayer(BuildContext context, GlobalKey currentKey);

  void onTapCancel() {
    Navigator.of(context).pop();
  }
}
