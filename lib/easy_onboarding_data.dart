part of easy_onboarding;

class EasyOnBoardingData {
  final GlobalKey currentKey;
  final String description;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final EasyOnBoardingDirection direction;

  const EasyOnBoardingData.left({
    @required this.currentKey,
    @required this.description,
    this.direction = EasyOnBoardingDirection.TopToBottom,
  })  : this.crossAxisAlignment = CrossAxisAlignment.start,
        this.mainAxisAlignment = MainAxisAlignment.start;

  const EasyOnBoardingData.right({
    @required this.currentKey,
    @required this.description,
    this.direction = EasyOnBoardingDirection.TopToBottom,
  })  : this.crossAxisAlignment = CrossAxisAlignment.end,
        this.mainAxisAlignment = MainAxisAlignment.end;

  const EasyOnBoardingData.custom({
    @required this.currentKey,
    @required this.description,
    @required this.crossAxisAlignment,
    @required this.mainAxisAlignment,
    this.direction = EasyOnBoardingDirection.TopToBottom,
  });
}
